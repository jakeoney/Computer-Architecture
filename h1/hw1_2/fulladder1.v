module fulladder1(A, B, Cin, S, Cout);
	input A;
	input B;
	input Cin;
	output S;
	output Cout;

	wire nand_AB, xor_AB, nand_AB_CIN;

	xor2 XOR_A_B(.in1(A), .in2(B), .out(xor_AB));
	xor2 XOR_AB_CIN(.in1(xor_AB), .in2(Cin), .out(S));

	nand2 NAND_A_B(.in1(A), .in2(B), .out(nand_AB));
	nand2 NAND_AB_CIN(.in1(xor_AB), .in2(Cin), .out(nand_AB_CIN));

	nand2 NAND_COUT(.in1(nand_AB), .in2(nand_AB_CIN), .out(Cout));

endmodule
