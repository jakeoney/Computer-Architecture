module decode3_8(in, out);
	input [2:0] in;
	output [7:0] out;

	wire[2:0] not_in;

	assign not_in[0] = ~in[0];
	assign not_in[1] = ~in[1];
	assign not_in[2] = ~in[2];

	assign out[0] = not_in[2] & not_in[1] & not_in[0];
	assign out[1] = not_in[2] & not_in[1] & in[0];
	assign out[2] = not_in[2] & in[1] 		& not_in[0];
	assign out[3] = not_in[2] & in[1] 		& in[0];
	assign out[4] = in[2]			& not_in[1] & not_in[0];
	assign out[5] = in[2] 		& not_in[1] & in[0];
	assign out[6] = in[2]			& in[1] 		& not_in[0];
	assign out[7] = in[2] 		& in[1] 		& in[0];

endmodule
