module mux4_1_64bit(InD, InC, InB, InA, S, Out);

	input [63:0] InD, InC, InB, InA;
	input [1:0] S;
	output [63:0] Out;

	mux4_1_16bit LOW    (.InD(InD[15:0]),  .InC(InC[15:0]),  .InB(InB[15:0]),  .InA(InA[15:0]),  .S(S[1:0]), .Out(Out[15:0]));
	mux4_1_16bit LOWMID (.InD(InD[31:16]), .InC(InC[31:16]), .InB(InB[31:16]), .InA(InA[31:16]), .S(S[1:0]), .Out(Out[31:16]));
	mux4_1_16bit HIGHMID(.InD(InD[47:32]), .InC(InC[47:32]), .InB(InB[47:32]), .InA(InA[47:32]), .S(S[1:0]), .Out(Out[47:32]));
	mux4_1_16bit HIGH   (.InD(InD[63:48]), .InC(InC[63:48]), .InB(InB[63:48]), .InA(InA[63:48]), .S(S[1:0]), .Out(Out[63:48]));

endmodule
