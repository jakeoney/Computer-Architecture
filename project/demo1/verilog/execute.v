module execute(alu_op, ALUSrc, read1data, read2data, immediate, pc, invA, invB, cin, sign,
              passThroughA, passThroughB,
              ALU_result, branch_result, zero, ltz, err);

  input [2:0] alu_op;   //OP code
  input ALUSrc;         //ALUSrc MUX control signal (read2data or immediate)
  input [15:0] read1data;
  input [15:0] read2data;
  input [15:0] immediate;
  input [15:0] pc;       //Use in adder for branch result
  input invA, invB;      //From Control. Whether to invert A or B;
  input cin;
  input sign;
  input passThroughA;
  input passThroughB;
  
  output [15:0] ALU_result; //From main ALU unit
  output [15:0] branch_result; //From branch calculation alu unit
  output zero;
  output err;
  output ltz;

  wire [15:0] alu_in2;
//  wire [15:0] imm_shift;  //Immediate shifted left 2 bits
  wire [1:0] sll;         //Shift Left logical op code
  wire toShift;           //Whether or not to shift
  wire cin_for_branch;
  wire sign_branch;
  wire branch_ofl;        //Not sure we can have overflow here..?
  wire alu_ofl;
  wire [15:0] result;

  assign sll = 2'b01;
  assign toShift = 1'b1;
  assign cin_for_branch = 1'b0; //Shouldn't have to have a cin value. Already shifted
  assign sign_branch = 1'b0; //I don't think it is ever signed...


  //First, MUX read2data and immediate
  mux2_1_16bit ALU_IN2(.InB(immediate), .InA(read1data), .S(ALUSrc), .Out(alu_in2));

  //Instanitate the ALU
  alu ALU(//Inputs
          .A(read2data), .B(alu_in2), .Cin(cin), .Op(alu_op), .invA(invA), .invB(invB), .sign(sign), 
          //Outputs
          .Out(result), .Ofl(alu_ofl), .Z(zero), .ltz(ltz));

  mux4_1_16bit RESULT(.InD(result), .InC(alu_in2), .InB(read1data), .InA(result), .S({passThroughB, passThroughA}), .Out(ALU_result));

  //Branch Calculation
  //shift immediate value left 
  //shifter_two_bit SHIFT(.In(immediate), .Cnt(toShift), .Op(sll), .Out(imm_shift));

  //add branch and pc
  adder16 ADD(//Inputs
              .A(pc), .B(immediate), .Cin(cin_for_branch), .sign(sign_branch), 
              //Outputs
              .Out(branch_result), .Ofl(branch_ofl));

  //This is the only err conditions we can encounter here?
  assign err = (branch_ofl | alu_ofl) & (~(passThroughA | passThroughB));

endmodule
