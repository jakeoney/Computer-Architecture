module sc_reg(state, next_state, clk, rst);
	input [2:0] next_state;
	input clk;
	input rst;
	
	output [2:0] state;
	
	dff state_flop2(.d(next_state[2]), .q(state[2]), .clk(clk), .rst(rst));
	dff state_flop1(.d(next_state[1]), .q(state[1]), .clk(clk), .rst(rst));
	dff state_flop0(.d(next_state[0]), .q(state[0]), .clk(clk), .rst(rst));

endmodule
