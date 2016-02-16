module fulladder16(A, B, SUM, CO);
	input [15:0] A;
	input [15:0] B;
	output [15:0] SUM;
	output CO;

	wire cin1, cin2, cin3;
	wire cin;
	
	assign cin = 0;

	fulladder4 ONE(.A(A[3:0]), .B(B[3:0]), .CI(cin), .SUM(SUM[3:0]), .CO(cin1));	
	fulladder4 TWO(.A(A[7:4]), .B(B[7:4]), .CI(cin1), .SUM(SUM[7:4]), .CO(cin2));	
	fulladder4 THREE(.A(A[11:8]), .B(B[11:8]), .CI(cin2), .SUM(SUM[11:8]), .CO(cin3));	
	fulladder4 FOUR(.A(A[15:12]), .B(B[15:12]), .CI(cin3), .SUM(SUM[15:12]), .CO(CO));	

endmodule
