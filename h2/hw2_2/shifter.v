module shifter(In, Cnt, Op, Out);

   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

	wire [15:0] eight_to_four;
	wire [15:0] four_to_two;
	wire [15:0] two_to_one;

	shifter_eight_bit s3(.Out(eight_to_four),.In(In),           .Cnt(Cnt[3]), .Op(Op));
	shifter_four_bit s2 (.Out(four_to_two),  .In(eight_to_four),.Cnt(Cnt[2]), .Op(Op));
	shifter_two_bit s1  (.Out(two_to_one),   .In(four_to_two),  .Cnt(Cnt[1]), .Op(Op));
  shifter_one_bit s0  (.Out(Out),          .In(two_to_one),   .Cnt(Cnt[0]), .Op(Op));
   
endmodule // shifter_hier
