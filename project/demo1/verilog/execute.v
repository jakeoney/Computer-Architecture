module execute(alu_op, ALUSrc, read1data, read2data, immediate, pc, invA, invB, cin, sign,
              passThroughA, passThroughB, instr_op, MemWrite, jump_in, jump_out,
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
  input [4:0] instr_op;
  input MemWrite;
  input [15:0] jump_in;
  
  output [15:0] jump_out;
  output [15:0] ALU_result; //From main ALU unit
  output [15:0] branch_result; //From branch calculation alu unit
  output zero;
  output err;
  output ltz;

  wire [15:0] alu_in1, alu_in2;
//  wire [15:0] imm_shift;  //Immediate shifted left 2 bits
  wire [1:0] sll;         //Shift Left logical op code
  wire toShift;           //Whether or not to shift
  wire cin_for_branch;
  wire sign_branch;
  wire branch_ofl;        //Not sure we can have overflow here..?
  wire alu_ofl, jump_ofl;
  wire [15:0] result, temp_result;
  wire isSetOP;           //Value is 1 if we have SEQ, SLT, SLE, SCO
  wire seq, slt, sle, sco;
  wire [15:0] set_condition_result; 

  assign sll = 2'b01;
  assign toShift = 1'b1;
  assign cin_for_branch = 1'b0; //Shouldn't have to have a cin value. Already shifted
  assign sign_branch = 1'b0; //I don't think it is ever signed...

  wire isSLBI;
  wire [15:0] shiftBits_SLBI;

  wire isBTR;
  wire [15:0] btr_result, ALU_result_temp;
  
  //ROTATE RIGHT LOGIC//
  wire [15:0] nRead1data, newRead1data, nImmediate, newImmediate;
  wire isRotateRight;
  wire [2:0] ror_or_alu_op;

  assign nRead1data = (~read1data) + 1;
  assign nImmediate = (~immediate) + 1;
  //If Rotate right, flip all the bits of shifter value and add 1 
  assign isRotateRight = ((~alu_op[0]) & alu_op[1] & (~alu_op[2]));   // ROR or RORI
  assign ror_or_alu_op = (isRotateRight) ? 3'b000 : alu_op; //Perform a rotate left

  mux2_1_16bit ROTATERIGHT(.InB(nRead1data), .InA(read1data), .S(isRotateRight), .Out(newRead1data));
  mux2_1_16bit ROTATERIGHTIMM(.InB(nImmediate), .InA(immediate), .S(isRotateRight), .Out(newImmediate));
   
  //END ROTATE RIGHT LOGIC

  assign isBTR = (instr_op[0] & (~instr_op[1]) & (~instr_op[2]) & instr_op[3] & instr_op[4]);
  assign btr_result = {read2data[0],read2data[1],read2data[2],read2data[3],read2data[4],read2data[5],read2data[6],
                       read2data[7], read2data[8],read2data[9],read2data[10],read2data[11],read2data[12],
                       read2data[13],read2data[14],read2data[15]}; 

  assign isSLBI = ((~instr_op[0]) & instr_op[1] & (~instr_op[2]) & (~instr_op[3]) & instr_op[4]);
  assign shiftBits_SLBI = read2data << 8;

  mux4_1_16bit ALU_IN1(.InD(read2data), .InC(shiftBits_SLBI), .InB(read1data), .InA(read2data), .S({isSLBI, MemWrite}), .Out(alu_in1));

  //First, MUX read1data and immediate
  mux4_1_16bit ALU_IN2(.InD(newImmediate), .InC(newImmediate), .InB(read2data), .InA(newRead1data), .S({ALUSrc,MemWrite}), .Out(alu_in2));

  //Instanitate the ALU
  alu ALU(//Inputs
          .A(alu_in1), .B(alu_in2), .Cin(cin), .Op(ror_or_alu_op), .invA(invA), .invB(invB), .sign(sign), 
          //Outputs
          .Out(result), .Ofl(alu_ofl), .Z(zero), .ltz(ltz));

  //This mux is used to just "pass through A or B if no ALU operation is to be
  //performed
  mux4_1_16bit RESULT(.InD(result), .InC(alu_in2), .InB(read1data), .InA(result), .S({passThroughB, passThroughA}), .Out(temp_result));

  //if opcode == SEQ & Zero flag -> alu_result = 1
  //if opcode == SLT & ltz flag -> alu_result = 1
  //if opcode == SLE & (ltz | Zero) -> alu_result = 1
  //if opcode == SCO & ofl -> alu_result = 1
  assign seq = ((~instr_op[1]) & (~instr_op[0])) & zero;
  assign slt = ((~instr_op[1]) & instr_op[0]) & ltz;
  assign sle = (instr_op[1] & (~instr_op[0])) & (zero | ltz);
  assign sco = (instr_op[1] & instr_op[0]) & alu_ofl;

  assign isSetOP = (instr_op[2] & instr_op[3] & instr_op[4]);
  assign set_condition_result = (seq | slt | sle | sco) ? 16'h0001 : 16'h0000;
  
  mux2_1_16bit SETRESULT(.InB(set_condition_result), .InA(temp_result), .S(isSetOP), .Out(ALU_result_temp));
  mux2_1_16bit BTRresult(.InB(btr_result), .InA(ALU_result_temp), .S(isBTR), .Out(ALU_result));
  //Branch Calculation
  //shift immediate value left 
  //shifter_two_bit SHIFT(.In(immediate), .Cnt(toShift), .Op(sll), .Out(imm_shift));

  //add branch and pc
  adder16 ADD(//Inputs
              .A(pc), .B(immediate), .Cin(cin_for_branch), .sign(sign_branch), 
              //Outputs
              .Out(branch_result), .Ofl(branch_ofl));
  
  wire [15:0] a_in;
  wire jalr, jr, any_jump;
  assign jalr = (~instr_op[4]) & (~instr_op[3]) & instr_op[2] & instr_op[1] & instr_op[0];
  assign jr = (~instr_op[4]) & (~instr_op[3]) & instr_op[2] & (~instr_op[1]) & (instr_op[0]);
  assign any_jump = jalr | jr;
  mux2_1_16bit AIN(.InB(read2data), .InA(pc), .S(jr|jalr), .Out(a_in));
//  mux2_1_16bit AIN(.InB(), .InA(jump_in), .S(jr), .Out());
  adder16 JUMP(.A(a_in), .B(jump_in), .Cin(1'b0), .sign(1'b1), .Out(jump_out), .Ofl(jump_ofl));

  //This is the only err conditions we can encounter here?
  assign err = (branch_ofl | alu_ofl) & (~(passThroughA | passThroughB)); //add jump_ofl here

endmodule
