module SimpleInstructionTestBench(input wire dummy);
	
wire clock;
ClockGenerator clockGenerator(
	.clock(clock)
);	

wire	[31 : 0]	address;
wire	[7	: 0]	dataIn, dataOut;
wire 				readRequest, mio, enable;
reg				cpuReset;
reg	[15 : 0] interruptLines;

Memory #(32,1024) memory (
	.address(address),
	.mio(mio),
	.dataBusIn(dataOut),
	.dataBusOut(dataIn),
	.readRequest(readRequest),
	.enable(enable),
	.clock(clock)
);

CPU  cpu (
	.clock(clock),
	.reset(cpuReset),
	.addressBus(address),
	.mio(mio),
	.dataBusIn(dataIn),
	.dataBusOut(dataOut),
	.readRequest(readRequest),
	.enable(enable),
	.externalInterrupts(interruptLines)
);

SevenSegmentController sevenSegmentController (
	.clock(clock),
	.addressBus(address),
	.dataBusIn(dataOut), 
	.readWrite(readRequest),
	.mio(mio),
	.enable(enable)
);

LedController ledController (
	.addressBus(address),
	.dataBusIn(dataOut),
	.readRequest(readRequest),
	.mio(mio),
	.enable(enable),
	.clock(clock)
);

initial begin
	cpuReset 		= 1;
	
	repeat(4) @(posedge clock);
		
	cpuReset 		= 0;
	
	repeat(1000) @(posedge clock);
	
	interruptLines[4] = 1;
	repeat(4) @(posedge clock);
	interruptLines[4] = 0;
	
	repeat(1000) @(posedge clock);
	
	$finish();
end

endmodule