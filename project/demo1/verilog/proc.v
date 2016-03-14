module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified
   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
    
	// instr_fetch unit
	instr_fetch FETCH(.pc(), 
	                  .new_pc(), .instruction());

	// instr_decode unit
	instr_decode DECODE(.instruction(), .RegWrite(), .RegDst(), 
	                    .jumpAddr(), .read1data(), .read2data(), .branchAddr());	
	
	// execute unit
	execute EXECUTE (.funct(), .alu_op(), .ALUSrc(), .read1data(), .read2data(), .immediate(), .pc(), 
	                 .ALU1_result(), .ALU2_result(), .zero());	
	
	// mem unit
	data_mem MEM    (.zero(), .Branch(), .branchAddr(), .pc(), .MemWrite(), .ALU_result(), .writedata(), 
	                 .branch_or_pc(), .readData());	
	
	// write_back unit
	write_back WB   (.jumpAddr(), .branch_or_pc(), .Jump(), .mem_data(), .ALU_result(), .MemToReg(), 
	                 .pc(), .out_data());	
	
	// control unit
	control CONTROL (.instruction_op(), .instruction_funct(), 
	                 .RegDst(), .Jump(), .Branch(), .MemRead(), .MemToReg(), .ALU_op(), .ALU_funct(), .MemWrite(), .ALU_Src(), .RegWrite());

endmodule // proc
