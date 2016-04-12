module id_ex_ff(clk, rst, pc_in, read1_in, read2_in, imm_in, jumpaddr_in,
                instr_in, write_reg_in,
                alu_op_in, alu_src_in, branch_in, mem_read_in, mem_write_in,
                mem_to_reg_in, reg_write_in, jump_in, halt_in,
                Rs_in, Rd_in, Rt_in, Rs_valid_in, Rt_valid_in, Rd_valid_in,
                zero_control_signals,

                read1_out, read2_out, pc_out, imm_out, jumpaddr_out, instr_out,
                write_reg_out,
                alu_op_out, alu_src_out, branch_out, mem_read_out, mem_write_out,
                mem_to_reg_out, reg_write_out, jump_out, halt_out,
                Rs_out, Rd_out, Rt_out, Rs_valid_out, Rt_valid_out, Rd_valid_out);

  input clk, rst;
  input [15:0] pc_in, read1_in, read2_in, imm_in, jumpaddr_in;
  input [4:0] alu_op_in;
  input [2:0] write_reg_in;
  input [1:0] instr_in;
  input alu_src_in, branch_in, mem_read_in, mem_write_in, mem_to_reg_in;
  input reg_write_in, jump_in, halt_in;
  input [2:0] Rs_in, Rd_in, Rt_in;
  input Rs_valid_in, Rt_valid_in, Rd_valid_in;
  input zero_control_signals;

  output [4:0] alu_op_out;
  output [2:0] write_reg_out;
  output [1:0] instr_out;
  output alu_src_out, branch_out, mem_read_out, mem_write_out, mem_to_reg_out;
  output reg_write_out, jump_out, halt_out;
  output [15:0] read1_out, read2_out, pc_out, imm_out, jumpaddr_out;
  output [2:0] Rs_out, Rd_out, Rt_out;
  output Rs_valid_out, Rt_valid_out, Rd_valid_out;

  wire mem_write_in_actual, reg_write_in_actual;

  dff PC_FF    [15:0] (.q(pc_out),        .d(pc_in),        .clk(clk), .rst(rst));
  dff READ1_FF [15:0] (.q(read1_out),     .d(read1_in),     .clk(clk), .rst(rst));
  dff READ2_FF [15:0] (.q(read2_out),     .d(read2_in),     .clk(clk), .rst(rst));
  dff IMM_FF   [15:0] (.q(imm_out),       .d(imm_in),       .clk(clk), .rst(rst));
  dff JUMPA_FF [15:0] (.q(jumpaddr_out),  .d(jumpaddr_in),  .clk(clk), .rst(rst));

  dff OP_FF [4:0] (.q(alu_op_out),     .d(alu_op_in),     .clk(clk), .rst(rst));
  
  dff WRITE_REG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

  dff INSTR [1:0] (.q(instr_out), .d(instr_in), .clk(clk), .rst(rst));

  dff SRC_FF      (.q(alu_src_out),    .d(alu_src_in),    .clk(clk), .rst(rst));
  dff BR_FF       (.q(branch_out),     .d(branch_in),     .clk(clk), .rst(rst));
  dff MEMR_FF     (.q(mem_read_out),   .d(mem_read_in),   .clk(clk), .rst(rst));
  //Signals to be zero'd
  assign mem_write_in_actual = (zero_control_signals) ? 1'b0 : mem_write_in;
  assign reg_write_in_actual = (zero_control_signals) ? 1'b0 : reg_write_in;

  dff MEMW_FF     (.q(mem_write_out),  .d(mem_write_in_actual),  .clk(clk), .rst(rst));
  dff RW_FF       (.q(reg_write_out),  .d(reg_write_in_actual),  .clk(clk), .rst(rst));
  //end signals to be zero'd

  dff MEMTR_FF    (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
  dff JUMP_FF     (.q(jump_out),       .d(jump_in),       .clk(clk), .rst(rst));
  dff HALT_FF     (.q(halt_out),       .d(halt_in),       .clk(clk), .rst(rst));

  dff RS [2:0] (.q(Rs_out),       .d(Rs_in),       .clk(clk), .rst(rst));
  dff RT [2:0] (.q(Rt_out),       .d(Rt_in),       .clk(clk), .rst(rst));
  dff RD [2:0] (.q(Rd_out),       .d(Rd_in),       .clk(clk), .rst(rst));
  dff RS_V     (.q(Rs_valid_out), .d(Rs_valid_in), .clk(clk), .rst(rst));
  dff RT_V     (.q(Rt_valid_out), .d(Rt_valid_in), .clk(clk), .rst(rst));
  dff RD_V     (.q(Rd_valid_out), .d(Rd_valid_in), .clk(clk), .rst(rst));
endmodule
