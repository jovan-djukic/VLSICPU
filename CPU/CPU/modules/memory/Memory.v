module Memory(address, mio, dataBusIn, dataBusOut, readRequest, enable, clock);

parameter ADDRESS_WIDTH	=	32;
parameter SIZE	= 256;
parameter INITIALIZATION_FILE = "/home/jovan/quartusWorkspace/CPU/tests/binaryFiles/buttonInterrupt";

//ports
input wire[ADDRESS_WIDTH - 1 : 0]	address;
input											mio;
input wire[7 : 0]							dataBusIn;
input wire									readRequest;
input wire									clock, enable;

output reg [7 : 0] dataBusOut;

//local variables
reg[7 : 0] memory[0 : SIZE - 1];

initial begin
	if (INITIALIZATION_FILE != "") begin
		$readmemh(INITIALIZATION_FILE, memory);
	end
end

always @(posedge clock) begin
	if (address < SIZE && mio == 1 && enable == 1) begin
		if (readRequest == 0) begin
			memory[address] <= dataBusIn;
		end else begin
			dataBusOut <= memory[address];
		end
	end
end
	
endmodule