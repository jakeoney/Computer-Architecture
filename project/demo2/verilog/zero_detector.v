module zero_detector(In, Z, ltz);

	input [15:0] In;
  output ltz; // less than zero
	output Z;

	assign Z = ~|In; 
  //assign Z = (In === 16'h0000) ? 1'b1 : 1'b0;
  assign ltz = (In[15] == 1) ? 1'b1 : 1'b0;

endmodule
