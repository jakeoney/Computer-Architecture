module fifo(data_out, fifo_empty, fifo_full, err, data_in, data_in_valid, pop_fifo, clk, rst);
  input [63:0] data_in;
  input        data_in_valid;
  input        pop_fifo;
  input        clk;
  input        rst;
  output [63:0] data_out;
  output        fifo_empty;
  output        fifo_full;
  output        err;
   
	wire [2:0] state, next_state;

	fifo_reg fifo_state_reg(.state(state), .next_state(next_state), .clk(clk), .rst(rst));	

	fifo_logic fifo_state_logic(.state(state), .next_state(next_state), .fifo_empty(fifo_empty), .fifo_full(fifo_full), .err(err), .data_in_valid(data_in_valid), .pop_fifo(pop_fifo));

	fifo_entry_controller fifo_control(.clk(clk), .rst(rst), .in(data_in), .out(data_out), .pop_fifo(pop_fifo), .data_in_valid(data_in_valid), .state(state));
endmodule
