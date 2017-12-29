module TransparentLatch(
	input		wire	set,
	input 	wire	reset,
	output 	wire	value
);
	
reg state;

assign value = state | set;

always @(set or reset) begin
	if (set == 1) begin
		state <= 1;
	end else if (reset == 1) begin
		state <= 0;
	end
end

endmodule