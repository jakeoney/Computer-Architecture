module adder1b(A, B, Cin, P, G, Sum);
	input A, B, Cin;
	output P, G, Sum;

	assign G = A & B;
	assign P = A | B;

	assign Sum = ((A ^ B) ^ Cin);

endmodule
