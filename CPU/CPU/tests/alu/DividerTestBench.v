module DividerTestBench();
	
	wire clock;
	ClockGenerator clockGenerator (
		.clock(clock)
	);
	
	localparam WIDTH 				 = 32;
	localparam COUNTER_WIDTH = 6;
	
	reg [WIDTH - 1	: 0] dividend, divider;
	reg									 start;
	
	wire [WIDTH - 1	: 0] quotient;
	wire								 ready;
	
	Divider #(WIDTH, COUNTER_WIDTH) dividerDUT (
	.dividend(dividend),
	.divider(divider),
	.start(start),
	.clock(clock),
	.quotient(quotient),
	.ready(ready)
);
	
initial begin

	@(posedge clock);
	dividend = 11;
	divider = 3;
	start = 1;
	@(posedge clock);
	start = 0;
	repeat(5) @(posedge clock);
	
	dividend = 6;
	divider = 2;
	start = 1;
	@(posedge clock);
	start = 0;
	repeat(5) @(posedge clock);
		
	dividend = 9;
	divider = 2;
	start = 1;
	@(posedge clock);
	start = 0;
	repeat(5) @(posedge clock);
	
	$finish;
end	

endmodule