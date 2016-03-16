module inverter(In, sign, Out);

	input [15:0] In;
	input sign;
	output [15:0] Out;

	wire sign, Ofl, Z;

	//flip all the bits
	assign Out[15] = ~In[15];	
	assign Out[14] = ~In[14];	
	assign Out[13] = ~In[13];	
	assign Out[12] = ~In[12];	
	assign Out[11] = ~In[11];	
	assign Out[10] = ~In[10];	
	assign Out[9]  = ~In[9];	
	assign Out[8]  = ~In[8];	
	assign Out[7]  = ~In[7];	
	assign Out[6]  = ~In[6];	
	assign Out[5]  = ~In[5];	
	assign Out[4]  = ~In[4];	
	assign Out[3]  = ~In[3];	
	assign Out[2]  = ~In[2];	
	assign Out[1]  = ~In[1];	
	assign Out[0]  = ~In[0];

endmodule
