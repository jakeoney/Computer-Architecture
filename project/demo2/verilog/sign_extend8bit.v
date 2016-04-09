//Still need to verify this works
module sign_extend8bit(in, out);
  
  input [7:0] in;
  output [15:0] out;

  assign out = {{8{in[7]}},in};

endmodule
