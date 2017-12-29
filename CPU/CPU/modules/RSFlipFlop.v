module RSFlipFlop(
	input wire set,
	input wire reset,
	input wire clock,
	output reg q
);

always @(posedge clock) begin
	if (reset) begin
		q <= 1'b0;
	end else if(set) begin 
		q <= 1'b1;
	end
end

endmodule