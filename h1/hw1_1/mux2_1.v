module mux2_1(InA, InB, S, Out);
	input InA;
	input InB;
	input S;
	output Out;

	wire notS;
	wire nandAS, nandBS;

	not1 N1(.in1(S), .out(notS));
	
	nand2 NA1(.in1(InA), .in2(S), .out(nandAS));
	nand2 NA2(.in1(InB), .in2(notS), .out(nandBS));

	nand2 NA3(.in1(nandAS), .in2(nandBS), .out(Out));

endmodule
