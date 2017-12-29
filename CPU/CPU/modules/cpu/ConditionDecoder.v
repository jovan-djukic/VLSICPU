`include "instructions.vh"

module ConditionDecoder(
	input 	wire[2 : 0]	condtionSelect,
	input		wire				zero,
	input		wire				carry,
	input		wire				negative,
	input 	wire				overflow,
	output	reg					conditionSatisfied
);
	
always @(*) begin
	
	conditionSatisfied 			= 0;
	
	case (condtionSelect)
		`EQUAL: begin
			conditionSatisfied	= zero == 1;
		end
		
		`NOT_EQUAL: begin
			conditionSatisfied 	= zero == 0;
		end
		
		`GREATER_THAN: begin
			conditionSatisfied	= (zero == 0) && (negative == overflow);
		end
		
		`GREATER_OR_EQUAL_THAN: begin
			conditionSatisfied	= negative == overflow;
		end
		
		`LESS_THAN: begin
			conditionSatisfied	=	negative != overflow;
		end
		
		`LESS_OR_EQUAL_THAN: begin
			conditionSatisfied	= (zero == 1) || (negative != overflow);
		end
		
		`NOT_USED: begin 
			conditionSatisfied	= 0;
		end
		
		`ALWAYS_EXECUTED: begin
			conditionSatisfied	= 1;
		end
	endcase
end
	
endmodule