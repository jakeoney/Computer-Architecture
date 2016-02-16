module quadmux4_1_bench;
   // No inputs and outputs : testbenchs just a wrapper.

   // reg/wire definitions, we'll use these to drive our inputs and capture our outputs
	reg [3:0] InA;
	reg [3:0] InB;
	reg [3:0] InC;
	reg [3:0] InD;
	reg [1:0] S;
	wire [3:0] Out;
   
   // Module instantiation :
	quadmux4_1 DUT (.InA(InA), .InB(InB),.InC(InC),.InD(InD), .S(S), .Out(Out));

   // Input drivers :
   //  Check every combination of S

   // Whatever you put within an initial block will be executed
   // when simulation starts
	initial 
	  begin
	     // Lets initialize all inputs (We dont want any 'Z's)
	     InA = 4'b1010;
	     InB = 4'b0101;
	     InC = 4'b1100;
	     InD = 4'b0011;
	     S = 2'b11;
         
         // #10 means wait for a delay of 10 ticks.
         // By doing this we hold every singal for some time, which allows
         // for the combinational logical delay and for the output to be computed
         
	     #10    InD = 4'b0011;    
	     #10    S = 2'b01;		  
	     #10    InB = 4'b0111;
	     #10    S = 2'b00;       
  	     #10    InA = 4'b1111;
 	     #10    S = 2'b10;       
  	     #10    InC = 4'b1110;
 	     #10    $finish;
	  end
   // The test is not complete (we didnt check every combination of all inputs, InA for example. But we can be pretty confident if this much works.
   

   // Output monitors
	always@(S, InA, InB, InC, InD, Out)
	  // Sensitivity list ^^^ tells Modelsim what this always block is "sensitive" to.
	  // Try to figure out what happens if you didnt include lets say InC...
      // Whenever any of these signals change, this block will execute
		begin
			#0; //Advance to end of simulation time-step. (Let 'Out' change before $display)
			case (S)
			  // This is a behavior description of what the mux is supposed to do...
			  // For every combination of S : 
				2'b00 : $display("Expecting InA : %b, Got %b", InA, Out );
				2'b01 :	$display("Expecting InB : %b, Got %b", InB, Out );	
				2'b10 :	$display("Expecting InC : %b, Got %b", InC, Out );	
				2'b11 :	$display("Expecting InD : %b, Got %b", InD, Out );	
			endcase
		end
		
endmodule // End of module : tb_quadmux4to1
