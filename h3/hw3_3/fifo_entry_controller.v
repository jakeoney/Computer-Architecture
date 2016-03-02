module fifo_entry_controller(clk, rst, in, out, pop_fifo, data_in_valid, state);

	input clk, rst;
	input data_in_valid, pop_fifo;
	input [2:0] state;
	input [63:0] in;
	output [63:0] out;
//what state this is in. so we know how to move data around

//if fifo_empty && pop_fifo -> do nothing
//if fifo_full && data_in_valid -> do nothing

	wire [63:0] outEntry1, outEntry2, outEntry3, outEntry4;
	wire [63:0] inEntry1, inEntry2, inEntry3, inEntry4;
	wire is_state0, is_state1, is_state2, is_state3, is_state4;
	wire out_write, entry1_write, entry2_write, entry3_write, entry4_write;

	//Simple logic to check for which state we are currently in
	assign is_state0 = (~state[0]) & (~state[1]);
	assign is_state1 =   state[0]  & (~state[1]);
	assign is_state2 = (~state[0]) &   state[1];
	assign is_state3 =   state[0]  &   state[1];
	assign is_state4 =   state[2];

	//Mux logic to determine if we will be getting the input or a value from
	//another fifo entry -> inserted into current entry
	assign in_to_state0 = (data_in_valid & is_state0) | (pop_fifo & is_state1 & data_in_valid);
	assign in_to_state1 = (data_in_valid & is_state1) | (pop_fifo & is_state2 & data_in_valid);
	assign in_to_state2 = (data_in_valid & is_state2) | (pop_fifo & is_state3 & data_in_valid);
	assign in_to_state3 = (data_in_valid & is_state3) | (pop_fifo & is_state4 & data_in_valid);
	
	//only time we want to feed input to ENTRY1 IS WHEN WE ARE IN STATE 0
	mux2_1_64bit first (.InB(in), .InA(outEntry2), .S(in_to_state0), .Out(inEntry1));
	mux2_1_64bit second(.InB(in), .InA(outEntry3), .S(in_to_state1), .Out(inEntry2));
	mux2_1_64bit third (.InB(in), .InA(outEntry4), .S(in_to_state2), .Out(inEntry3));
	
//	assign out_write    = pop_fifo      & ~is_state0; 
	assign entry1_write = (data_in_valid & is_state0) | (pop_fifo & (~is_state0));
	assign entry2_write = (data_in_valid & is_state1) | (pop_fifo & ((~is_state1) | (~is_state0)));
	assign entry3_write = (data_in_valid & is_state2) | pop_fifo;
	assign entry4_write = (data_in_valid & is_state3);

	//fifo_entry OUT   (.in(outEntry1), .new_data(out_write), .out(out[63:0]), .clk(clk), .rst(rst));	
	fifo_entry ENTRY1(.in(inEntry1),  .new_data(entry1_write), .out(out), .clk(clk), .rst(rst));
	fifo_entry ENTRY2(.in(inEntry2),  .new_data(entry2_write), .out(outEntry2), .clk(clk), .rst(rst));
	fifo_entry ENTRY3(.in(inEntry3),  .new_data(entry3_write), .out(outEntry3), .clk(clk), .rst(rst));
	fifo_entry ENTRY4(.in(in),        .new_data(entry4_write), .out(outEntry4), .clk(clk), .rst(rst));

endmodule
