module InterruptCatcher(externalInterrupts, PSWI, setInterrupt, interrupt);
	
parameter WIDTH = 16;

input		wire[WIDTH - 1 : 0]	externalInterrupts, setInterrupt;
input		wire								PSWI;
output	reg	[WIDTH - 1 : 0] interrupt;

integer i;

always @(*) begin
	for (i = 0; i < WIDTH; i = i + 1) begin
		interrupt[i] = (externalInterrupts[i] && PSWI) || setInterrupt[i];
 	end
end	
	
endmodule