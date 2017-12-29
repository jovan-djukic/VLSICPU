module TimerTestBench();

reg reset;
wire clock, pulse;	

ClockGenerator clockGenerator(
	.clock(clock)
);
	
Timer #(1000) timer (
	.clock(clock),
	.reset(reset),
	.pulse(pulse)
);
	
always begin
	reset <= 1;
	
	@(posedge clock) reset <= 0;
	
	repeat (2000) @(posedge clock);
		
	$finish;
end
	
endmodule