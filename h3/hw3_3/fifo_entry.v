module fifo_entry(in, new_data, out, clk, rst);

	input [63:0] in;
	//save new data signal. either 64'h00000000 if empty or the new data.
	//controlled at the level above.
	input new_data;
	input clk;
	input rst;
	output [63:0] out;

	wire new_clk;
	//might want ~clk here
	assign new_clk = ~clk & new_data;

	dff bit0 (.q(out[0]),  .d(in[0]),  .clk(new_clk), .rst(rst));
	dff bit1 (.q(out[1]),  .d(in[1]),  .clk(new_clk), .rst(rst));
	dff bit2 (.q(out[2]),  .d(in[2]),  .clk(new_clk), .rst(rst));
	dff bit3 (.q(out[3]),  .d(in[3]),  .clk(new_clk), .rst(rst));
	dff bit4 (.q(out[4]),  .d(in[4]),  .clk(new_clk), .rst(rst));
	dff bit5 (.q(out[5]),  .d(in[5]),  .clk(new_clk), .rst(rst));
	dff bit6 (.q(out[6]),  .d(in[6]),  .clk(new_clk), .rst(rst));
	dff bit7 (.q(out[7]),  .d(in[7]),  .clk(new_clk), .rst(rst));
	dff bit8 (.q(out[8]),  .d(in[8]),  .clk(new_clk), .rst(rst));
	dff bit9 (.q(out[9]),  .d(in[9]),  .clk(new_clk), .rst(rst));
	dff bit10(.q(out[10]), .d(in[10]), .clk(new_clk), .rst(rst));
	dff bit11(.q(out[11]), .d(in[11]), .clk(new_clk), .rst(rst));
	dff bit12(.q(out[12]), .d(in[12]), .clk(new_clk), .rst(rst));
	dff bit13(.q(out[13]), .d(in[13]), .clk(new_clk), .rst(rst));
	dff bit14(.q(out[14]), .d(in[14]), .clk(new_clk), .rst(rst));
	dff bit15(.q(out[15]), .d(in[15]), .clk(new_clk), .rst(rst));
	dff bit16(.q(out[16]), .d(in[16]), .clk(new_clk), .rst(rst));
	dff bit17(.q(out[17]), .d(in[17]), .clk(new_clk), .rst(rst));
	dff bit18(.q(out[18]), .d(in[18]), .clk(new_clk), .rst(rst));
	dff bit19(.q(out[19]), .d(in[19]), .clk(new_clk), .rst(rst));
	dff bit20(.q(out[20]), .d(in[20]), .clk(new_clk), .rst(rst));
	dff bit21(.q(out[21]), .d(in[21]), .clk(new_clk), .rst(rst));
	dff bit22(.q(out[22]), .d(in[22]), .clk(new_clk), .rst(rst));
	dff bit23(.q(out[23]), .d(in[23]), .clk(new_clk), .rst(rst));
	dff bit24(.q(out[24]), .d(in[24]), .clk(new_clk), .rst(rst));
	dff bit25(.q(out[25]), .d(in[25]), .clk(new_clk), .rst(rst));
	dff bit26(.q(out[26]), .d(in[26]), .clk(new_clk), .rst(rst));
	dff bit27(.q(out[27]), .d(in[27]), .clk(new_clk), .rst(rst));
	dff bit28(.q(out[28]), .d(in[28]), .clk(new_clk), .rst(rst));
	dff bit29(.q(out[29]), .d(in[29]), .clk(new_clk), .rst(rst));
	dff bit30(.q(out[30]), .d(in[30]), .clk(new_clk), .rst(rst));
	dff bit31(.q(out[31]), .d(in[31]), .clk(new_clk), .rst(rst));
	dff bit32(.q(out[32]), .d(in[32]), .clk(new_clk), .rst(rst));
	dff bit33(.q(out[33]), .d(in[33]), .clk(new_clk), .rst(rst));
	dff bit34(.q(out[34]), .d(in[34]), .clk(new_clk), .rst(rst));
	dff bit35(.q(out[35]), .d(in[35]), .clk(new_clk), .rst(rst));
	dff bit36(.q(out[36]), .d(in[36]), .clk(new_clk), .rst(rst));
	dff bit37(.q(out[37]), .d(in[37]), .clk(new_clk), .rst(rst));
	dff bit38(.q(out[38]), .d(in[38]), .clk(new_clk), .rst(rst));
	dff bit39(.q(out[39]), .d(in[39]), .clk(new_clk), .rst(rst));
	dff bit40(.q(out[40]), .d(in[40]), .clk(new_clk), .rst(rst));
	dff bit41(.q(out[41]), .d(in[41]), .clk(new_clk), .rst(rst));
	dff bit42(.q(out[42]), .d(in[42]), .clk(new_clk), .rst(rst));
	dff bit43(.q(out[43]), .d(in[43]), .clk(new_clk), .rst(rst));
	dff bit44(.q(out[44]), .d(in[44]), .clk(new_clk), .rst(rst));
	dff bit45(.q(out[45]), .d(in[45]), .clk(new_clk), .rst(rst));
	dff bit46(.q(out[46]), .d(in[46]), .clk(new_clk), .rst(rst));
	dff bit47(.q(out[47]), .d(in[47]), .clk(new_clk), .rst(rst));
	dff bit48(.q(out[48]), .d(in[48]), .clk(new_clk), .rst(rst));
	dff bit49(.q(out[49]), .d(in[49]), .clk(new_clk), .rst(rst));
	dff bit50(.q(out[50]), .d(in[50]), .clk(new_clk), .rst(rst));
	dff bit51(.q(out[51]), .d(in[51]), .clk(new_clk), .rst(rst));
	dff bit52(.q(out[52]), .d(in[52]), .clk(new_clk), .rst(rst));
	dff bit53(.q(out[53]), .d(in[53]), .clk(new_clk), .rst(rst));
	dff bit54(.q(out[54]), .d(in[54]), .clk(new_clk), .rst(rst));
	dff bit55(.q(out[55]), .d(in[55]), .clk(new_clk), .rst(rst));
	dff bit56(.q(out[56]), .d(in[56]), .clk(new_clk), .rst(rst));
	dff bit57(.q(out[57]), .d(in[57]), .clk(new_clk), .rst(rst));
	dff bit58(.q(out[58]), .d(in[58]), .clk(new_clk), .rst(rst));
	dff bit59(.q(out[59]), .d(in[59]), .clk(new_clk), .rst(rst));
	dff bit60(.q(out[60]), .d(in[60]), .clk(new_clk), .rst(rst));
	dff bit61(.q(out[61]), .d(in[61]), .clk(new_clk), .rst(rst));
	dff bit62(.q(out[62]), .d(in[62]), .clk(new_clk), .rst(rst));
	dff bit63(.q(out[63]), .d(in[63]), .clk(new_clk), .rst(rst));
endmodule
