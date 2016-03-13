module fifo_logic(state, next_state, fifo_empty, fifo_full, err, data_in_valid, pop_fifo);

	input [2:0] state;
	input data_in_valid, pop_fifo;
	output reg [2:0] next_state;
	output reg fifo_empty, fifo_full;
	output reg err;

//	always @(state, data_in_valid, pop_fifo) begin
	always @(*) begin
		//defaults
		fifo_empty <= 1'b0;
		fifo_full <= 1'b0;
		err <= 1'b0;
		casex({pop_fifo, data_in_valid, state})
			// No data-in valid or pop so stay in same state
			5'b0_0_000:begin
				fifo_empty <= 1'b1;
				next_state <= 3'b000;
			end
			5'b0_0_001:begin
				next_state <= 3'b001;
			end
			5'b0_0_010:
				next_state <= 3'b010;
			5'b0_0_011:
				next_state <= 3'b011;
			5'b0_0_100:begin
				fifo_full <= 1'b1;
				next_state <= 3'b100;
			end
			//end no data-in valid or pop

			//data-in valid logic
			5'b0_1_000:begin
				fifo_empty <= 1'b1;
				next_state <= 3'b001;
			end
			5'b0_1_001:
				next_state <= 3'b010;
			5'b0_1_010:
				next_state <= 3'b011;
			5'b0_1_011:
				begin
					//fifo_full <= 1'b1;
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
				//	fifo_empty <= 1'b1;
					next_state <= 3'b000;
				end
			5'b1_0_010:
				next_state <= 3'b001;
			5'b1_0_011:
				next_state <= 3'b010;
			5'b1_0_100:begin
				fifo_full <= 1'b1;
				next_state <= 3'b011;
			end
			//end pop fifo logic

			//what to do when there is data-in valid and pop fifo
			5'b1_1_000:
				begin
					//pop should be ignored...
					next_state <= 3'b001;
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
					//ignore data_in
					next_state <= 3'b011;
				end
			//end data-in valid and pop fifo
			
			default:
				//Should never make it here
				begin
					err <= 1'b1;
					next_state <= 3'b111;
				end
		endcase
	end
endmodule
