`include "sevenSegment.vh"

module SevenSegmentController(
	input wire clock,
	input wire [31 : 0] addressBus,
	input wire [7 : 0] dataBusIn,
	input wire  readWrite,
	input wire 	mio,
	input wire enable, 
	output wire [6 : 0] hex0,
	output wire [6 : 0] hex1,
	output wire [6 : 0] hex2,
	output wire [6 : 0] hex3
);

reg [15 : 0] sevenSegmentState;

assign hex0 =	sevenSegmentState[3 : 0] == 0  ? `ZERO :
					sevenSegmentState[3 : 0] == 1  ? `ONE	:
					sevenSegmentState[3 : 0] == 2  ? `TWO	:
					sevenSegmentState[3 : 0] == 3  ? `THREE	:
					sevenSegmentState[3 : 0] == 4  ? `FOUR :
					sevenSegmentState[3 : 0] == 5  ? `FIVE	:
					sevenSegmentState[3 : 0] == 6  ? `SIX :
					sevenSegmentState[3 : 0] == 7  ? `SEVEN :
					sevenSegmentState[3 : 0] == 8  ? `EIGHT :
					sevenSegmentState[3 : 0] == 9  ? `NINE :
					sevenSegmentState[3 : 0] == 10  ? `TEN :
					sevenSegmentState[3 : 0] == 11  ? `ELEVEN :
					sevenSegmentState[3 : 0] == 12  ? `TWELVE :
					sevenSegmentState[3 : 0] == 13  ? `THIRTEEN :
					sevenSegmentState[3 : 0] == 14  ? `FOURTEEN : `FIFTEEN;
					
assign hex1 =	sevenSegmentState[7 : 4] == 0  ? `ZERO :
					sevenSegmentState[7 : 4] == 1  ? `ONE	:
					sevenSegmentState[7 : 4] == 2  ? `TWO	:
					sevenSegmentState[7 : 4] == 3  ? `THREE	:
					sevenSegmentState[7 : 4] == 4  ? `FOUR :
					sevenSegmentState[7 : 4] == 5  ? `FIVE	:
					sevenSegmentState[7 : 4] == 6  ? `SIX :
					sevenSegmentState[7 : 4] == 7  ? `SEVEN :
					sevenSegmentState[7 : 4] == 8  ? `EIGHT :
					sevenSegmentState[7 : 4] == 9  ? `NINE :
					sevenSegmentState[7 : 4] == 10  ? `TEN :
					sevenSegmentState[7 : 4] == 11  ? `ELEVEN :
					sevenSegmentState[7 : 4] == 12  ? `TWELVE :
					sevenSegmentState[7 : 4] == 13  ? `THIRTEEN :
					sevenSegmentState[7 : 4] == 14  ? `FOURTEEN : `FIFTEEN;
					
assign hex2 =	sevenSegmentState[11 : 8] == 0  ? `ZERO :
					sevenSegmentState[11 : 8] == 1  ? `ONE	:
					sevenSegmentState[11 : 8] == 2  ? `TWO	:
					sevenSegmentState[11 : 8] == 3  ? `THREE	:
					sevenSegmentState[11 : 8] == 4  ? `FOUR :
					sevenSegmentState[11 : 8] == 5  ? `FIVE	:
					sevenSegmentState[11 : 8] == 6  ? `SIX :
					sevenSegmentState[11 : 8] == 7  ? `SEVEN :
					sevenSegmentState[11 : 8] == 8  ? `EIGHT :
					sevenSegmentState[11 : 8] == 9  ? `NINE :
					sevenSegmentState[11 : 8] == 10  ? `TEN :
					sevenSegmentState[11 : 8] == 11  ? `ELEVEN :
					sevenSegmentState[11 : 8] == 12  ? `TWELVE :
					sevenSegmentState[11 : 8] == 13  ? `THIRTEEN :
					sevenSegmentState[11 : 8] == 14  ? `FOURTEEN : `FIFTEEN;
					
assign hex3 =	sevenSegmentState[15 : 12] == 0  ? `ZERO :
					sevenSegmentState[15 : 12] == 1  ? `ONE	:
					sevenSegmentState[15 : 12] == 2  ? `TWO	:
					sevenSegmentState[15 : 12] == 3  ? `THREE	:
					sevenSegmentState[15 : 12] == 4  ? `FOUR :
					sevenSegmentState[15 : 12] == 5  ? `FIVE	:
					sevenSegmentState[15 : 12] == 6  ? `SIX :
					sevenSegmentState[15 : 12] == 7  ? `SEVEN :
					sevenSegmentState[15 : 12] == 8  ? `EIGHT :
					sevenSegmentState[15 : 12] == 9  ? `NINE :
					sevenSegmentState[15 : 12] == 10  ? `TEN :
					sevenSegmentState[15 : 12] == 11  ? `ELEVEN :
					sevenSegmentState[15 : 12] == 12  ? `TWELVE :
					sevenSegmentState[15 : 12] == 13  ? `THIRTEEN :
					sevenSegmentState[15 : 12] == 14  ? `FOURTEEN : `FIFTEEN;
					
always @(posedge clock) begin
	if (readWrite == 0 && mio == 0 && enable == 1) begin
		if (addressBus == `LOWER_ADDRESS) begin
			sevenSegmentState[7 : 0] <= dataBusIn;
		end else if (addressBus == `HIGHER_ADDRESS) begin
			sevenSegmentState[15 : 8] <= dataBusIn;
		end
	end
end

endmodule