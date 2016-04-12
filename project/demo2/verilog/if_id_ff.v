module if_id_ff(pc_in, instr_in, clk, rst, instr_valid, IF_ID_Write,
                pc_out, instr_out, instr_valid_out);

  input clk, rst;
  input instr_valid;
  input [15:0] pc_in;
  input [15:0] instr_in;
  input IF_ID_Write;
  output instr_valid_out;
  output [15:0] pc_out;
  output [15:0] instr_out;

  wire [15:0] instr;

  //dff VALID          (.q(instr_valid_out), .d(instr_valid), .clk(clk&IF_ID_Write), .rst(rst));
  //dff PC_FF [15:0]   (.q(pc_out),          .d(pc_in),       .clk(clk&IF_ID_Write), .rst(rst));
  //dff INSTR_FF [15:0](.q(instr_out),       .d(instr_in),    .clk(clk&IF_ID_Write), .rst(rst));
  dff VALID          (.q(instr_valid_out), .d(instr_valid), .clk(clk), .rst(rst));
  dff PC_FF [15:0]   (.q(pc_out),          .d(pc_in),       .clk(clk), .rst(rst));
  dff INSTR_FF [15:0](.q(instr_out),       .d(instr_in),    .clk(clk), .rst(rst));

endmodule
