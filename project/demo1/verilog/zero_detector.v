module zero_detector(In, Z);

	input [15:0] In;
	output Z;

	assign Z = ~|In; 

endmodule
