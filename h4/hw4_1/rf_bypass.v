module rf_bypass (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
  input clk, rst;
  input [2:0] read1regsel;
  input [2:0] read2regsel;
  input [2:0] writeregsel;
  input [15:0] writedata;
  input        write;

  output [15:0] read1data;
  output [15:0] read2data;
  output        err;

	wire [15:0] read1datainit, read2datainit;

	assign read1data = write && (read1regsel == writeregsel) ? writedata : read1datainit;
	assign read2data = write && (read2regsel == writeregsel) ? writedata : read2datainit;

	rf REG(.read1data(read1datainit), .read2data(read2datainit), .err(err), .clk(clk), .rst(rst), .read1regsel(read1regsel), .read2regsel(read2regsel), .writeregsel(writeregsel), .writedata(writedata), .write(write));

endmodule
