//Still need to verify this works
module sign_extend5bit(in, out);
	
	input [4:0] in;
	output [15:0] out;

	assign out = {{11{in[4]}},in}

endmodule
