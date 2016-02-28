module reg16bit(clk, rst, write, writedata, readdata);
	input clk;
	input rst;
	input write;
	input [15:0] writedata;
	output [15:0] readdata;
	
	wire rst_or_write;
	wire new_clk;
	
	assign rst_or_write = rst | write;
	assign new_clk = rst_or_write & clk;

	dff ZERO (.q(readdata[0]),  .d(writedata[0]),  .clk(new_clk), .rst(rst));
	dff ONE  (.q(readdata[1]),  .d(writedata[1]),  .clk(new_clk), .rst(rst));
	dff TWO  (.q(readdata[2]),  .d(writedata[2]),  .clk(new_clk), .rst(rst));
	dff THREE(.q(readdata[3]),  .d(writedata[3]),  .clk(new_clk), .rst(rst));
	dff FOUR (.q(readdata[4]),  .d(writedata[4]),  .clk(new_clk), .rst(rst));
	dff FIVE (.q(readdata[5]),  .d(writedata[5]),  .clk(new_clk), .rst(rst));
	dff SIX  (.q(readdata[6]),  .d(writedata[6]),  .clk(new_clk), .rst(rst));
	dff SEVEN(.q(readdata[7]),  .d(writedata[7]),  .clk(new_clk), .rst(rst));
	dff EIGHT(.q(readdata[8]),  .d(writedata[8]),  .clk(new_clk), .rst(rst));
	dff NINE (.q(readdata[9]),  .d(writedata[9]),  .clk(new_clk), .rst(rst));
	dff TEN  (.q(readdata[10]), .d(writedata[10]), .clk(new_clk), .rst(rst));
	dff ELEVE(.q(readdata[11]), .d(writedata[11]), .clk(new_clk), .rst(rst));
	dff TWELV(.q(readdata[12]), .d(writedata[12]), .clk(new_clk), .rst(rst));
	dff THIRT(.q(readdata[13]), .d(writedata[13]), .clk(new_clk), .rst(rst));
	dff FOURT(.q(readdata[14]), .d(writedata[14]), .clk(new_clk), .rst(rst));
	dff FIFTE(.q(readdata[15]), .d(writedata[15]), .clk(new_clk), .rst(rst));

endmodule
