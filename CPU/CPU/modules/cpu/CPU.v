`include "instructions.vh"

module CPU(addressBus, mio, dataBusIn, dataBusOut, readRequest, enable, clock, reset, externalInterrupts);

output wire	[31 : 0]	addressBus; 
output wire          mio, readRequest, enable;
output wire	[7  : 0]	dataBusOut; 

input wire	        clock, reset;
input wire [7  : 0] dataBusIn;
input	wire [15 : 0] externalInterrupts;

//states
`define RESET_SYSTEM_WAIT           		0
`define INSTRUCTION_FETCH						1
`define INSTRUCTION_FETCH_WAIT				2
`define INSTRUCTION_DECODE						3
`define EXECUTION_WAIT							4
`define EXECUTION									5
`define MEMORY_ACCESS							6
`define MEMORY_ACCESS_WAIT						7
`define WRITE_BACK								8
`define INTERRUPT_RETURN 						9
`define INTERRUPT_RETURN_LR_READ_WAIT  	10
`define INTERRUPT_RETURN_PSW_READ_WAIT  	11
`define INTERRUPT_HANDLE 						12
`define INTERRUPT_HANDLE_PSW_WRITE_WAIT	13
`define INTERRUPT_HANDLE_LR_WRITE_WAIT 	14
`define INTERRUPT_HANDLE_PC_READ_WAIT		15

reg[3 : 0] state;

//Reset latch
reg	resetClear;
wire	resetValue;

RSFlipFlop resetDFlipFlop(
	.set(reset),
	.reset(resetClear),
	.clock(clock),
	.q(resetValue)
);

`define READ  1
`define WRITE 0

wire [31 : 0] dataOut, address, dataIn;
wire			  ready, isMemory, readWrite, isLoad;
reg	        enableInterface;

MemoryInterface #(32,32,8,3) MemoryInterface_instance (
	.address(address),
	.clockCount(3'b010),
	.dataIn(dataIn),
	.readWrite(readWrite),
	.clock(clock),
	.enable(enable),
	.enableInterface(enableInterface),
	.isMemory(isMemory),
	.reset(resetValue),
	.addressBus(addressBus),
	.dataBusIn(dataBusIn),
	.dataBusOut(dataBusOut),
	.mio(mio),
	.dataOut(dataOut),
	.readRequest(readRequest),
	.ready(ready)
);

reg[31 : 0] registers[0 : 15], PC, LR, SP, PSW, IR, A, B, IMM, NV;

function [31 : 0] readFromRegister(input [4 : 0] source);
	begin
		case (source)
			0, 1, 2, 3, 4, 5, 
			6, 7, 8, 9, 10, 11, 
			12, 13, 14, 15 : begin
				readFromRegister = registers[source];
			end
			`PC: begin
				readFromRegister = PC;
			end
			`LR: begin
				readFromRegister = LR;
			end
			`SP: begin
				readFromRegister = SP;
			end
			`PSW: begin
				readFromRegister = PSW;
			end
			default: begin
				readFromRegister = {32{1'b0}};
			end 
		endcase
	end
endfunction

task writeToRegister(input [4	: 0] destination, input [31	: 0] value);
	begin
		case (destination)
			0, 1, 2, 3, 4, 5, 
			6, 7, 8, 9, 10, 11, 
			12, 13, 14, 15 : begin
				registers[destination] <= value;
			end
			`PC: begin
				PC <= value;
			end
			`LR: begin
				LR <= value;
			end
			`SP: begin
				SP <= value;
			end
			`PSW: begin
				PSW <= value;
			end
			default: begin
				//nothing to do here
			end 
		endcase
	end
endtask

//these wires needed to be moved up here because of the address line of memory interface
wire	[31 : 0]	interruptRoutineAddress, effectiveAddress;

assign address = 	resetValue == 1 || state == `RESET_SYSTEM_WAIT ? {32{1'b0}} :
						state == `INSTRUCTION_FETCH || state == `INSTRUCTION_FETCH_WAIT ? PC : 
						state == `INTERRUPT_HANDLE || state == `INTERRUPT_HANDLE_PSW_WRITE_WAIT ||
						state == `INTERRUPT_HANDLE_LR_WRITE_WAIT || state == `INTERRUPT_RETURN ||
						state == `INTERRUPT_RETURN_LR_READ_WAIT || state == `INTERRUPT_RETURN_PSW_READ_WAIT ? SP :
						state == `INTERRUPT_HANDLE_PC_READ_WAIT ? interruptRoutineAddress :  effectiveAddress;

assign isMemory = resetValue == 1 ||
						state == `RESET_SYSTEM_WAIT || 
						state == `INSTRUCTION_FETCH || 
						state == `INSTRUCTION_FETCH_WAIT || 
						IR[`INSTRUCTION_OPERATION_CODE] == `LOAD_STORE ||
						state[3] == 1 ? 1'b1 : 1'b0; 

assign readWrite = resetValue == 1 || 
						 state == `RESET_SYSTEM_WAIT ||
						 state == `INSTRUCTION_FETCH || 
					  	 state == `INSTRUCTION_FETCH_WAIT ||
						 isLoad == 1 ||
						 state == `INTERRUPT_RETURN ||
						 state == `INTERRUPT_RETURN_LR_READ_WAIT ||
						 state == `INTERRUPT_RETURN_PSW_READ_WAIT ||
						 state == `INTERRUPT_HANDLE_PC_READ_WAIT ? `READ : `WRITE;

assign dataIn = state == `INTERRUPT_HANDLE || state == `INTERRUPT_HANDLE_PSW_WRITE_WAIT ? PSW :
					 state == `INTERRUPT_HANDLE_LR_WRITE_WAIT ? LR : B;

task resetSystem();
	begin
		//read from address 0
		enableInterface <= 1;
		
		//change state
		state 		<= `RESET_SYSTEM_WAIT;
		resetClear 	<= 1;
	end
endtask

task resetSystemWait();
	begin
		if (ready == 1) begin
			PC 	<= dataOut;
			state <= `INSTRUCTION_FETCH;
		end else begin
			enableInterface	<= 0;
			resetClear 			<= 0;
		end
	end
endtask

task instructionFetch();
	begin
		enableInterface	<= 1;
		state					<= `INSTRUCTION_FETCH_WAIT;
	end
endtask

task instructionFetchWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			IR <= dataOut;
			PC <= PC + 4;
		
			//next state
			state <= `INSTRUCTION_DECODE;
		end else begin
			enableInterface <= 0;
		end
	end	
endtask

wire	[3		: 0]	ALUOperationCode;
wire	[4		: 0]	destination, sourceA, sourceB;
wire 	[31	: 0]  immediate;
wire					isSecondImmediate, updatesZero, updatesNegative, updatesCarry, updatesOverflow, invalid;
wire	[2		: 0]	addressMode;
wire	[31	: 0]	offset;

InstructionDecoder  instructionDecoder (
	.IR(IR),
	.ALUOperationCode(ALUOperationCode),
	.sourceA(sourceA),
	.sourceB(sourceB),
	.destination(destination),
	.immediate(immediate),
	.isSecondImmediate(isSecondImmediate),
	.updatesZero(updatesZero),
	.updatesNegative(updatesNegative),
	.updatesCarry(updatesCarry),
	.updatesOverflow(updatesOverflow),
	.offset(offset),
	.invalid(invalid)
);

wire conditionSatisfied;
ConditionDecoder conditionDecoder (
	.condtionSelect(IR[`INSTRUCTION_CONDITION]),
	.zero(PSW[`Z]),
	.carry(PSW[`C]),
	.negative(PSW[`N]),
	.overflow(PSW[`O]),
	.conditionSatisfied(conditionSatisfied)
);

reg	[15 	: 0]	setInterrupt, resetInterrupt;
wire					interruptPresent;
wire	[3		: 0]	interruptNumberWire;
reg	[3 	: 0]	interruptNumber;

InterruptHandler #(16, 32, 4) interruptHandler (
	.externalInterrupts(externalInterrupts),
	.setInterrupt(setInterrupt),
	.resetInterrupt(resetInterrupt),
	.PSWI(PSW[`I]),
	.address(interruptRoutineAddress),
	.interruptPresent(interruptPresent),
	.interruptNumber(interruptNumberWire),
	.clock(clock)
);

reg startDivision;

task instructionDecode();
	begin
		A 		<= readFromRegister(sourceA);
		B 		<= readFromRegister(sourceB);
		IMM	<= immediate;
		
		//set interrupt
		
		//change state
		if (conditionSatisfied == 1) begin
			if (invalid == 1) begin
				//set interruopt
				setInterrupt[`INVALID_INSTRUCTION_INTERRUPT] <= 1;
				
				//go to interrupt handle
				state <= `INTERRUPT_HANDLE;
			end else if (IR[`INSTRUCTION_OPERATION_CODE] == `INTERRUPT) begin
				//set interrupt 
				setInterrupt[IR[`INTERRUPT_SOURCE]] <= 1;
				
				//go to interrupt handle
				state <= `INTERRUPT_HANDLE;
			end else if (IR[`INSTRUCTION_OPERATION_CODE] == `DIVISION) begin
				startDivision 	<= 1;
				state 			<= `EXECUTION_WAIT;
			end else begin
				state	<= `EXECUTION;	
			end
		end else if (interruptPresent) begin
			state <= `INTERRUPT_HANDLE;
		end else begin
			state <= `INSTRUCTION_FETCH;
		end
	end
endtask

//arithemtic/logic unit
wire	[31 : 0]	secondOperand, ALUResult, divisionResult, result;
wire				carry, overflow, zero, negative, divisionDone;

assign secondOperand = isSecondImmediate	== 1 ? IMM : B;

ALU  alu (
	.firstOperand(A),
	.secondOperand(secondOperand),
	.operation(ALUOperationCode),
	.result(ALUResult),
	.carry(carry),
	.zero(zero),
	.overflow(overflow),
	.negative(negative)
);

Divider #(32,6) divider (
	.dividend(A),
	.divider(secondOperand),
	.start(startDivision),
	.clock(clock),
	.quotient(divisionResult),
	.ready(divisionDone)
);

task executionWait();
	begin
		if (divisionDone == 1 && startDivision == 0) begin
			state <= `EXECUTION;
		end else begin
			startDivision <= 0;
		end
	end
endtask

assign result = IR[`INSTRUCTION_OPERATION_CODE] == `DIVISION ? divisionResult : ALUResult;

reg [31 : 0] executionResult;

//flags and values for EXECUTION and MEMORY_ACCESS phases
wire [31 : 0] base;
wire 			  isMemoryAccess, baseChange;

assign isMemoryAccess	= IR[`INSTRUCTION_OPERATION_CODE] == `LOAD_STORE || IR[`INSTRUCTION_OPERATION_CODE] == `IN_OUT;
assign isLoad				= (IR[`INSTRUCTION_OPERATION_CODE] == `LOAD_STORE && IR[`LOAD_STORE_IS_LOAD]) || 
								  (IR[`INSTRUCTION_OPERATION_CODE] == `IN_OUT && IR[`IN_OUT_IS_IN]) ? 1'b1 : 1'b0;
assign baseChange			= IR[`INSTRUCTION_OPERATION_CODE] == `LOAD_STORE && IR[`LOAD_STORE_BASE_CHANGE] != 2'b00;
assign base 				= IR[`LOAD_STORE_MODE_MSB] == 1 && IR[`INSTRUCTION_OPERATION_CODE] != `IN_OUT ? executionResult : A;

task execution();
	begin
		//write to both executionResult and newValue(NV) so you can skip this step afterwards
		executionResult <= result;
		NV			  		 <= result;
		
		//update flags
		if (IR[`INSTRUCTION_SET_FLAGS] == 1) begin
			if (updatesZero == 1) begin
				PSW[`Z] <= zero;
			end
			if (updatesOverflow == 1) begin
				PSW[`O] <= overflow;
			end		
			if (updatesCarry == 1) begin
				PSW[`C] <= carry;
			end
			if (updatesNegative == 1) begin
				PSW[`N] <= negative;
			end
		end
		
		if (IR[`INSTRUCTION_OPERATION_CODE] == `CALL) begin
			LR <= PC;
		end
		
		if (isMemoryAccess == 1) begin
			state <= `MEMORY_ACCESS;
		end else begin
			state <= `WRITE_BACK;
		end
	end
endtask

//Address calculator
Adder #(32) addressCalculator (
	.firstOperand(base),
	.secondOperand(offset),
	.result(effectiveAddress)
);
	
