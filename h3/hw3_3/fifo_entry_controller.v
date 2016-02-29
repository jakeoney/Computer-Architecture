module fifo_entry_controller(clk, rst, in, out, pop_fifo, data_in_valid);

	input clk, rst;
	input data_in_valid, pop_fifo;
	input [63:0] in;
	output [63:0] out;
//what state this is in. so we know how to move data around
//
//im also thinking messing with the "clk" and doing some mux'ing
	fifo_entry ENTRY1(.in(), .new_data(), .out(), .clk(clk), .rst(rst));
	fifo_entry ENTRY2(.in(), .new_data(), .out(), .clk(clk), .rst(rst));
	fifo_entry ENTRY3(.in(), .new_data(), .out(), .clk(clk), .rst(rst));
	fifo_entry ENTRY4(.in(), .new_data(), .out(), .clk(clk), .rst(rst));

endmodule
