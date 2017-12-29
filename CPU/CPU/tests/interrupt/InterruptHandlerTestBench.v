module InterruptHandlerTestBench();
	
localparam WIDTH 					= 16;
localparam ADDRESS_WIDTH	= 32;
	
reg		[WIDTH				 - 1	: 0]	externalInterrupt, setInterrupt, resetInterrupt;
reg															PSWI;
wire	[ADDRESS_WIDTH - 1 	:	0] 	address;

InterruptHandler #(WIDTH,ADDRESS_WIDTH) InterruptHandler_instance (
	.externalInterrupt(externalInterrupt),
	.setInterrupt(setInterrupt),
	.resetInterrupt(resetInterrupt),
	.PSWI(PSWI),
	.address(address)
);

always begin
	PSWI 									= 1;
	externalInterrupt[5] 	= 1;
	
	#10 externalInterrupt[1] = 1;	
	#10	PSWI								 = 0;
	
	#10 externalInterrupt[5] = 0;
			externalInterrupt[1] = 0;		
	
	#10 resetInterrupt[5] = 1;
			resetInterrupt[1] = 1;
			
	#10 setInterrupt[6] = 1;
	#10 setInterrupt[1] = 1;	
	
	#10 $finish;

end	

endmodule