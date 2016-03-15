module execute(funct, alu_op, ALUSrc, read1data, read2data, immediate, pc
							ALU_result, branch_result, zero);

	input [1:0] funct;    //function/extension to the OP code
	input [4:0] alu_op;   //OP code
	input ALUSrc;         //ALUSrc MUX control signal (read2data or immediate)
	input [15:0] read1data;
	input [15:0] read2data;
	input [15:0] immediate;//Not sure if I want this named immediate...
	input [15:0] pc;       //Use in adder for branch result

	output [15:0] ALU_result; //From main ALU unit
	output [15:0] branch_result; //From branch calculation alu unit
	output zero;

endmodule
