module write_back(jumpAddr, branch_or_pc, Jump, mem_data, ALU_result, MemToReg, 
                  pc, out_data);

  input [15:0] jumpAddr;
  input [15:0] branch_or_pc;
  input Jump;                //To jump or not. From control
  input [15:0] mem_data;
  input [15:0] ALU_result;
  input MemToReg;            //Memory result or alu result. From control

  output [15:0] pc;          //New PC. either jump, branch, or pc + 2
  output [15:0] out_data;    //Either mem_data or alu_result

  //JUMP Logic


  //JUMP OR BRANCH_OR_PC Logic
  mux2_1_16bit PC_MUX (.InB(jumpAddr), .InA(branch_or_pc), .S(Jump), .Out(pc));

  //ALU_Result or Data from Memory Logic
  mux2_1_16bit DATA_MUX(.InB(mem_data), .InA(ALU_result), .S(MemToReg), .Out(out_data));

endmodule
