module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
   
	input [15:0] A;
  input [15:0] B;
  input Cin;
  input [2:0] Op;
  input invA;
  input invB;
  input sign;
  
	output [15:0] Out;
  output Ofl;
  output Z;

	wire [3:0] cout, G, P;

	adder4b FIRST (.A(A[3:0]),  .B(B[3:0]),  .Cin(Cin),     .S(Sum[3:0]),  .Prop(P[0]), .Gen(G[0]));
	adder4b SECOND(.A(A[7:4]),  .B(B[7:4]),  .Cin(cout[0]), .S(Sum[7:4]),  .Prop(P[1]), .Gen(G[1]));
	adder4b THIRD (.A(A[11:8]), .B(B[11:8]), .Cin(cout[1]), .S(Sum[11:8]), .Prop(P[2]), .Gen(G[2]));
	adder4b LAST  (.A([15:12]), .B(B[15:4]), .Cin(cout[2]), .S(Sum[15:12]),.Prop(P[3]), .Gen(G[3]));

	cla CLA(.G(G[3:0]), .P(P[3:0]), .Cin(Cin), .Cout(cout[3:0]));

	//cout[3] needs to be used with overflow...
	//probably need to include sign somehow...
	//detect 0...
	//
	//I think I want todeal with invA and invB at the layer above
endmodule
