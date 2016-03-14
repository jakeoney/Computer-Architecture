module mux8_1_16bit(InH, InG, InF, InE, InD, InC, InB, InA, S, Out);
	input  [15:0] InH, InG, InF, InE, InD, InC, InB, InA;
	input  [2:0] S;
	output [15:0] Out;

	wire [15:0] low, high;

	mux4_1_16bit LOW (.InD(InD[15:0]), .InC(InC[15:0]), .InB(InB[15:0]), .InA(InA[15:0]), .S(S[1:0]), .Out(low[15:0]));
	mux4_1_16bit HIGH(.InD(InH[15:0]), .InC(InG[15:0]), .InB(InF[15:0]), .InA(InE[15:0]), .S(S[1:0]), .Out(high[15:0]));

	mux2_1_16bit TOP (.InB(high[15:0]), .InA(low[15:0]), .S(S[2]), .Out(Out[15:0]));
	
endmodule
