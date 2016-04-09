module mem_wb_ff(clk, rst, branch_or_pc_in, data_mem_in, jumpaddr_in, 
                 alu_result_in, write_reg_in, jump_in, mem_to_reg_in, reg_write_in,
                 branch_or_pc_out, data_mem_out, jumpaddr_out, alu_result_out, 
                 write_reg_out, jump_out, mem_to_reg_out, reg_write_out);

  input clk, rst;
  input [15:0] branch_or_pc_in, data_mem_in, jumpaddr_in, alu_result_in;
  input [2:0] write_reg_in;
  input jump_in, mem_to_reg_in, reg_write_in;

  output [15:0] branch_or_pc_out, data_mem_out, jumpaddr_out, alu_result_out;
  output [2:0] write_reg_out;
  output jump_out, mem_to_reg_out, reg_write_out;

  dff BRPC [15:0](.q(branch_or_pc_out), .d(branch_or_pc_in), .clk(clk), .rst(rst));
  dff DMEM [15:0](.q(data_mem_out),     .d(data_mem_in),     .clk(clk), .rst(rst));
  dff JA   [15:0](.q(jumpaddr_out),     .d(jumpaddr_in),     .clk(clk), .rst(rst));
  dff ALUR [15:0](.q(alu_result_out),   .d(alu_result_in),   .clk(clk), .rst(rst));

  dff WREG [2:0] (.q(write_reg_in), .d(write_reg_in), .clk(clk), .rst(rst));

  dff JUMP (.q(jump_out),       .d(jump_in),       .clk(clk), .rst(rst));
  dff MTR  (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
  dff REGW (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst));
endmodule
