module eight_registers(clk, rst, write, writedata, read0, read1, read2, read3, read4, read5, read6, read7);
  input clk;
  input rst;
  input [7:0] write;
  input [15:0] writedata;
  output[15:0] read0, read1, read2, read3, read4, read5, read6, read7;

  reg16bit ZERO (.clk(clk), .rst(rst), .write(write[0]),  .writedata(writedata[15:0]), .readdata(read0[15:0]));
  reg16bit ONE  (.clk(clk), .rst(rst), .write(write[1]),  .writedata(writedata[15:0]), .readdata(read1[15:0]));
  reg16bit TWO  (.clk(clk), .rst(rst), .write(write[2]),  .writedata(writedata[15:0]), .readdata(read2[15:0]));
  reg16bit THREE(.clk(clk), .rst(rst), .write(write[3]),  .writedata(writedata[15:0]), .readdata(read3[15:0]));
  reg16bit FOUR (.clk(clk), .rst(rst), .write(write[4]),  .writedata(writedata[15:0]), .readdata(read4[15:0]));
  reg16bit FIVE (.clk(clk), .rst(rst), .write(write[5]),  .writedata(writedata[15:0]), .readdata(read5[15:0]));
  reg16bit SIX  (.clk(clk), .rst(rst), .write(write[6]),  .writedata(writedata[15:0]), .readdata(read6[15:0]));
  reg16bit SEVEN(.clk(clk), .rst(rst), .write(write[7]),  .writedata(writedata[15:0]), .readdata(read7[15:0]));

endmodule
