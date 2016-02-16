module mux4_1(InA, InB, InC, InD, S, Out);
	input InA;
	input InB;
	input InC;
	input InD;
	input [1:0] S;
	output Out;

	wire low, high;

	mux2_1 LOW(.InA(InB), .InB(InA), .S(S[0]), .Out(low));
	mux2_1 HIGH(.InA(InD), .InB(InC), .S(S[0]), .Out(high));
	
	mux2_1 TOP(.InA(high), .InB(low), .S(S[1]), .Out(Out));

endmodule

