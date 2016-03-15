module data_mem(zero, Branch, branchAddr, pc, MemWrite, MemRead, ALU_result, writedata
					 branch_or_pc, readData);

	input zero;             //Used for branch logic
	input Branch;           //From control: if branch
	input [15:0] branchAddr;//Branch address
	input [15:0] pc;        //PC
	input MemWrite;         //Write to memory or not. from control
	input [15:0] ALU_result;//ALU unit result
	input [15:0] writedata; //From instruction decode unit
	input MemRead; 					//Read from Mem or not. From control
	
	output [15:0] branch_or_pc;//Result from MUX
	output [15:0] readData;    //From Memory unit

endmodule
