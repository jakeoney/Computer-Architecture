module mem_wb_ff(clk, rst, data_mem_in,  
                 alu_result_in, write_reg_in, mem_to_reg_in, reg_write_in,
                 Rs_in, Rd_in, Rt_in, Rs_valid_in, Rt_valid_in, Rd_valid_in,
                 data_mem_out, alu_result_out, 
                 write_reg_out, mem_to_reg_out, reg_write_out,
                 Rs_out, Rd_out, Rt_out, Rs_valid_out, Rt_valid_out, Rd_valid_out);

  input clk, rst;
  input [15:0]data_mem_in, alu_result_in;
  input [2:0] write_reg_in;
  input mem_to_reg_in, reg_write_in;
  input [2:0] Rs_in, Rd_in, Rt_in;
  input Rs_valid_in, Rt_valid_in, Rd_valid_in;

  output [15:0] data_mem_out, alu_result_out;
  output [2:0] write_reg_out;
  output mem_to_reg_out, reg_write_out;
  output [2:0] Rs_out, Rd_out, Rt_out;
  output Rs_valid_out, Rt_valid_out, Rd_valid_out;

  dff DMEM [15:0](.q(data_mem_out),     .d(data_mem_in),     .clk(clk), .rst(rst));
  dff ALUR [15:0](.q(alu_result_out),   .d(alu_result_in),   .clk(clk), .rst(rst));

  dff WREG [2:0] (.q(write_reg_out), .d(write_reg_in), .clk(clk), .rst(rst));

  dff MTR  (.q(mem_to_reg_out), .d(mem_to_reg_in), .clk(clk), .rst(rst));
  dff REGW (.q(reg_write_out),  .d(reg_write_in),  .clk(clk), .rst(rst));
  
  dff RS [2:0] (.q(Rs_out),       .d(Rs_in),       .clk(clk), .rst(rst));
  dff RT [2:0] (.q(Rt_out),       .d(Rt_in),       .clk(clk), .rst(rst));
  dff RD [2:0] (.q(Rd_out),       .d(Rd_in),       .clk(clk), .rst(rst));
  dff RS_V     (.q(Rs_valid_out), .d(Rs_valid_in), .clk(clk), .rst(rst));
  dff RT_V     (.q(Rt_valid_out), .d(Rt_valid_in), .clk(clk), .rst(rst));
  dff RD_V     (.q(Rd_valid_out), .d(Rd_valid_in), .clk(clk), .rst(rst));
endmodule
