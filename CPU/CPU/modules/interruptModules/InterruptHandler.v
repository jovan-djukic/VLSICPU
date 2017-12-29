module InterruptHandler(externalInterrupts, PSWI, clock, setInterrupt, resetInterrupt, address, interruptPresent, interruptNumber);

parameter WIDTH			= 16;
parameter ADDRESS_WIDTH	= 32;
parameter NUMBER_WIDTH	= 4;

input	wire [WIDTH - 1 : 0] externalInterrupts, setInterrupt, resetInterrupt;
input	wire						PSWI;
input wire						clock;

output wire [ADDRESS_WIDTH -1	: 0] address;
output wire								  interruptPresent;
output wire [NUMBER_WIDTH - 1	:0]  interruptNumber;

wire	[WIDTH - 1 : 0] value;

RSFlipFlop dFlipFlop[WIDTH - 1 : 0] (
	.set(externalInterrupts),
	.reset(resetInterrupt),
	.clock(clock),
	.q(value)
);

InterruptPriorityEncoder #(WIDTH, ADDRESS_WIDTH, NUMBER_WIDTH) interruptPriorityEncoder(
	.externalInterrupts(value), 
	.PSWI(PSWI),
	.internalInterrupts(setInterrupt),
	.address(address),
	.interruptNumber(interruptNumber),
	.interruptPresent(interruptPresent)
);
	
endmodule
