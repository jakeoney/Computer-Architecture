module if_id_ff(pc_in, instr_in, clk, rst,
                pc_out, instr_out);

  input clk, rst;
  input [15:0] pc_in;
  input [15:0] instr_in;

  output [15:0] pc_out;
  output [15:0] instr_out;

  dff PC_FF [15:0](.q(pc_out), .d(pc_in), .clk(clk), .rst(rst));
  dff INSTR_FF [15:0](.q(instr_out), .d(instr_in), .clk(clk), .rst(rst));

endmodule
