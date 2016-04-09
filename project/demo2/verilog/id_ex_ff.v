module id_ex_ff(clk, rst, pc_in, read1_in, read2_in, imm_in, jumpaddr_in,
                alu_op_in, alu_src_in, branch_in, mem_read_in, mem_write_in,
                mem_to_reg_in, reg_write_in, jump_in, halt_in,

                read1_out, read2_out, pc_out, imm_out, jumpaddr_out
                alu_op_out, alu_src_out, branch_out, mem_read_out, mem_write_out,
                mem_to_reg_out, reg_write_out, jump_out, halt_out);

  input clk, rst;
  input [15:0] pc_in, read1_in, read2_in, imm_in, jumpaddr_in;
  input [4:0] alu_op_in;
  input alu_src_in, branch_in, mem_read_in, mem_write_in, mem_to_reg_in;
  input reg_write_in, jump_in, halt_in;

  output [4:0] alu_op_out;
  output alu_src_out, branch_out, mem_read_out, mem_write_out, mem_to_reg_out;
  output reg_write_out, jump_out, halt_out;
  output [15:0] read1_out, read2_out, pc_out, imm_out, jumpaddr_out;

  dff PC_FF    [15:0] (.q(pc_out),        .d(pc_in),        .clk(clk), .rst(rst));
  dff READ1_FF [15:0] (.q(read1_out),     .d(read1_in),     .clk(clk), .rst(rst));
  dff READ2_FF [15:0] (.q(read2_out),     .d(read2_in),     .clk(clk), .rst(rst));
  dff IMM_FF   [15:0] (.q(imm_out),       .d(imm_in),       .clk(clk), .rst(rst));
  dff JUMP_FF  [15:0] (.q(jumpaddr_out),  .d(jumpaddr_in),  .clk(clk), .rst(rst));

  dff OP_FF [4:0] (.q(alu_op_out),     .d(alu_op_in),     .clk(clk), .rst(rst));
  dff SRC_FF      (.q(alu_src_out),    .d(alu_src_in),    .clk(clk), .rst(rst);
  dff BR_FF       (.q(branch_out),     .d(branch_in),     .clk(clk), .rst(rst);
  dff MEMR_FF     (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst);
  dff MEMW_FF     (.q(mem_write_out),  .d(mem_write_in),  .clk(clk), .rst(rst);
  dff MEMTR_FF    (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst);
  dff RW_FF       (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst);
  dff JUMP_FF     (.q(jump_out),       .d(jump_in),       .clk(clk), .rst(rst);
  dff HALT_FF     (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst);
endmodule
