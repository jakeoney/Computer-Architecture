module adder4b(A, B, Cin, S, Prop, Gen);

	input [3:0] A, B;
	input Cin;

	output [3:0] S;
	output Prop, Gen;
	
	//Generate, Propagate, Carry
	wire [3:0] G, P, C;

	//Generate and Propagate logic
	assign G = A & B;
	assign P = A ^ B;

	assign Prop = P[3] & P[2] & P[1] & P[0];
	assign Gen  = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[3] & P[2] & P[1]);

	//Carry Logic
	assign C[0] = Cin;
	assign C[1] = G[0] | (P[0] & C[0]);
	assign C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0]);
	assign C[3] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (C[0] & P[0] & P[1] & P[2]);  

	//Sum Logic
	assign S = P ^ C;

endmodule
