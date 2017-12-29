module MemoryInterfaceTestBench();

localparam ADDRESS_BUS_WIDTH	= 32; 
localparam DATA_BUS_WIDTH 		= 8; 
localparam DATA_WIDTH					= 32;

wire [ADDRESS_BUS_WIDTH - 1 : 0] addressBus;
wire [7 : 0] dataBus;
wire mio;
wire readRequest;
wire clock;

ClockGenerator ClockGenerator_instance (
	.clock(clock)
);

Memory #(ADDRESS_BUS_WIDTH, DATA_WIDTH, DATA_BUS_WIDTH) Memory_instance (
	.address(addressBus),
	.mio(mio),
	.data(dataBus),
	.readRequest(readRequest),
	.clock(clock)
);	

reg [ADDRESS_BUS_WIDTH - 1 : 0] address;
wire [DATA_WIDTH - 1 : 0] data;

wire [DATA_WIDTH - 1 : 0] dataOut;
reg [DATA_WIDTH - 1 : 0] dataIn;

reg readWrite, enable, isMemory, reset;
wire ready;

MemoryInterface #(ADDRESS_BUS_WIDTH,DATA_WIDTH,DATA_BUS_WIDTH,3) MemoryInterface_instance (
	.addressBus(addressBus),
	.dataBus(dataBus),
	.mio(mio),
	.readRequest(readRequest),
	.address(address),
	.dataIn(dataIn),
	.dataOut(dataOut),
	.clockCount(3'b001),
	.readWrite(readWrite),
	.clock(clock),
	.enable(enable),
	.reset(reset),
	.isMemory(isMemory),
	.ready(ready)
);


initial begin
		reset <= 1;
		@(posedge clock);
		reset <= 0;
		//write 1 to address 0
		enable <= 1;
		dataIn <= 1;
		address <= 0;
		isMemory <= 1;
		readWrite <= 0;
		
		@(posedge clock);
		enable <= 0;
		wait(ready == 1);
		
		reset <= 1;
		@(posedge clock);
		reset <= 0;
		//write 2 to address 4
		enable <= 1;
		dataIn <= 2;
		address <= 4;
		isMemory <= 1;
		readWrite <= 0;
		
		@(posedge clock);
		enable <= 0;
		wait(ready == 1);
		
		//read from address 0
		enable <= 1;
		address <= 0;
		isMemory <= 1;
		readWrite <= 1;
		
		@(posedge clock);
		enable <= 0;
		@(posedge clock);
		wait(ready == 1);
		
		@(posedge clock);
		enable <= 0;
		wait(ready == 1);
		
		//read from address 4
		enable <= 1;
		address <= 4;
		isMemory <= 1;
		readWrite <= 1;
		
		@(posedge clock);
		enable <= 0;
		@(posedge clock);
		wait(ready == 1);
		
		
		$finish;
end

endmodule