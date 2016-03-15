module mux2_1(InA, InB, S, Out);
	input InA;
	input InB;
	input S;
	output Out;

	wire notS;
	wire nandAS, nandBS;

	not1 N1(.in1(S), .out(notS));
	
	nand2 NA1(.in1(InB), .in2(S), .out(nandBS));
	nand2 NA2(.in1(InA), .in2(notS), .out(nandAS));

	nand2 NA3(.in1(nandBS), .in2(nandAS), .out(Out));

endmodule
