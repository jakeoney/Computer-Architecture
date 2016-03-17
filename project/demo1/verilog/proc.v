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
  wire control_err;
  wire halt;
  wire five_bit_imm;
  wire ZeroExtend;

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
  wire alu_err;
  wire ltz;
  wire [15:0] jump_out;

  //Decode Outputs
  wire [15:0] jumpAddr;
  wire [15:0] read1data;
  wire [15:0] read2data;
  wire [15:0] immediate;
  wire decode_err;

  //Fetch Outputs
  wire [15:0] next_pc;
  wire [15:0] instruction;
  wire fetch_err;

  //ALU Control Outputs
  wire [2:0] op_to_alu;
  wire invA, invB;
  wire sign;
  wire cin;
  wire passA;
  wire passB;

  // instr_fetch unit
  instr_fetch FETCH(//Input
                    .pc(wb_pc), .clk(clk), .rst(rst), 
                    //Outputs
                    .next_pc(next_pc), .instruction(instruction), .err(fetch_err));

  // instr_decode unit
  instr_decode DECODE(//Inputs
                      .instruction(instruction), .RegWrite(RegWrite), .RegDst(RegDst), .writeData(wb_out),
                      .clk(clk), .rst(rst), .pc(next_pc[15:0]), .five_bit_imm(five_bit_imm), .ZeroExtend(ZeroExtend),
                      .MemWrite(MemWrite),
                      //Outputs
                      .jumpAddr(jumpAddr), .read1data(read1data), .read2data(read2data), .immediate(immediate),
                      .err(decode_err));  
  
  // execute unit
  execute EXECUTE ( //Inputs
                    .alu_op(op_to_alu), .ALUSrc(ALU_Src), .read1data(read1data), .read2data(read2data), 
                    .immediate(immediate), .pc(next_pc), .invA(invA), .invB(invB), .cin(cin), .sign(sign),  
                    .passThroughA(passA), .passThroughB(passB), .instr_op(ALU_op), .MemWrite(MemWrite),
                    .jump_in(jumpAddr),
                    //Outputs
                    .ALU_result(ALU_result), .branch_result(branch_result), .zero(zero), .err(alu_err),
                    .ltz(ltz), .jump_out(jump_out));  
  
  // mem unit
  data_mem MEM    ( //Inputs
                    .zero(zero), .Branch(Branch), .branchAddr(branch_result), .pc(next_pc), .MemWrite(MemWrite), 
                    .MemRead(MemRead), .ALU_result(ALU_result), .writedata(read2data), .clk(clk), .rst(rst), 
                    .halt(halt), .ltz(ltz), .branch_op(ALU_op[1:0]),
                    //Outputs
                    .branch_or_pc(branch_or_pc), .readData(data_mem_out));  
  
  // write_back unit
  write_back WB   ( //Inputs
                    .jumpAddr(jump_out), .branch_or_pc(branch_or_pc), .Jump(Jump), .mem_data(data_mem_out), .ALU_result(ALU_result), .MemToReg(MemToReg), 
                    //Outputs
                    .pc(wb_pc), .out_data(wb_out)); 
  
  // control unit
  control CONTROL ( //Inputs
                    .instruction_op(instruction[15:11]), 
                    //Outputs 
                    .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemToReg(MemToReg), .halt(halt),
                    .ALU_op(ALU_op), .MemWrite(MemWrite), .ALUSrc(ALU_Src), .RegWrite(RegWrite), .err(control_err),
                    .five_bit_imm(five_bit_imm), .ZeroExtend(ZeroExtend));

  alu_control ALU_CTL(//Inputs
                      .ALU_op(ALU_op), .ALU_funct(instruction[1:0]), 
                      //Outputs
                      .invA(invA), .invB(invB), .op_to_alu(op_to_alu), .cin(cin), .sign(sign), .passA(passA), .passB(passB));
//ADD some output op to actual alu unit.
endmodule 
