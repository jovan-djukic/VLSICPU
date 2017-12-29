module Divider(dividend, divider, start, clock, quotient, ready);
	
parameter WIDTH				 = 32;
parameter BIT_COUNTER_WIDTH = 5;

input [WIDTH - 1 : 0] dividend, divider;
input						 start, clock;

output wire [WIDTH - 1 : 0] quotient;
output wire						 ready;

reg [2 * WIDTH - 1			: 0] remainderAndQuotient;
reg [WIDTH - 1					: 0] difference, dividerTemp;
reg [BIT_COUNTER_WIDTH - 1	: 0] counter;
reg									  isNegative;

assign ready = !counter;	
assign quotient = !isNegative ? remainderAndQuotient[WIDTH - 1 : 0] : ~remainderAndQuotient[WIDTH - 1 : 0] + 1'b1;

always @(posedge clock) begin
	
	if (start == 1) begin
		counter = WIDTH;
	
		isNegative = (!dividend[WIDTH - 1] && divider[WIDTH - 1]) ||
								 (dividend[WIDTH - 1] && !divider[WIDTH - 1]);
		
		//assign positive numbers and the just chang the output
		dividerTemp = !divider[WIDTH - 1] ? divider : ~divider + 1'b1;

		remainderAndQuotient = !dividend[WIDTH - 1] ? {{WIDTH{1'b0}}, dividend} : {{WIDTH{1'b0}}, ~dividend + 1'b1};		
	end else if (ready == 0) begin
		difference = remainderAndQuotient[2 * WIDTH - 2 : WIDTH - 1] - dividerTemp;
		
		if (difference[WIDTH - 1] == 1) begin
			remainderAndQuotient = {remainderAndQuotient[2 * WIDTH - 2 : 0], 1'b0};
		end else begin
			remainderAndQuotient = {difference[WIDTH - 1 : 0], remainderAndQuotient[WIDTH - 2 : 0], 1'b1};
		end
	
		counter = counter - 1;
	end else begin
		counter = 0;
	end 
	
end
	
endmodule