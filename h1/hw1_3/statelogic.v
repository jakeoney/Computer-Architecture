module statelogic(InA, state, next_state, Out);
	input InA;
	input [3:0] state;
	output reg [3:0] next_state;
	output Out;

	assign Out = state[3];

	always @(InA, state) begin
		casex({InA, state})
			//reset state
			5'b0_0000: 
				next_state <= 4'b0001;
			5'b1_0000: 
				next_state <= 4'b0000;
			
			//0 detected
			5'b0_0001: 
				next_state <= 4'b0001;
			5'b1_0001: 
				next_state <= 4'b0010;
			
			//01 detected
			5'b0_0010: 
				next_state <= 4'b0011;
			5'b1_0010: 
				next_state <= 4'b0000;
			
			//010 detected
			5'b0_0011: 
				next_state <= 4'b0001;
			5'b1_0011: 
				next_state <= 4'b0100;
			
			//0101 detected
			5'b0_0100: 
				next_state <= 4'b0101;
			5'b1_0100:
				next_state <= 4'b0000;

			//0101_0 detected
			5'b0_0101: 
				next_state <= 4'b0110;
			5'b1_0101:
				next_state <= 4'b0100;

			//0101_00 detected
			5'b0_0110: 
				next_state <= 4'b0001;
			5'b1_0110:
				next_state <= 4'b0111;
		
			//0101_001 detected
			5'b0_0111: 
				next_state <= 4'b0011;
			5'b1_0111:
				next_state <= 4'b1000;
			
			//0101_0011 detected
			5'b0_1000: 
				next_state <= 4'b0001;
			5'b1_1000:
				next_state <= 4'b0000;
		
			default:
				next_state <= 4'b0000;
		endcase
	end
endmodule