task memoryAccess();
	begin
		//perform access to memory
		if (baseChange == 1) begin
			writeToRegister(sourceA, executionResult);
		end
		enableInterface <= 1;
		
		state <= `MEMORY_ACCESS_WAIT;
	end
endtask

task memoryAccessWait();
	begin
		enableInterface <= 0;
		if (ready == 1 && enableInterface == 0) begin
			NV 	<= dataOut;
			state <= `WRITE_BACK;
		end
	end
endtask
	
task writeBack();
	begin
		
		if (IR[`INSTRUCTION_OPERATION_CODE] != `COMPARISON && IR[`INSTRUCTION_OPERATION_CODE] != `TEST && (IR[`INSTRUCTION_OPERATION_CODE] != `LOAD_STORE || IR[`LOAD_STORE_IS_LOAD] != 0)) begin
			writeToRegister(destination, NV);
		end
		
		if (IR[`INSTRUCTION_OPERATION_CODE] == `MOVE_SHIFT && IR[`MOVE_SHIFT_DESTINATION] == `PC && IR[`INSTRUCTION_SET_FLAGS] == 1) begin
			state <= `INTERRUPT_RETURN;
		end else if (interruptPresent == 1) begin
			state <= `INTERRUPT_HANDLE;
		end else begin
			state <= `INSTRUCTION_FETCH;
		end 
	end
endtask

task interruptReturn();
	begin
		PC 					<= LR;
		enableInterface	<= 1;
		state 				<= `INTERRUPT_RETURN_LR_READ_WAIT;
	end
endtask

task interruptReturnLRReadWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			LR 	<= dataOut;
			SP 	<= SP + 4;
			state	<= `INTERRUPT_RETURN_PSW_READ_WAIT;
			
			enableInterface <= 1;
		end else begin
			enableInterface <= 0;
		end
	end
endtask

task interruptReturnPSWReadWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			PSW	<= dataOut;
			SP 	<= SP + 4;
			
			if (interruptPresent == 1) begin
				state	<= `INTERRUPT_HANDLE;
			end else begin
				state <= `INSTRUCTION_FETCH;
			end
		end else begin
			enableInterface <= 0;
		end
	end
endtask

task interruptHandle();
	begin
		SP	<= SP - 4;
		
		enableInterface <= 1;
		
		//save interrupt number and reset
		interruptNumber <= interruptNumberWire; 
		
		//change state
		state <= `INTERRUPT_HANDLE_PSW_WRITE_WAIT;
	end
endtask
	
task interruptHandlePSWWriteWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			SP 	 	<= SP - 4;
			
			enableInterface <= 1;
			
			//change state
			state <= `INTERRUPT_HANDLE_LR_WRITE_WAIT; 
		end else begin
			enableInterface <= 0;
		end
	end
endtask	

task interruptHandleLRWriteWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			LR <= PC;
			
			enableInterface <= 1;
			
			//change state
			state <= `INTERRUPT_HANDLE_PC_READ_WAIT;
		end else begin
			enableInterface <= 0;
		end
	end
endtask

task interruptHandlePCReadWait();
	begin
		if (ready == 1 && enableInterface == 0) begin
			PC <= dataOut;
			
			//reset interrupt1
			resetInterrupt[interruptNumber] <= 0;
			
			//change state
			state <= `INSTRUCTION_FETCH;
		end else begin
			//reset PSWI
			PSW[`I]	<= 0;
		
			//reset interrupt
			resetInterrupt[interruptNumber] <= 1;
			//since i am the only that is setting these, i can always reset it 
			setInterrupt[IR[`INTERRUPT_SOURCE]] <= 0;
		
			enableInterface <= 0;
		end
	end
endtask

always @(posedge clock) begin 
	if (resetValue == 1) begin
		resetSystem();
	end else begin
	case (state)
		`RESET_SYSTEM_WAIT: begin
			resetSystemWait();
		end
		
		`INSTRUCTION_FETCH: begin
			instructionFetch();
		end
		
		`INSTRUCTION_FETCH_WAIT: begin
			instructionFetchWait();
		end
		
		`INSTRUCTION_DECODE: begin
			instructionDecode();
		end
		
		`EXECUTION: begin
			execution();
		end
		
		`EXECUTION_WAIT: begin
			executionWait();
		end
		
		`MEMORY_ACCESS: begin
			memoryAccess();
		end
		
		`MEMORY_ACCESS_WAIT: begin
			memoryAccessWait();
		end
		
		`WRITE_BACK: begin
			writeBack();
		end
		
		`INTERRUPT_RETURN: begin
			interruptReturn();
		end
		
		`INTERRUPT_RETURN_LR_READ_WAIT: begin
			interruptReturnLRReadWait();
		end
		
		`INTERRUPT_RETURN_PSW_READ_WAIT: begin
			interruptReturnPSWReadWait();
		end
		
		`INTERRUPT_HANDLE: begin
			interruptHandle();
		end
		
		`INTERRUPT_HANDLE_PSW_WRITE_WAIT: begin
			interruptHandlePSWWriteWait();
		end
		
		`INTERRUPT_HANDLE_LR_WRITE_WAIT: begin
			interruptHandleLRWriteWait();
		end
		
		`INTERRUPT_HANDLE_PC_READ_WAIT: begin
			interruptHandlePCReadWait();
		end
		
		endcase
	end
end	
endmodule