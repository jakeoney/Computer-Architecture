module alu (A, B, Cin, Op, sign, Out, Ofl, Z);
   
	input [15:0] A;
  input [15:0] B;
  input Cin;
  input [2:0] Op;
  input sign;
  
	output [15:0] Out;
  output Ofl;
  output Z;

	wire [15:0] cout, G, P;
	wire [3:0] outP, outG;
	wire top_outP, top_outG;
	wire [3:0] top_cout;

	wire signed_overflow;
	
	//First Set of Adders and CLA for 4 LSBs (ie bits [3:0])
	adder1b ZERO  (.A(A[0]),  .B(B[0]),  .Cin(Cin),        .Sum(Out[0]),  .P(P[0]),  .G(G[0]));
	adder1b ONE   (.A(A[1]),  .B(B[1]),  .Cin(cout[0]),    .Sum(Out[1]),  .P(P[1]),  .G(G[1]));
	adder1b TWO   (.A(A[2]),  .B(B[2]),  .Cin(cout[1]),    .Sum(Out[2]),  .P(P[2]),  .G(G[2]));
	adder1b THREE (.A(A[3]),  .B(B[3]),  .Cin(cout[2]),    .Sum(Out[3]),  .P(P[3]),  .G(G[3]));
  cla4    CLA1  (.G(G[3:0]), .P(P[3:0]), .Cin(Cin), .Cout(cout[3:0]), .outP(outP[0]), .outG(outG[0]));	

	//Second Set of Adders and CLA for next 4 LSBs (ie bits [7:4])
	adder1b FOUR  (.A(A[4]),  .B(B[4]),  .Cin(top_cout[0]),.Sum(Out[4]),  .P(P[4]),  .G(G[4]));
	adder1b FIVE  (.A(A[5]),  .B(B[5]),  .Cin(cout[4]),    .Sum(Out[5]),  .P(P[5]),  .G(G[5]));
	adder1b SIX   (.A(A[6]),  .B(B[6]),  .Cin(cout[5]),    .Sum(Out[6]),  .P(P[6]),  .G(G[6]));
	adder1b SEVEN (.A(A[7]),  .B(B[7]),  .Cin(cout[6]),    .Sum(Out[7]),  .P(P[7]),  .G(G[7]));
  cla4    CLA2  (.G(G[7:4]), .P(P[7:4]), .Cin(cout[3]),.Cout(cout[7:4]), .outP(outP[1]), .outG(outG[1]));	
	
	//Third Set of Adders and CLA for next 4 LSBs (ie bits [11:8])
	adder1b EIGHT (.A(A[8]),  .B(B[8]),  .Cin(top_cout[1]),.Sum(Out[8]),  .P(P[8]),  .G(G[8]));
	adder1b NINE  (.A(A[9]),  .B(B[9]),  .Cin(cout[8]),    .Sum(Out[9]),  .P(P[9]),  .G(G[9]));
	adder1b TEN   (.A(A[10]), .B(B[10]), .Cin(cout[9]),    .Sum(Out[10]), .P(P[10]), .G(G[10]));
	adder1b ELEVE (.A(A[11]), .B(B[11]), .Cin(cout[10]),   .Sum(Out[11]), .P(P[11]), .G(G[11]));
  cla4    CLA3  (.G(G[11:8]), .P(P[11:8]), .Cin(cout[7]), .Cout(cout[11:8]), .outP(outP[2]), .outG(outG[2]));	
	
	//Final Set of Adders and CLA for 4 MSBs (ie bits [15:12])
	adder1b TWELV (.A(A[12]), .B(B[12]), .Cin(top_cout[2]),.Sum(Out[12]), .P(P[12]), .G(G[12]));
	adder1b THIRT (.A(A[13]), .B(B[13]), .Cin(cout[12]),   .Sum(Out[13]), .P(P[13]), .G(G[13]));
	adder1b FOURT (.A(A[14]), .B(B[14]), .Cin(cout[13]),   .Sum(Out[14]), .P(P[14]), .G(G[14]));
	adder1b FIFTE (.A(A[15]), .B(B[15]), .Cin(cout[14]),   .Sum(Out[15]), .P(P[15]), .G(G[15]));
  cla4    CLA4  (.G(G[15:12]), .P(P[15:12]), .Cin(cout[11]), .Cout(cout[15:12]), .outP(outP[3]), .outG(outG[3]));	

	//Top level CLA working with Generate and Propagates from inner layers
	cla4 	  CLATOP(.G(outG[3:0]), .P(outP[3:0]), .Cin(Cin), .Cout(top_cout[3:0]), .outP(top_outP), .outG(top_outG));

	//Overflow logic
	assign signed_overflow = top_cout[3] ^ cout[14];
	mux2_1 OFL (.InB(signed_overflow), .InA(top_cout[3]), .S(sign), .Out(Ofl ));			

	//top_cout[3] needs to be used with overflow...
	//probably need to include sign somehow...
	//detect 0...
	//
endmodule
