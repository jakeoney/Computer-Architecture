module sc_logic(in, state, next_state, out, err);
	
	input in; //ctr_rst signal from the controller
	input [2:0] state;
	output reg [2:0] next_state;
	output [2:0] out;
	output reg err;

	assign out = state[2:0];

	always @(in, state) begin
		//Set default value for err
		err = 1'b0;
		casex({in, state})
			//In = 0 therefore we count until we hit 3'b101
			4'b0_000:
				next_state <= 3'b001;
			4'b0_001:
				next_state <= 3'b010;
			4'b0_010:
				next_state <= 3'b011; 
			4'b0_011:
				next_state <= 3'b100;
			4'b0_100:
				next_state <= 3'b101;
			4'b0_101:
				next_state <= 3'b101;

			//In = 1 therefore we go back to 3'b000
			4'b1_000:
				next_state <= 3'b000;
			4'b1_001:
				next_state <= 3'b000;
			4'b1_010:
				next_state <= 3'b000;
			4'b1_011:
				next_state <= 3'b000;
			4'b1_100:
				next_state <= 3'b000;
			4'b1_101:
				next_state <= 3'b000;

			//STATES NOT REACHABLE therefore assert err=1
			//Stay in this bad state until reset?
			default:
				begin
					err <= 1'b1;
					next_state <= 3'b111;
				end
		endcase
	end
endmodule
