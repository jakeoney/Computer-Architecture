module statereg(state, next_state, Clk, Reset);
	input [3:0] next_state;
	input Clk;
	input Reset;
	
	output [3:0] state;
	
	dff state_flop3(.d(next_state[3]), .q(state[3]), .clk(Clk), .rst(Reset));
	dff state_flop2(.d(next_state[2]), .q(state[2]), .clk(Clk), .rst(Reset));
	dff state_flop1(.d(next_state[1]), .q(state[1]), .clk(Clk), .rst(Reset));
	dff state_flop0(.d(next_state[0]), .q(state[0]), .clk(Clk), .rst(Reset));

endmodule
