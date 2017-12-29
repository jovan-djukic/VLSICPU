`include "instructions.vh"
`include "../alu/ALU.vh"

module InstructionDecoder(
	input		wire	[31 : 0]	IR,
	output	reg	[3  : 0] ALUOperationCode,
	output 	reg	[4  : 0]	sourceA,
	output	reg	[4	 : 0]	sourceB,
	output 	reg	[4  : 0]	destination,
	output 	reg	[31 : 0]	immediate,
	output	reg				isSecondImmediate,
	output	reg	[31 :	0]	offset,
	output	reg				updatesZero,
	output  	reg				updatesNegative,
	output	reg				updatesCarry,
	output 	reg				updatesOverflow,
	output	reg				invalid
);
	
//do not forget to assign values to all outputs or it won't be combo logic
always @(*) begin
	
	ALUOperationCode 	= {4{1'b0}};			
	sourceA			  	= {5{1'b0}};
	sourceB			  	= {5{1'b0}};
	immediate		  	= {32{1'b0}};
	isSecondImmediate	= 1'b0;
	destination			= {5{1'b0}};
	updatesZero			= 1'b0;
	updatesNegative	= 1'b0;
	updatesCarry		= 1'b0;
	updatesOverflow	= 1'b0;
	offset				= {31{1'b0}};
	invalid				= 1'b0;	
	
	case (IR[`INSTRUCTION_OPERATION_CODE])
		
		`INTERRUPT: begin
			//no code needed
		end
		
		`ADDITION: begin
			ALUOperationCode	= `ALU_ADD;
			sourceA				= IR[`ARITHMETIC_DESTINATION];
			sourceB				= IR[`ARITHMETIC_SOURCE];
			destination			= IR[`ARITHMETIC_DESTINATION];
			immediate			= {{14{IR[`ARITHMETIC_IMMEDIATE_MSB]}}, IR[`ARITHMETIC_IMMEDIATE]};
			isSecondImmediate	= IR[`ARITHMETIC_IS_IMMEDIATE];	
		
			//flags update
			updatesZero		 = 1;
			updatesNegative = 1;
			updatesCarry	 = 1;
			updatesOverflow = 1;
			
			//invalid instruction based on specification
			invalid = IR[`ARITHMETIC_DESTINATION] == `PSW 
			       || IR[`ARITHMETIC_SOURCE] == `PSW; 
		end
		
		`SUBTRACTION: begin
			ALUOperationCode 	= `ALU_SUB;
			sourceA			  	= IR[`ARITHMETIC_DESTINATION];
			sourceB			  	= IR[`ARITHMETIC_SOURCE];
			destination		  	= IR[`ARITHMETIC_DESTINATION];
			immediate			= {{14{IR[`ARITHMETIC_IMMEDIATE_MSB]}}, IR[`ARITHMETIC_IMMEDIATE]};
			isSecondImmediate	= IR[`ARITHMETIC_IS_IMMEDIATE];	
		
			//flags update
			updatesZero		 = 1;
			updatesNegative = 1;
			updatesCarry	 = 1;
			updatesOverflow = 1;
			
			//invalid instruction based on specification
			invalid = IR[`ARITHMETIC_DESTINATION] == `PSW 
			       || IR[`ARITHMETIC_SOURCE] == `PSW; 
		end
		
		`MULTIPLICATION: begin
			ALUOperationCode 	= `ALU_MUL;
			sourceA				= IR[`ARITHMETIC_DESTINATION];
			sourceB				= IR[`ARITHMETIC_SOURCE];
			destination			= IR[`ARITHMETIC_DESTINATION];
			immediate			= {{14{IR[`ARITHMETIC_IMMEDIATE_MSB]}}, IR[`ARITHMETIC_IMMEDIATE]};
			isSecondImmediate	= IR[`ARITHMETIC_IS_IMMEDIATE];		
		
			//flags update
			updatesZero		 = 1;
			updatesNegative = 1;
			
			//invalid instruction based on specification
			invalid = IR[`ARITHMETIC_DESTINATION] == `PSW 
						 || IR[`ARITHMETIC_DESTINATION] == `PC 
						 || IR[`ARITHMETIC_DESTINATION] ==`LR 
						 || IR[`ARITHMETIC_DESTINATION]== `SP 
						 || IR[`ARITHMETIC_SOURCE] == `PSW 
						 || IR[`ARITHMETIC_SOURCE] == `PC 
						 || IR[`ARITHMETIC_SOURCE] ==`LR 
						 || IR[`ARITHMETIC_SOURCE] == `SP; 
		end
		
		`DIVISION: begin
			ALUOperationCode	= `ALU_DIV;
			sourceA				= IR[`ARITHMETIC_DESTINATION];
			sourceB				= IR[`ARITHMETIC_SOURCE];
			destination			= IR[`ARITHMETIC_DESTINATION];
			immediate			= {{14{IR[`ARITHMETIC_IMMEDIATE_MSB]}}, IR[`ARITHMETIC_IMMEDIATE]};
			isSecondImmediate	= IR[`ARITHMETIC_IS_IMMEDIATE];		
		
			//flags update
			updatesZero		 = 1;
			updatesNegative = 1;
			
			//invalid instruction based on specification
			invalid = IR[`ARITHMETIC_DESTINATION] == `PSW 
						 || IR[`ARITHMETIC_DESTINATION] == `PC 
						 || IR[`ARITHMETIC_DESTINATION] ==`LR 
						 || IR[`ARITHMETIC_DESTINATION]== `SP 
						 || IR[`ARITHMETIC_SOURCE] == `PSW 
						 || IR[`ARITHMETIC_SOURCE] == `PC 
						 || IR[`ARITHMETIC_SOURCE] ==`LR 
						 || IR[`ARITHMETIC_SOURCE] == `SP; 
		end
		
		`COMPARISON: begin
			ALUOperationCode	= `ALU_SUB;
			sourceA				= IR[`ARITHMETIC_DESTINATION];
			sourceB				= IR[`ARITHMETIC_SOURCE];
			destination			= IR[`ARITHMETIC_DESTINATION];
			immediate			= {{14{IR[`ARITHMETIC_IMMEDIATE_MSB]}}, IR[`ARITHMETIC_IMMEDIATE]};
			isSecondImmediate	= IR[`ARITHMETIC_IS_IMMEDIATE];	
		
			//flags update
			updatesZero		 = 1;
			updatesNegative = 1;
			updatesCarry	 = 1;
			updatesOverflow = 1;
			
			//invalid instruction based on specification
			invalid = IR[`ARITHMETIC_DESTINATION] == `PSW 
						 || IR[`ARITHMETIC_DESTINATION] == `PC 
						 || IR[`ARITHMETIC_DESTINATION] ==`LR 
						 || IR[`ARITHMETIC_DESTINATION]== `SP 
						 || IR[`ARITHMETIC_SOURCE] == `PSW 
						 || IR[`ARITHMETIC_SOURCE] == `PC 
						 || IR[`ARITHMETIC_SOURCE] ==`LR 
						 || IR[`ARITHMETIC_SOURCE] == `SP; 
			end
			
		`AND: begin
			ALUOperationCode	= `ALU_AND;
			sourceA				= IR[`LOGICAL_DESTINATION];
			sourceB				= IR[`LOGICAL_SOURCE];
			destination			= IR[`LOGICAL_DESTINATION];
			isSecondImmediate	= 0;
			
			//flags update
			updatesZero		 =	1;
			updatesNegative = 1;
			
			//invalid instruction based on specification
			invalid = IR[`LOGICAL_DESTINATION] == `PC 
						 || IR[`LOGICAL_DESTINATION] == `LR 
						 || IR[`LOGICAL_DESTINATION] == `PSW 
						 || IR[`LOGICAL_SOURCE] == `PC 
						 || IR[`LOGICAL_SOURCE] == `LR 
						 || IR[`LOGICAL_SOURCE] == `PSW;
		end
		
		`OR: begin
			ALUOperationCode	= `ALU_OR;
			sourceA				= IR[`LOGICAL_DESTINATION];
			sourceB				= IR[`LOGICAL_SOURCE];
			destination			= IR[`LOGICAL_DESTINATION];
			isSecondImmediate	= 0;
			
			//flags update
			updatesZero		 =	1;
			updatesNegative = 1;
	
			//invalid instruction based on specification
			invalid = IR[`LOGICAL_DESTINATION] == `PC 
						 || IR[`LOGICAL_DESTINATION] == `LR 
						 || IR[`LOGICAL_DESTINATION] == `PSW 
						 || IR[`LOGICAL_SOURCE] == `PC 
						 || IR[`LOGICAL_SOURCE] == `LR 
						 || IR[`LOGICAL_SOURCE] == `PSW;
		end
		
		`NOT: begin
			ALUOperationCode	= `ALU_NOT;
			sourceA				= IR[`LOGICAL_DESTINATION];
			sourceB				= IR[`LOGICAL_SOURCE];
			destination			= IR[`LOGICAL_DESTINATION];
			isSecondImmediate	= 0;
			
			//flags update
			updatesZero		 =	1;
			updatesNegative = 1;
	
					//invalid instruction based on specification
			invalid = IR[`LOGICAL_DESTINATION] == `PC 
						 || IR[`LOGICAL_DESTINATION] == `LR 
						 || IR[`LOGICAL_DESTINATION] == `PSW 
						 ||	IR[`LOGICAL_SOURCE] == `PC 
						 || IR[`LOGICAL_SOURCE] == `LR 
						 || IR[`LOGICAL_SOURCE] == `PSW;
		end
		
		`TEST: begin
			ALUOperationCode	= `ALU_AND;
			sourceA				= IR[`LOGICAL_DESTINATION];
			sourceB				= IR[`LOGICAL_SOURCE];
			destination			= IR[`LOGICAL_DESTINATION];
			isSecondImmediate	= 0;
			
			//flags update
			updatesZero		 =	1;
			updatesNegative = 1;
	
			//invalid instruction based on specification
			invalid = IR[`LOGICAL_DESTINATION] == `PC 
						 || IR[`LOGICAL_DESTINATION] == `LR 
						 || IR[`LOGICAL_DESTINATION] == `PSW 
						 ||	IR[`LOGICAL_SOURCE] == `PC 
						 || IR[`LOGICAL_SOURCE] == `LR 
						 || IR[`LOGICAL_SOURCE] == `PSW;
		end
		
		`LOAD_STORE: begin
			ALUOperationCode	= `ALU_ADD;
			sourceA				= IR[`LOAD_STORE_ADDRESS_REGISTER];
			sourceB				= IR[`LOAD_STORE_DESTINATION];
			destination			= IR[`LOAD_STORE_DESTINATION];
			immediate			= {{29{IR[`LOAD_STORE_MODE_LSB]}}, 3'b100};
			offset				= {{22{IR[`LOAD_STORE_IMMEDIATE_MSB]}}, IR[`LOAD_STORE_IMMEDIATE]};
			isSecondImmediate	= 1;
		
			//invalid instruction based on specification
			invalid = (IR[`LOAD_STORE_ADDRESS_REGISTER] == `PC && IR[`LOAD_STORE_MODE] != 3'b000) 
							|| IR[`LOAD_STORE_ADDRESS_REGISTER] == `PSW; 
		end
		
		`CALL: begin
			ALUOperationCode	= `ALU_ADD;
			sourceA				= IR[`CALL_DESTINATION];
			destination			= `PC;
			immediate			= {{13{IR[`CALL_IMMEDIATE_MSB]}}, IR[`CALL_IMMEDIATE]};
			isSecondImmediate	= 1;
			
		end
		
		`IN_OUT: begin
			ALUOperationCode	= `ALU_ADD;
			sourceA				= IR[`IN_OUT_SOURCE];
			sourceB				= IR[`IN_OUT_DESTINATION];
			destination			= IR[`IN_OUT_DESTINATION];
			offset				= {32{1'b0}};
			isSecondImmediate	= 1;
		end
		
		`MOVE_SHIFT: begin
			//operation code for SHL and SHR differs in LSB, so we just concatenate
			ALUOperationCode	= {3'b010, IR[`MOVE_SHIFT_IS_LEFT]};
			sourceA				= IR[`MOVE_SHIFT_SOURCE];
			immediate			= {{27{1'b0}}, IR[`MOVE_SHIFT_IMMEDIATE]};
			isSecondImmediate	= 1;
			destination			= IR[`MOVE_SHIFT_DESTINATION];
		
			//flags update
			updatesZero		 = 1;
			updatesCarry	 = 1;
			updatesNegative = 1;
		end
		
		`LOAD_CONSTANT: begin
			ALUOperationCode	= {3'b101, IR[`LOAD_CONSTANT_IS_HIGH]};
			sourceA				= {1'b0, IR[`LOAD_CONSTANT_DESTINATION]};
			destination			= {1'b0, IR[`LOAD_CONSTANT_DESTINATION]};
			isSecondImmediate	= 1;
			immediate 			= {IR[`LOAD_CONSTANT_CONSTANT], IR[`LOAD_CONSTANT_CONSTANT]};	
		end

	endcase
	
end

endmodule