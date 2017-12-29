module Printer(address, mio, data, readRequest, clock);

parameter ADDRESS_WIDTH	=	16;

//ports
input wire[ADDRESS_WIDTH - 1 : 0]	address;
input															mio;
inout wire[7 : 0]									data;
input wire												readRequest;
input wire												clock;

always @(posedge clock) begin
	if (address == 16'h2000 && mio == 0 && readRequest == 0) begin
		@(posedge clock);
		$display("%c", data);
	end
end
	
endmodule