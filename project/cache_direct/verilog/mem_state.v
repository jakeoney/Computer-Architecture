module mem_state(clk, rst, state, next_state);

  input clk, rst;
  input [3:0] state;

  output [3:0] next_state;

  dff STATE [3:0](.d(next_state), .q(state), .clk(clk), .rst(rst));
endmodule
