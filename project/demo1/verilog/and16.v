module and16(A,B,Out);

	input [15:0] A;
	input [15:0] B;

	output [15:0] Out;
	
	assign Out[15] = A[15] & B[15];
	assign Out[14] = A[14] & B[14];
	assign Out[13] = A[13] & B[13];
	assign Out[12] = A[12] & B[12];
	assign Out[11] = A[11] & B[11];
	assign Out[10] = A[10] & B[10];
	assign Out[9]  = A[9]  & B[9];
	assign Out[8]  = A[8]  & B[8];
	assign Out[7]  = A[7]  & B[7];
	assign Out[6]  = A[6]  & B[6];
	assign Out[5]  = A[5]  & B[5];
	assign Out[4]  = A[4]  & B[4];
	assign Out[3]  = A[3]  & B[3];
	assign Out[2]  = A[2]  & B[2];
	assign Out[1]  = A[1]  & B[1];
	assign Out[0]  = A[0]  & B[0];

endmodule
