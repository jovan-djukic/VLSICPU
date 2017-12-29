`include "ledController.vh"

module LedController(
	input wire [31 : 0] addressBus,
	input wire [7  : 0] dataBusIn,
	input wire			  readRequest,
	input wire			  mio,
	input wire 			  enable,
	input wire 			  clock,
	output reg [7 : 0] ledState
);

always @(posedge clock) begin
	if (addressBus == `LED_CONTROLLER_ADDRESS && readRequest == 0 && mio == 0 && enable == 1) begin
		ledState <= dataBusIn;
	end
end

endmodule