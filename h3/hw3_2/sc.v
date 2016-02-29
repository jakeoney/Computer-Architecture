module sc( clk, rst, ctr_rst, out, err);
  input clk;
  input rst;
  input ctr_rst;
  output [2:0] out;
	output err;

	wire [2:0] state;
	wire [2:0] next_state;

	sc_reg 		sc_state_reg(.state(state), .next_state(next_state), .clk(clk), .rst(rst));
	sc_logic 	sc_state_logic(.next_state(next_state), .out(out), .state(state), .in(ctr_rst), .err(err));

endmodule
