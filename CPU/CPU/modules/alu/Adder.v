module Adder(firstOperand, secondOperand, result);

parameter WIDTH = 32;

input		wire[WIDTH - 1 : 0]	firstOperand, secondOperand;
output	wire[WIDTH - 1 : 0] result;

assign result = firstOperand + secondOperand;	

endmodule