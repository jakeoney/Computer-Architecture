module fulladder4(A, B, CI, SUM, CO);
	input [3:0] A;
	input [3:0] B;
	input CI;

	output [3:0] SUM;
	output CO;

	wire ci1, ci2, ci3;

	fulladder1 ONE(.A(A[0]), .B(B[0]), .Cin(CI), .S(SUM[0]), .Cout(ci1));
	fulladder1 TWO(.A(A[1]), .B(B[1]), .Cin(ci1), .S(SUM[1]), .Cout(ci2));
	fulladder1 THREE(.A(A[2]), .B(B[2]), .Cin(ci2), .S(SUM[2]), .Cout(ci3));
	fulladder1 FOUR(.A(A[3]), .B(B[3]), .Cin(ci3), .S(SUM[3]), .Cout(CO));

endmodule
