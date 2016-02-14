module mux4_1_16bit(InD, InC, InB, InA, S, Out);

	input [15:0] InD, InC, InB, InA;
	input [1:0] S;
	output [15:0] Out;
	
	wire [15:0] low, high;

	mux2_1_16bit LOW (.InB(InB[15:0]), .InA(InA[15:0]), .S(S[0]), .Out(low[15:0]));
	mux2_1_16bit HIGH(.InB(InD[15:0]), .InA(InA[15:0]), .S(S[0]), .Out(high[15:0]));

	mux2_1_16bit TOP (.InB(high[15:0]), .InA(low[15:0]), .S(S[1]), .Out(Out[15:0]));

endmodule
