module fifo_entry_controller(clk, rst, in, out, pop_fifo, data_in_valid, state);

	input clk, rst;
	input data_in_valid, pop_fifo;
	input [2:0] state;
	input [63:0] in;
	output [63:0] out;

	wire [63:0] outEntry1, outEntry2, outEntry3, outEntry4;
	wire [63:0] inEntry1, inEntry2, inEntry3, inEntry4;
	wire is_state0, is_state1, is_state2, is_state3, is_state4;
	wire in_to_entry1, in_to_entry2, in_to_entry3, in_to_entry4;
	wire emptying_entry1, emptying_entry2, emptying_entry3;
	wire entry1_write, entry2_write, entry3_write, entry4_write;
	wire [63:0] zero;

	assign zero = 64'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;

	//Simple logic to check for which state we are currently in
	assign is_state0 = ((~state[0]) & (~state[1])) & (~state[2]);
	assign is_state1 =   state[0]  & (~state[1]);
	assign is_state2 = (~state[0]) &   state[1];
	assign is_state3 =   state[0]  &   state[1];
	assign is_state4 =   state[2];

	//Mux select logic
	assign in_to_entry1 = (data_in_valid & is_state0) | ((pop_fifo & is_state1) & data_in_valid);
	assign emptying_entry1 = (is_state0 & (~data_in_valid)) | rst;
	assign in_to_entry2 = ((data_in_valid & is_state1) & (~pop_fifo)) | ((pop_fifo & is_state2) & data_in_valid);
	assign emptying_entry2 = ((is_state1 | is_state0) & (~data_in_valid)) | rst;
	assign in_to_entry3 = ((data_in_valid & is_state2) & (~pop_fifo)) | ((pop_fifo & is_state3) & data_in_valid);
	assign emptying_entry3 = ((is_state2 & (~data_in_valid)) | is_state1 | is_state0) | rst;
	assign in_to_entry4 = ((data_in_valid & is_state3) & (~pop_fifo));
	
	//Mux for each fifo input
	mux4_1_64bit first (.InD(zero), .InC(zero), .InB(in), .InA(outEntry2), .S({emptying_entry1,in_to_entry1}), .Out(inEntry1));
	mux4_1_64bit second(.InD(zero), .InC(zero), .InB(in), .InA(outEntry3), .S({emptying_entry2,in_to_entry2}), .Out(inEntry2));
	mux4_1_64bit third (.InD(zero), .InC(zero), .InB(in), .InA(outEntry4), .S({emptying_entry3,in_to_entry3}), .Out(inEntry3));
	mux2_1_64bit fourth(.InB(in),   .InA(zero), .S(in_to_entry4), .Out(inEntry4));
	
	//Logic to determine if write to fifo entry
	assign entry1_write = ((data_in_valid & pop_fifo) | ((pop_fifo & (~is_state0)) | (data_in_valid & is_state0))) | rst;
	assign entry2_write = (((data_in_valid & is_state1) & (~pop_fifo)) | (pop_fifo & (~is_state0))) | rst;
	assign entry3_write = (((data_in_valid & is_state2) & (~pop_fifo)) | ((pop_fifo & (~is_state0)) & (~is_state1))) | rst;
	assign entry4_write = (((data_in_valid & is_state3) & (~pop_fifo)) | (pop_fifo & is_state4)) | rst;

	//Instance of each fifo entry
	fifo_entry ENTRY1(.in(inEntry1),  .new_data(entry1_write), .out(out),       .clk(clk), .rst(rst));
	fifo_entry ENTRY2(.in(inEntry2),  .new_data(entry2_write), .out(outEntry2), .clk(clk), .rst(rst));
	fifo_entry ENTRY3(.in(inEntry3),  .new_data(entry3_write), .out(outEntry3), .clk(clk), .rst(rst));
	fifo_entry ENTRY4(.in(inEntry4),  .new_data(entry4_write), .out(outEntry4), .clk(clk), .rst(rst));

endmodule
