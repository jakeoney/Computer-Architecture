module proc (/*AUTOARG*/
  // Outputs
  err, 
  // Inputs
  clk, rst
  );

  input clk;
  input rst;

  // As desribed in the homeworks, use the err signal to trap corner
  // cases that you think are illegal in your statemachines
  output err;

  // None of the above lines can be modified
  // OR all the err ouputs for every sub-module and assign it as this
  // err output

  /*TODO*/
	//Probably need to have an output err signal from each unit
	//assign err = err1 || err2 || err3 ... etc

	//CONTROL Outputs
	wire RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, ALU_Src, RegWrite; 
	wire [4:0] ALU_op;
	wire [1:0] ALU_funct;

	//write_back Outputs
	wire [15:0] wb_out; 
	wire [15:0] wb_pc;

	//data_mem Outputs
	wire [15:0] branch_or_pc;
	wire [15:0] data_mem_out;

	//ALU Outputs
	wire [15:0] ALU_result;
	wire zero;
	wire [15:0] branch_result;

	//Decode Outputs
	wire [15:0] jumpAddr;
	wire [15:0] read1data;
	wire [15:0] read2data;
	wire [15:0] immediate;

	//Fetch Outputs
	wire [15:0] next_pc;
	wire [15:0] instruction;

	// instr_fetch unit
	instr_fetch FETCH(//Input
										.pc(wb_pc), 
	                  //Outputs
										.next_pc(next_pc), .instruction(instruction));

	// instr_decode unit
	instr_decode DECODE(//Inputs
											.instruction(instruction[10:0]), .RegWrite(RegWrite), .RegDst(RegDst), .writeData(wb_out)
	                    //Outputs
											.jumpAddr(jumpAddr), .read1data(read1data), .read2data(read2data), .immediate(immediate));	
	
	// execute unit
	execute EXECUTE ( //Inputs
										.funct(ALU_funct), .alu_op(ALU_op), .ALUSrc(ALU_Src), .read1data(read1data), .read2data(read2data), .immediate(immediate), .pc(next_pc), 
	                  //Outputs
										.ALU_result(ALU_result), .branch_result(branch_result), .zero(zero));	
	
	// mem unit
	data_mem MEM    (	//Inputs
										.zero(zero), .Branch(Branch), .branchAddr(branch_result), .pc(next_pc), .MemWrite(MemWrite), 
										.MemRead(MemRead), .ALU_result(ALU_result), .writedata(read2data), 
	                  //Outputs
										.branch_or_pc(branch_or_pc), .readData(data_mem_out));	
	
	// write_back unit
	write_back WB   (	//Inputs
										.jumpAddr(jumpAddr), .branch_or_pc(branch_or_pc), .Jump(Jump), .mem_data(data_mem_out), .ALU_result(ALU_result), .MemToReg(MemToReg), 
	                  //Outputs
										.pc(wb_pc), .out_data(wb_out));	
	
	// control unit
	control CONTROL ( //Inputs
										.instruction_op(instruction[15:11]), .instruction_funct(instruction[1:0]), 
	                  //Outputs 
										.RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemToReg(MemToReg), 
									 	.ALU_op(ALU_op), .ALU_funct(ALU_funct), .MemWrite(MemWrite), .ALU_Src(ALU_Src), .RegWrite(RegWrite));

endmodule 
