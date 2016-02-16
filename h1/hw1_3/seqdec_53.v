module seqdec_53(InA, Clk, Reset, Out);
	input InA;
	input Clk;
	input Reset;
	output Out;

	wire [3:0] state;
	wire [3:0] next_state;

	statereg state_reg(.state(state), .next_state(next_state), .Clk(Clk), .Reset(Reset));
	statelogic state_logic(.next_state(next_state), .Out(Out), .state(state), .InA(InA));

endmodule
