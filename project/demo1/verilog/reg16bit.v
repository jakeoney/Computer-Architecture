module reg16bit(clk, rst, write, writedata, readdata);
  input clk;
  input rst;
  input write;
  input [15:0] writedata;
  output [15:0] readdata;

  wire [15:0] read;
  

  assign read = write ? writedata : readdata;   

  dff REGS[15:0](.q(readdata),  .d(read),  .clk(clk), .rst(rst));

endmodule
