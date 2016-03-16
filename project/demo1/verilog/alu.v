module alu(A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
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

  wire [15:0] a_inv, b_inv, muxed_A, muxed_B;
  wire [15:0] add_out, or_out, xor_out, and_out, logical_out, shift_out;
  wire add_Ofl, Ofl_temp;

  //Perform the inverstion of A and B
  inverter A_INV(.In(A[15:0]), .sign(sign), .Out(a_inv[15:0]));
  inverter B_INV(.In(B[15:0]), .sign(sign), .Out(b_inv[15:0]));

  //Choose whether the inverted or noninverted signal is needed
  mux2_1_16bit A_OR_AINV (.InB(a_inv[15:0]), .InA(A[15:0]), .S(invA), .Out(muxed_A[15:0]));
  mux2_1_16bit B_OR_BINV (.InB(b_inv[15:0]), .InA(B[15:0]), .S(invB), .Out(muxed_B[15:0]));

  //Adder and overflow logic
  adder16 A0(.Out(add_out[15:0]), .Ofl(add_Ofl),
    .A(muxed_A[15:0]), .B(muxed_B[15:0]), .Cin(Cin), .sign(sign));
  
  //Logical Operators
  or16          OR0   (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(or_out[15:0]));
  xor16         XOR0  (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(xor_out[15:0]));
  and16         AND0  (.A(muxed_A[15:0]), .B(muxed_B[15:0]), .Out(and_out[15:0]));

  //Shifter/Rotator
  shifter SHIFT0(.In(muxed_A[15:0]), .Cnt(muxed_B[3:0]), .Op(Op[1:0]), .Out(shift_out[15:0]));

  //Mux all the Outputs to get the result that we actually want
  mux4_1_16bit LOGICAL_MUX (.InD(and_out[15:0]), .InC(xor_out[15:0]), .InB(or_out[15:0]), .InA(add_out[15:0]), .S(Op[1:0]), .Out(logical_out[15:0]));
  mux2_1_16bit SHIFT_OR_ALU(.InB(logical_out[15:0]), .InA(shift_out[15:0]), .S(Op[2]), .Out(Out[15:0])); 

  //Mux the overflow flag... It should only be active for opcode 100
  mux2_1 OFLMUX1(.InB(add_Ofl), .InA(1'b0), .S(Op[2]), .Out(Ofl_temp));
  mux4_1 OFLMUX2(.InD(1'b0), .InC(1'b0), .InB(1'b0), .InA(Ofl_temp), .S(Op[1:0]), .Out(Ofl));

  //zero detector of some sort...
  zero_detector ZERO(Out[15:0], Z);
  
endmodule
