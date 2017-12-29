`include "timer.vh"

module Timer(
	input		wire	clock,
	input		wire	reset,
	output	reg		pulse
);

parameter PULSE_PERIOD = 1;

realtime now 		= 0.0;
realtime passed = 0.0;

always @(posedge clock or posedge reset) begin
	
	now	<= $realtime;
	
	if (reset == 1 || pulse == 1) begin
		passed 	<= 0.0;
		pulse   <= 0;
	end else if (passed >= PULSE_PERIOD) begin
		pulse <= 1;
	end else begin
		passed <= passed + ($realtime - now);
	end
	
end
	
endmodule