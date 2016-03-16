module alu_control(ALU_op, ALU_funct, invA, invB, sign, op_to_alu, cin);

	input [4:0] ALU_op;
	input [1:0] ALU_funct;

	output invA;
	output invB;
	output sign;
	output [2:0] op_to_alu;	
	output cin;

endmodule
