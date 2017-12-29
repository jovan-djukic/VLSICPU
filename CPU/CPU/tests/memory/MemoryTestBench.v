module MemoryTestBench();
	
wire clock;

ClockGenerator ClockGenerator_instance (
	.clock(clock)
);

reg	[15	: 0]	address;
wire[7 	: 0]	dataBus;
reg						readRequest;
reg	[15 : 0]	data;
reg 					outputValid;

Memory #(16) Memory_instance (
	.address(address),
	.data(dataBus),
	.readRequest(readRequest),
	.clock(clock)
);

assign dataBus = outputValid == 1 ? data : {8{1'bz}};

initial begin
	$monitor("ADDRESS=%d DATA_BUS=%d READ=%d", address, dataBus, readRequest);
 
	address 		<= 16'h0;
	data 				<= 8'hAB; 
	outputValid	<= 1;
	readRequest	<= 0;
	
	repeat(4) begin
		@(posedge clock);
	end
	
	address 		<= 16'h1;
	data 				<= 8'hCD; 
	outputValid	<= 1;
	readRequest	<= 0;
	
	repeat(4) begin
		@(posedge clock);
	end
	
	address			<= 16'h0;
	outputValid <= 0;
	readRequest	<= 1;
	
	repeat(4) begin
		@(posedge clock);
	end
	
	address			<= 16'h1;
	outputValid <= 0;
	readRequest	<= 1;
	
	repeat(4) begin
		@(posedge clock);
	end
	
	
	address			<= 16'hx;
	readRequest	<= 1;
	
	repeat(4) begin
		@(posedge clock);
	end
	
	$finish;
end
	
endmodule