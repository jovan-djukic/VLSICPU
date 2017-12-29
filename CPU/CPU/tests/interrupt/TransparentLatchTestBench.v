module TransparentLatchTestBench();
	
reg set, reset;
wire value;

TransparentLatch  TransparentLatch_instance (
	.set(set),
	.reset(reset),
	.value(value)
);	

initial begin

	set = 1;
	
	#2
	
	set = 0;
	
	#2
	
	reset = 1;
	
	#2
	
	set 	= 1;
	reset = 1;

	#2
	
	set = 0;
	
	#2
	
	reset = 0;

	$finish;
end

endmodule