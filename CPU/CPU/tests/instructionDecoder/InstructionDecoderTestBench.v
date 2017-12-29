module InstructionDecoderTestBench();
	
reg		[31	: 0]	IR;
wire	[3	: 0]	ALUOperationCode;
wire	[4 	: 0]	destination, source;
wire 	[31 : 0]	immediate;
wire 						isSecondImmediate;

InstructionDecoder  InstructionDecoder_instance (
	.IR(IR),
	.ALUOperationCode(ALUOperationCode),
	.source(source),
	.destination(destination),
	.immediate(immediate),
	.isSecondImmediate(isSecondImmediate)
);

integer file, value;
reg			eof;

initial begin
	file = $fopen("/media/jovan/Local Disk2/workspaces/SigasiWorkspace/CPU/tests/instructionDecoder/LDCInstructionTest", "r");
	
	eof = $feof(file);
	
	while (eof == 0) begin
		$fscanf(file, "%x", value);
		#20 IR = value;
	end	
	
	value = $fcloser("/media/jovan/Local Disk2/workspaces/SigasiWorkspace/CPU/tests/instructionDecoder/LDCInstructionTest");
	$finish;
end
	
endmodule