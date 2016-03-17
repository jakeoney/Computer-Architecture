module zero_extend5bit(in, out);
  
  input [4:0] in;
  output [15:0] out;
  
  wire zero;
  assign zero = 1'b0;

  assign out = {{11{zero}},in};

endmodule
