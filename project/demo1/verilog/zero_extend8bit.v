module zero_extend8bit(in, out);
  
  input [7:0] in;
  output [15:0] out;
  
  wire zero;
  assign zero = 1'b0;

  assign out = {{8{zero}},in};

endmodule
