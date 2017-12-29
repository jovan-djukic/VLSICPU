module MemoryInterface(addressBus, dataBusIn, dataBusOut, mio, readRequest, enable, clock, address, dataIn, dataOut, isMemory, readWrite , clockCount, ready, enableInterface, reset);
	
	// 1 - read
	// 0 - write
	
	parameter ADDRESS_BUS_WIDTH 	= 32;
	parameter DATA_WIDTH				= 32;
	parameter DATA_BUS_WIDTH		= 8;
	parameter CLOCK_COUNT_WIDTH	= 3;

	localparam NUMBER_OF_BYTES 	= (DATA_WIDTH - 1) / DATA_BUS_WIDTH;
	localparam BYTE_COUNTER_WIDTH	= NUMBER_OF_BYTES <= 2 ? 1 :
											  NUMBER_OF_BYTES <= 4 ? 2 :
											  NUMBER_OF_BYTES <= 8 ? 3 : 4;
	
	input wire [ADDRESS_BUS_WIDTH - 1 : 0] address;
	input wire [CLOCK_COUNT_WIDTH - 1 : 0] clockCount;
	input wire [DATA_WIDTH - 1			 : 0] dataIn;
	input wire [DATA_BUS_WIDTH - 1    : 0] dataBusIn;
	input wire 										readWrite, clock, enableInterface, isMemory, reset;
	
	output wire [ADDRESS_BUS_WIDTH - 1		: 0] addressBus;
	output wire [DATA_BUS_WIDTH - 1			: 0] dataBusOut;
	output wire 										  mio;
	output wire 						              readRequest;
	output reg											  enable;
	output wire [DATA_WIDTH - 1			   : 0] dataOut;
	output reg											  ready;

	reg [CLOCK_COUNT_WIDTH - 1		: 0] clockCounter;
	reg [BYTE_COUNTER_WIDTH - 1	: 0] byteCounter;
	reg [ADDRESS_BUS_WIDTH - 1		: 0] memoryAddressRegister;
	reg [DATA_WIDTH - 1				: 0] memoryDataRegister;
	reg										  working;

	assign addressBus  = memoryAddressRegister;
	assign dataBusOut	 = memoryDataRegister[(byteCounter * 8) +: 8];
	assign mio			 = isMemory;
	assign readRequest = readWrite;
		
	assign dataOut = memoryDataRegister;

	always @(posedge clock) begin
		if (reset == 1) begin
			working			<= 0;
			ready 			<= 0;
			enable 			<= 0;
		end else if (enableInterface == 1) begin
			memoryAddressRegister <= address;
			
			if (readWrite == 0) begin
				memoryDataRegister	<= dataIn;
			end
			
			clockCounter	<= clockCount;
			byteCounter		<= 0;
			ready 			<= 0;
			working			<= 1;		
			enable			<= 1;
	 	end else if (working == 1) begin
			if (clockCounter != 0) begin 
				clockCounter <= clockCounter - 1;
			end else if (clockCounter == 0) begin
				if (readWrite == 1) begin
					memoryDataRegister[(byteCounter * 8) +: 8] <= dataBusIn;
				end
				byteCounter <= byteCounter + 1; 
				if (byteCounter != NUMBER_OF_BYTES) begin
					clockCounter				<= clockCount;
					memoryAddressRegister	<= memoryAddressRegister + 1;
				end else begin
					ready				<= 1;
					working			<= 0;
					enable			<= 0;
				end
		 	end
	 	end
	end
endmodule