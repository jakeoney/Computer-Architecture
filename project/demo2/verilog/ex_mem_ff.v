module ex_mem_ff (clk, rst, alu_result_in, branch_result_in, zero_in, ltz_in,
                  jumpaddr_in, next_pc_in, read2data_in, alu_op_in, write_reg_in,
                  branch_in, mem_read_in, mem_write_in, halt_in, mem_to_reg_in, 
                  reg_write_in, jump_in, 
                  Rs_in, Rd_in, Rt_in, Rs_valid_in, Rt_valid_in, Rd_valid_in,
                  
                  alu_result_out, branch_result_out, zero_out, ltz_out, 
                  jumpaddr_out, next_pc_out, read2data_out, alu_op_out,
                  write_reg_out, branch_out, mem_read_out, mem_write_out, halt_out,
                  mem_to_reg_out, reg_write_out, jump_out,
                  Rs_out, Rd_out, Rt_out, Rs_valid_out, Rt_valid_out, Rd_valid_out);

  input clk, rst;
  input [15:0] alu_result_in, branch_result_in, jumpaddr_in, next_pc_in, read2data_in;
  input zero_in, ltz_in, branch_in, mem_read_in, mem_write_in, halt_in, mem_to_reg_in, reg_write_in, jump_in;
  input [4:0] alu_op_in;
  input [2:0] write_reg_in;
  input [2:0] Rs_in, Rd_in, Rt_in;
  input Rs_valid_in, Rt_valid_in, Rd_valid_in;

  output [15:0] alu_result_out, branch_result_out, jumpaddr_out, next_pc_out, read2data_out;
  output zero_out, ltz_out, branch_out, mem_read_out, mem_write_out, halt_out, mem_to_reg_out, reg_write_out, jump_out;
  output [4:0] alu_op_out;
  output [2:0] write_reg_out;
  output [2:0] Rs_out, Rd_out, Rt_out;
  output Rs_valid_out, Rt_valid_out, Rd_valid_out;

  dff ALU  [15:0] (.q(alu_result_out),    .d(alu_result_in),    .clk(clk), .rst(rst));
  dff BR   [15:0] (.q(branch_result_out), .d(branch_result_in), .clk(clk), .rst(rst));
  dff JUMPA[15:0] (.q(jumpaddr_out),      .d(jumpaddr_in),      .clk(clk), .rst(rst));
  dff PC   [15:0] (.q(next_pc_out),       .d(next_pc_in),       .clk(clk), .rst(rst));
  dff READ2[15:0] (.q(read2data_out),     .d(read2data_in),     .clk(clk), .rst(rst));

  dff ALU_OP [4:0] (.q(alu_op_out), .d(alu_op_in), .clk(clk), .rst(rst));

  dff WRITE_REG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

  dff ZERO (.q(zero_out),       .d(zero_in),       .clk(clk), .rst(rst));
  dff LTZ  (.q(ltz_out),        .d(ltz_in),        .clk(clk), .rst(rst));
  dff BRO  (.q(branch_out),     .d(branch_in),     .clk(clk), .rst(rst));
  dff MEMR (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst));
  dff MEMW (.q(mem_write_out),  .d(mem_write_in),  .clk(clk), .rst(rst));
  dff HALT (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));
  dff MTR  (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
  dff RWO  (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst));
  dff JUMP (.q(jump_out),       .d(jump_in),       .clk(clk), .rst(rst));

  dff RS [2:0] (.q(Rs_out),       .d(Rs_in),       .clk(clk), .rst(rst));
  dff RT [2:0] (.q(Rt_out),       .d(Rt_in),       .clk(clk), .rst(rst));
  dff RD [2:0] (.q(Rd_out),       .d(Rd_in),       .clk(clk), .rst(rst));
  dff RS_V     (.q(Rs_valid_out), .d(Rs_valid_in), .clk(clk), .rst(rst));
  dff RT_V     (.q(Rt_valid_out), .d(Rt_valid_in), .clk(clk), .rst(rst));
  dff RD_V     (.q(Rd_valid_out), .d(Rd_valid_in), .clk(clk), .rst(rst));
endmodule
