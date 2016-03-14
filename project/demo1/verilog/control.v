module control(instruction_op, instruction_funct, 
               RegDst, Jump, Branch, MemRead, MemToReg, ALU_op, ALU_funct, MemWrite, ALUSrc, RegWrite);

	input [4:0] instruction_op;    //OP Code from instruction fetch
	input [1:0] instruction_funct; //Function from instruction fetch

	output RegDst;          // Instruction Decode -> Write register MUX control
	output Jump;            // To jump or not to jump MUX control
	output Branch;          // To branch or not to branch MUX control
	output MemRead;         // To read from data memory or not MUX control
	output MemToReg;        // Data memory or ALU result MUX control
	output [4:0] ALU_op;    // ALU OP code
	output [1:0] ALU_funct; // ALU function  //Not sure if we want to output this
	output MemWrite;        // To write to memory or not MUX control
	output ALU_Src;         // Register file data2 or immediate MUX control
	output RegWrite;        // To write to register file or not

endmodule
