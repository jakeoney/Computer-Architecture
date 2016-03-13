module mux2_1_64bit(InB, InA, S, Out);

	input [63:0] InB, InA;
	input  S;
	output [63:0] Out;

	mux2_1_16bit LOW    (.InB(InB[15:0]),  .InA(InA[15:0]),  .S(S), .Out(Out[15:0]));
	mux2_1_16bit LOWMID (.InB(InB[31:16]), .InA(InA[31:16]), .S(S), .Out(Out[31:16]));
	mux2_1_16bit HIGHMID(.InB(InB[47:32]), .InA(InA[47:32]), .S(S), .Out(Out[47:32]));
	mux2_1_16bit HIGH   (.InB(InB[63:48]), .InA(InA[63:48]), .S(S), .Out(Out[63:48]));

endmodule
