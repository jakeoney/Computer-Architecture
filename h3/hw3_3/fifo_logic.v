module fifo_logic(state, next_state, fifo_empty, fifo_full, err, data_in_valid, pop_fifo);

	input [2:0] state;
//	input [63:0] data_in;//I don't think I want to do anything with this here
	input data_in_valid, pop_fifo;
	output [2:0] next_state;
//	output [63:0] data_out;//I don't think I want to do anything with this here
	output reg fifo_empty, fifo_full;
	output reg err;

	// i think im going to seperate combinational and sequential (controller)
	//
	// im thinking i can do all the logic here and right the "move stuff around
	// in fifo logic in controller file
	//
	// i can assert empty and full signals here
	//
	// i can do some logic based on pop and data in valid to determine what to
	// do with info in the fifo in controller

	always @(state, data_in_valid,pop_fifo) begin
		//defaults
		fifo_empty <= 1'b0;
		fifo_full <= 1'b0;
		err <= 1'b0;
		casex({data_in_valid, pop_fifo, state})
			// No data-in valid or pop so stay in same state
			5'b0_0_000:
				next_state <= 3'b000;
			5'b0_0_001:
				next_state <= 3'b001;
			5'b0_0_010:
				next_state <= 3'b010;
			5'b0_0_011:
				next_state <= 3'b011;
			5'b0_0_100:
				next_state <= 3'b100;
			//end no data-in valid or pop

			//data-in valid logic
			5'b0_1_000:
				next_state <= 3'b001;
			5'b0_1_001:
				next_state <= 3'b010;
			5'b0_1_010:
				next_state <= 3'b011;
			5'b0_1_011:
				begin
					fifo_full <= 1'b1;
					next_state <= 3'b100;
				end
			5'b0_1_100: //ignore new data in since fifo full
				begin
					fifo_full <= 1'b1;
					next_state <= 3'b100;
				end
			//end data-in valid logic

			//pop fifo logic
			5'b1_0_000: //can't pop anything since fifo empty
				begin
					fifo_empty <= 1'b1;
					next_state <= 3'b000;
				end
			5'b1_0_001:
				begin
					fifo_empty <= 1'b1;
					next_state <= 3'b000;
				end
			5'b1_0_010:
				next_state <= 3'b001;
			5'b1_0_011:
				next_state <= 3'b010;
			5'b1_0_100:
				next_state <= 3'b011;
			//end pop fifo logic

			//what to do when there is data-in valid and pop fifo
			5'b1_1_000:
				begin
					next_state <= 3'b000;
					fifo_empty <= 1'b1;
				end
			5'b1_1_001:
				next_state <= 3'b001;
			5'b1_1_010:
				next_state <= 3'b010;
			5'b1_1_011:
				next_state <= 3'b011;
			5'b1_1_100:
				begin
					fifo_full <= 1'b1;
					next_state <= 3'b100;
				end
			//end data-in valid and pop fifo
			
			default:
				//Should never make it here
				begin
					err <= 1'b1;
					next_state <= 1'b111;
				end
		endcase
	end
endmodule
