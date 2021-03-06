`timescale 1ps / 1ps 

module ClockGenerator(clock);

output reg clock;

parameter PERIOD 		= 	10;
parameter DUTY_CYCLE	=	5;

always begin
	#(PERIOD - DUTY_CYCLE)	clock = 1;
	#(DUTY_CYCLE)				clock = 0; 
end

endmodule
