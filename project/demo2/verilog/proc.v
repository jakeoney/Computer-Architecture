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
  wire alu_ofl;

  //write_back Outputs
  wire [15:0] wb_out; 

  //MEM_WB Outputs
  wire [15:0] data_mem_from_mem_wb, ALU_result_from_mem_wb;
  wire [2:0] write_reg_from_mem_wb;
  wire MemToReg_from_mem_wb, RegWrite_from_mem_wb;
  wire [2:0] Rs_mem_wb, Rt_mem_wb, Rd_mem_wb;
  wire Rs_valid_mem_wb, Rt_valid_mem_wb, Rd_valid_mem_wb;

  //data_mem Outputs
  wire [15:0] branch_or_jump;
  wire [15:0] data_mem_out;

  //EX_MEM Outputs
  wire [15:0] ALU_result_from_ex_mem, branch_result_from_ex_mem, jumpaddr_from_ex_mem, read2_from_ex_mem, next_pc_from_ex_mem;
  wire [4:0] ALU_op_from_ex_mem;
  wire [2:0] write_reg_from_ex_mem;
  wire zero_from_ex_mem, ltz_from_ex_mem, Branch_from_ex_mem, MemRead_from_ex_mem, MemWrite_from_ex_mem, halt_from_ex_mem, MemToReg_from_ex_mem, RegWrite_from_ex_mem, Jump_from_ex_mem;
  wire [2:0] Rs_ex_mem, Rt_ex_mem, Rd_ex_mem;
  wire Rs_valid_ex_mem, Rt_valid_ex_mem, Rd_valid_ex_mem;

  //ALU Outputs
  wire [15:0] ALU_result;
  wire zero;
  wire [15:0] branch_result;
  wire alu_err;
  wire ltz;
  wire [15:0] jump_out;

  //ID_EX Outputs
  wire [15:0] read1_from_id_ex, read2_from_id_ex, imm_from_id_ex, jumpAddr_from_id_ex, next_pc_from_id_ex;
  wire [4:0] ALU_op_from_id_ex;
  wire [2:0] write_reg_from_id_ex;
  wire [1:0] instruction_from_id_ex;
  wire ALU_Src_from_id_ex, Branch_from_id_ex, MemRead_from_id_ex, MemWrite_from_id_ex, MemToReg_from_id_ex, RegWrite_from_id_ex, Jump_from_id_ex, halt_from_id_ex;
  wire [2:0] Rs_id_ex, Rt_id_ex, Rd_id_ex;
  wire Rs_valid_id_ex, Rt_valid_id_ex, Rd_valid_id_ex;

  //Decode Outputs
  wire [15:0] jumpAddr;
  wire [15:0] read1data;
  wire [15:0] read2data;
  wire [15:0] immediate;
  wire decode_err;
  wire [2:0] write_reg;

  //IF_ID Outputs
  wire [15:0] next_pc_from_if_id;
  wire[15:0] instruction_from_if_id;
  wire instr_valid_out;

  //Fetch Outputs
  wire [15:0] next_pc;
  wire [15:0] instruction;
  wire fetch_err;
  wire instr_valid;

  //ALU Control Outputs
  wire [2:0] op_to_alu;
  wire invA, invB;
  wire sign;
  wire cin;
  wire passA;
  wire passB;

  //Reg control Outputs
  wire [2:0] Rs, Rt, Rd;
  wire Rs_valid, Rt_valid, Rd_valid;

  //Data forwarding unit Outputs
  wire [1:0] forwardA,forwardB;

  //Hazard Detection Outputs
  wire PCWrite, IF_ID_Write, zero_control_signals;

  // instr_fetch unit
  instr_fetch FETCH(//Input
                    .pc(next_pc), .branch_or_jump(branch_or_jump), .toJump(Jump_from_ex_mem), .toBranch(Branch_from_ex_mem), .clk(clk), .rst(rst),
                    .PCWrite(PCWrite),
                    //Outputs
                    .next_pc(next_pc), .instruction(instruction), .err(fetch_err), .instr_valid(instr_valid));

  // IF/ID flip flop
  if_id_ff IF_ID(.clk(clk), .rst(rst), .pc_in(next_pc), .instr_in(instruction), .instr_valid(instr_valid), .IF_ID_Write(IF_ID_Write),
                 .pc_out(next_pc_from_if_id), .instr_out(instruction_from_if_id), .instr_valid_out(instr_valid_out));

  // instr_decode unit
  instr_decode DECODE(//Inputs
                      .instruction(instruction_from_if_id), .RegWrite(RegWrite_from_mem_wb), .RegDst(RegDst), .writeData(wb_out),
                      .clk(clk), .rst(rst), .pc(next_pc_from_if_id), .five_bit_imm(five_bit_imm), .ZeroExtend(ZeroExtend),
                      .MemWrite(MemWrite), .write_reg_in(write_reg_from_mem_wb),
                      //Outputs
                      .jumpAddr(jumpAddr), .read1data(read1data), .read2data(read2data), .immediate(immediate),
                      .err(decode_err), .write_reg(write_reg));  
 
 // ID/EX flip flop
 id_ex_ff ID_EX (//Inputs
                 .clk(clk), .rst(rst), .pc_in(next_pc_from_if_id), .read1_in(read1data), .read2_in(read2data), 
                 .imm_in(immediate), .jumpaddr_in(jumpAddr), .instr_in(instruction_from_if_id[1:0]), 
                 .write_reg_in(write_reg),
                 //EX Control Inputs
                 .alu_op_in(ALU_op), .alu_src_in(ALU_Src),
                 //MEM Control Inputs
                 .branch_in(Branch), .mem_read_in(MemRead), .mem_write_in(MemWrite), .halt_in(halt), 
                 //WB Control Inputs
                 .mem_to_reg_in(MemToReg), .reg_write_in(RegWrite), .jump_in(Jump),
                 //Register Inputs
                 .Rs_in(Rs), .Rs_valid_in(Rs_valid), .Rt_in(Rt), .Rt_valid_in(Rt_valid), .Rd_in(Rd), .Rd_valid_in(Rd_valid),
                 .zero_control_signals(zero_control_signals),
                 //Outputs
                 .pc_out(next_pc_from_id_ex), .read1_out(read1_from_id_ex), .read2_out(read2_from_id_ex), 
                 .imm_out(imm_from_id_ex), .jumpaddr_out(jumpAddr_from_id_ex), .instr_out(instruction_from_id_ex[1:0]), 
                 .write_reg_out(write_reg_from_id_ex),
                 //Control Outputs
                 .alu_op_out(ALU_op_from_id_ex), .alu_src_out(ALU_Src_from_id_ex), 
                 .branch_out(Branch_from_id_ex), .mem_read_out(MemRead_from_id_ex), .mem_write_out(MemWrite_from_id_ex),
                 .halt_out(halt_from_id_ex),
                 .mem_to_reg_out(MemToReg_from_id_ex), .reg_write_out(RegWrite_from_id_ex), .jump_out(Jump_from_id_ex),
                 //Register Outputs
                 .Rs_out(Rs_id_ex), .Rs_valid_out(Rs_valid_id_ex), .Rt_out(Rt_id_ex), .Rt_valid_out(Rt_valid_id_ex), 
                 .Rd_out(Rd_id_ex), .Rd_valid_out(Rd_valid_id_ex)
                 ); 

  //wire [15:0] execute_in1, execute_in2, execute_imm; 
  //mux4_1 FWDA [15:0] (.InD(read2_from_id_ex), .InC(ALU_result_from_ex_mem), .InB(wb_out), .InA(read1_from_id_ex), .S(forwardA), .Out(execute_in1));
  //mux4_1 FWDB [15:0] (.InD(read1_from_id_ex), .InC(ALU_result_from_ex_mem), .InB(wb_out), .InA(read2_from_id_ex), .S(forwardB), .Out(execute_in2));
  //mux4_1 FWDI [15:0] (.InD(read1_from_id_ex), .InC(ALU_result_from_ex_mem), .InB(wb_out), .InA(imm_from_id_ex), .S(forwardB), .Out(execute_imm));
  
  // execute unit
  execute EXECUTE ( //Inputs
                    .alu_op(op_to_alu), .ALUSrc(ALU_Src_from_id_ex), .read1data(read1_from_id_ex), .read2data(read2_from_id_ex), 
                    .immediate(imm_from_id_ex), .pc(next_pc_from_id_ex), .invA(invA), .invB(invB), .cin(cin), .sign(sign),  
                    .passThroughA(passA), .passThroughB(passB), .instr_op(ALU_op_from_id_ex), .MemWrite(MemWrite_from_id_ex),
                    .jump_in(jumpAddr_from_id_ex),
                    //Inputs for Data Forward Unit
                    //.Rs_id_ex(Rs_id_ex), .Rs_valid_id_ex(Rs_valid_id_ex), .Rt_id_ex(Rt_id_ex), .Rt_valid_id_ex(Rt_valid_id_ex), 
                   // .Rs_ex_mem(Rs_ex_mem), .Rs_valid_ex_mem(Rs_valid_ex_mem), //.Rt_ex_mem(Rt_ex_mem), .Rt_valid_ex_mem(Rt_ex_mem), 
                    //.Rd_ex_mem(Rd_ex_mem), .Rd_valid_ex_mem(Rd_valid_ex_mem), .Rd_mem_wb(Rd_mem_wb), .Rd_valid_mem_wb(Rd_valid_mem_wb),
                    //.WriteReg_ex_mem(RegWrite_from_ex_mem), .WriteReg_mem_wb(RegWrite_from_mem_wb), 
                    .ALU_result_from_ex_mem(ALU_result_from_ex_mem), .data_mem_from_mem_wb(wb_out),
                    .forwardA(forwardA), .forwardB(forwardB),
                    //Outputs
                    .ALU_result(ALU_result), .branch_result(branch_result), .zero(zero), .err(alu_err),
                    .ltz(ltz), .jump_out(jump_out), .read2out(read2out_ex));  

 wire [15:0] read2out_ex; 

  // EX/MEM flip flop
  ex_mem_ff EX_MEM (//Inputs
                    .clk(clk), .rst(rst), .alu_result_in(ALU_result), .branch_result_in(branch_result), 
                    .zero_in(zero), .ltz_in(ltz), .jumpaddr_in(jump_out), .next_pc_in(next_pc_from_id_ex),
                    //.read2data_in(read2out_ex), .alu_op_in(ALU_op_from_id_ex), .write_reg_in(write_reg_from_id_ex),
                    .read2data_in(read2_from_id_ex), .alu_op_in(ALU_op_from_id_ex), .write_reg_in(write_reg_from_id_ex),
                    //Control Inputs
                    .branch_in(Branch_from_id_ex), .mem_read_in(MemRead_from_id_ex), .mem_write_in(MemWrite_from_id_ex),
                    .halt_in(halt_from_id_ex),
                    .mem_to_reg_in(MemToReg_from_id_ex), .reg_write_in(RegWrite_from_id_ex), .jump_in(Jump_from_id_ex),
                    //Register Inputs
                    .Rs_in(Rs_id_ex), .Rs_valid_in(Rs_valid_id_ex), .Rt_in(Rt_id_ex), .Rt_valid_in(Rt_valid_id_ex), 
                    .Rd_in(Rd_id_ex), .Rd_valid_in(Rd_valid_id_ex),
                    
                    //Outputs
                    .alu_result_out(ALU_result_from_ex_mem), .branch_result_out(branch_result_from_ex_mem), .zero_out(zero_from_ex_mem),
                    .ltz_out(ltz_from_ex_mem), .jumpaddr_out(jumpaddr_from_ex_mem), .next_pc_out(next_pc_from_ex_mem),
                    .read2data_out(read2_from_ex_mem), .alu_op_out(ALU_op_from_ex_mem), .write_reg_out(write_reg_from_ex_mem),
                    //Control Outputs
                    .branch_out(Branch_from_ex_mem), .mem_read_out(MemRead_from_ex_mem), .mem_write_out(MemWrite_from_ex_mem),
                    .halt_out(halt_from_ex_mem),
                    .mem_to_reg_out(MemToReg_from_ex_mem), .reg_write_out(RegWrite_from_ex_mem), .jump_out(Jump_from_ex_mem),
                    //Register Outputs
                    .Rs_out(Rs_ex_mem), .Rs_valid_out(Rs_valid_ex_mem), .Rt_out(Rt_ex_mem), .Rt_valid_out(Rt_valid_ex_mem), 
                    .Rd_out(Rd_ex_mem), .Rd_valid_out(Rd_valid_ex_mem)
                   );

  // mem unit
  data_mem MEM    ( //Inputs
                    .zero(zero_from_ex_mem), .Branch(Branch_from_ex_mem), .branchAddr(branch_result_from_ex_mem),  
                    .MemWrite(MemWrite_from_ex_mem), .MemRead(MemRead_from_ex_mem), .ALU_result(ALU_result_from_ex_mem), 
                    .writedata(read2_from_ex_mem), .clk(clk), .rst(rst), .halt(halt_from_ex_mem), .ltz(ltz_from_ex_mem), 
                    .branch_op(ALU_op_from_ex_mem[1:0]), .jumpaddr(jumpaddr_from_ex_mem), 
                    //Outputs
                    .branch_or_jump(branch_or_jump), .readData(data_mem_out));  
  
  // MEM_WB flip flop
  mem_wb_ff MEM_WB(//Inputs
                   .data_mem_in(data_mem_out), .alu_result_in(ALU_result_from_ex_mem), .write_reg_in(write_reg_from_ex_mem),
                   //Control Inputs
                   .mem_to_reg_in(MemToReg_from_ex_mem), .reg_write_in(RegWrite_from_ex_mem), 
                   .clk(clk), .rst(rst),
                   //Register Inputs
                   .Rs_in(Rs_ex_mem), .Rs_valid_in(Rs_valid_ex_mem), .Rt_in(Rt_ex_mem), .Rt_valid_in(Rt_valid_ex_mem), 
                   .Rd_in(Rd_ex_mem), .Rd_valid_in(Rd_valid_ex_mem),
                   
                   //Outputs
                   .data_mem_out(data_mem_from_mem_wb), .alu_result_out(ALU_result_from_mem_wb), .write_reg_out(write_reg_from_mem_wb),
                   //Control Outputs
                   .mem_to_reg_out(MemToReg_from_mem_wb), .reg_write_out(RegWrite_from_mem_wb),
                   //Register Outputs
                   .Rs_out(Rs_mem_wb), .Rs_valid_out(Rs_valid_mem_wb), .Rt_out(Rt_mem_wb), .Rt_valid_out(Rt_valid_mem_wb), 
                   .Rd_out(Rd_mem_wb), .Rd_valid_out(Rd_valid_mem_wb)
                  );

  // write_back unit
  write_back WB   ( //Inputs
                    .mem_data(data_mem_from_mem_wb), .ALU_result(ALU_result_from_mem_wb), .MemToReg(MemToReg_from_mem_wb), 
                    //Outputs
                    .out_data(wb_out)); 
  
  // control unit
  control CONTROL ( //Inputs
                    .instruction_op(instruction_from_if_id[15:11]), .instr_valid(instr_valid_out),
                    //Outputs 
                    .RegDst(RegDst), .Jump(Jump), .Branch(Branch), .MemRead(MemRead), .MemToReg(MemToReg), .halt(halt),
                    .ALU_op(ALU_op), .MemWrite(MemWrite), .ALUSrc(ALU_Src), .RegWrite(RegWrite), .err(control_err),
                    .five_bit_imm(five_bit_imm), .ZeroExtend(ZeroExtend));

  // alu control unit
  alu_control ALU_CTL(//Inputs
                      .ALU_op(ALU_op_from_id_ex), .ALU_funct(instruction_from_id_ex[1:0]),
                      //Outputs
                      .invA(invA), .invB(invB), .op_to_alu(op_to_alu), .cin(cin), .sign(sign), .passA(passA), .passB(passB));

  // register control unit
  register_control REG_CTL(.instruction(instruction_from_if_id), 
                           .Rs(Rs), .Rt(Rt), .Rd(Rd), 
                           .Rs_valid(Rs_valid), .Rt_valid(Rt_valid), .Rd_valid(Rd_valid));

  //DATA FORWARDING UNIT
  data_forward_unit FWD(
                    .Rs_id_ex(Rs_id_ex), .Rs_valid_id_ex(Rs_valid_id_ex), .Rt_id_ex(Rt_id_ex), .Rt_valid_id_ex(Rt_valid_id_ex), 
                    .Rs_ex_mem(Rs_ex_mem), .Rs_valid_ex_mem(Rs_valid_ex_mem), //.Rt_ex_mem(Rt_ex_mem), .Rt_valid_ex_mem(Rt_ex_mem), 
                    .Rd_ex_mem(Rd_ex_mem), .Rd_valid_ex_mem(Rd_valid_ex_mem), .Rd_mem_wb(Rd_mem_wb), .Rd_valid_mem_wb(Rd_valid_mem_wb),
                    .WriteReg_ex_mem(RegWrite_from_ex_mem), .WriteReg_mem_wb(RegWrite_from_mem_wb),
                    .MemRead_ex_mem(MemRead_from_ex_mem),
                    .forwardA(forwardA), .forwardB(forwardB));

  //HAZARD DETECTION UNIT
  hazard_detection_unit HZD(//Inputs
                            .MemRead_id_ex(MemRead_from_id_ex), 
                            .Rt_id_ex(Rt_id_ex), .Rs_if_id(Rs), .Rt_if_id(Rt),
                            .Rt_valid_id_ex(Rt_valid_id_ex), .Rs_valid_if_id(Rs_valid), .Rt_valid_if_id(Rt_valid),
                            //Outputs
                            .PCWrite(PCWrite), .IF_ID_Write(IF_ID_Write), .zero_control_signals(zero_control_signals)
                           );

endmodule 
