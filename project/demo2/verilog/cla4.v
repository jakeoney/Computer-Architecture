module cla4(G, P, Cin, Cout, outP, outG);

  input [3:0] G, P;
  input Cin;
  output [3:0] Cout;
  output outP, outG;

  //Carry Logic
  assign Cout[0] = G[0] | (P[0] & Cin);
  assign Cout[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
  assign Cout[2] = G[2] | (G[1] & P[2]) | (G[0] & P[1] & P[2]) | (Cin & P[0] & P[1] & P[2]);  
  assign Cout[3] = G[3] | (G[2] & P[3]) | (G[1] & P[3] & P[2]) | (G[0] & P[3] & P[2] & P[1] & P[0]) | (P[3] & P[2] & P[1] & P[0] & Cin); 
  
  assign outP = P[3] & P[2] & P[1] & P[0];
  assign outG = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);

endmodule
