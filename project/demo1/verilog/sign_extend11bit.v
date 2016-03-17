//Still need to verify this works
module sign_extend11bit(in, out);
  
  input [10:0] in;
  output [15:0] out;

  assign out = {{5{in[10]}},in};

endmodule
