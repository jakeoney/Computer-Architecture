module execute(alu_op, ALUSrc, read1data, read2data, immediate, pc, invA, invB, cin, sign,
    passThroughA, passThroughB, instr_op, MemWrite, jump_in, jump_out,
    ALU_result, branch_result, zero, ltz, err,
    forwardA, forwardB, data_mem_from_mem_wb, ALU_result_from_ex_mem,
    read2out);

  input [1:0] forwardA, forwardB;
  input [15:0] data_mem_from_mem_wb, ALU_result_from_ex_mem;

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
  output [15:0] read2out;

  wire [15:0] alu_in1, alu_in2;
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
  wire [15:0] nRead1data, newRead1data;
  wire isRotateRight;
  wire [2:0] ror_or_alu_op;

  wire [15:0] nRead1, rotateVal;
  wire isRORI;
//////
  wire [15:0] wtf = 16'bzzzz_zzzz_zzzz_zzzz;//not sure how we got there
  wire [15:0] fwd_alu_in1, fwd_alu_in2;
  mux4_1 FWDA [15:0] (.InD(read2data), .InC(ALU_result_from_ex_mem), .InB(data_mem_from_mem_wb), .InA(read1data), .S(forwardB), .Out(fwd_alu_in1));
  mux4_1 FWDB [15:0] (.InD(read1data), .InC(ALU_result_from_ex_mem), .InB(data_mem_from_mem_wb), .InA(read2data), .S(forwardA), .Out(fwd_alu_in2));
//////  
  assign isRORI = ((~instr_op[0]) & instr_op[1] & instr_op[2] & (~instr_op[3]) & instr_op[4]);

  mux2_1_16bit RORI(.InB(immediate), .InA(fwd_alu_in1), .S(isRORI), .Out(rotateVal));
  inverter NREAD1(.In(rotateVal), .sign(1'b1), .Out(nRead1data));
  assign nRead1 = nRead1data + 1;
  //If Rotate right, flip all the bits of shifter value and add 1 
  assign isRotateRight = ((~alu_op[0]) & alu_op[1] & (~alu_op[2]));   // ROR or RORI
  assign ror_or_alu_op = (isRotateRight) ? 3'b000 : alu_op; //Perform a rotate left

  mux2_1_16bit ROTATERIGHT(.InB(nRead1), .InA(fwd_alu_in1), .S(isRotateRight), .Out(newRead1data));
  //END ROTATE RIGHT LOGIC

  assign isBTR = (instr_op[0] & (~instr_op[1]) & (~instr_op[2]) & instr_op[3] & instr_op[4]);
  assign btr_result = {fwd_alu_in2[0],fwd_alu_in2[1],fwd_alu_in2[2],fwd_alu_in2[3],fwd_alu_in2[4],fwd_alu_in2[5],fwd_alu_in2[6],
  fwd_alu_in2[7], fwd_alu_in2[8],fwd_alu_in2[9],fwd_alu_in2[10],fwd_alu_in2[11],fwd_alu_in2[12],
  fwd_alu_in2[13],fwd_alu_in2[14],fwd_alu_in2[15]}; 

  assign isSLBI = ((~instr_op[0]) & instr_op[1] & (~instr_op[2]) & (~instr_op[3]) & instr_op[4]);
  assign shiftBits_SLBI = fwd_alu_in2 << 8;

  mux4_1_16bit ALU_IN1(.InD(fwd_alu_in2), .InC(shiftBits_SLBI), .InB(fwd_alu_in1), .InA(fwd_alu_in2), .S({isSLBI, MemWrite}), .Out(alu_in1));

  wire [15:0] alu_in2_temp;
  //First, MUX read1data and immediate
  mux4_1_16bit ALU_IN2(.InD(immediate), .InC(immediate), .InB(fwd_alu_in2), .InA(newRead1data), .S({ALUSrc,MemWrite}), .Out(alu_in2_temp));

  //If branch, make zero be the input for alu_in2
  wire isBranch;
  assign isBranch = ((~instr_op[4]) & instr_op[3] & instr_op[2]);
  mux2_1_16bit ALU2_BRANCH (.InB(16'h0000), .InA(alu_in2_temp), .S(isBranch), .Out(alu_in2));

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

  assign isSetOP = ((instr_op[2] & instr_op[3]) & instr_op[4]);
  assign set_condition_result = (seq | slt | sle | sco) ? 16'h0001 : 16'h0000;

  mux2_1_16bit SETRESULT(.InB(set_condition_result), .InA(temp_result), .S(isSetOP), .Out(ALU_result_temp));
  mux2_1_16bit BTRresult(.InB(btr_result), .InA(ALU_result_temp), .S(isBTR), .Out(ALU_result));


 
    assign read2out = alu_in2;
 
 
 
 
 


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
  adder16 JUMP(.A(a_in), .B(jump_in), .Cin(1'b0), .sign(1'b1), .Out(jump_out), .Ofl(jump_ofl));

  //This is the only err conditions we can encounter here?
  assign err = (branch_ofl | alu_ofl) & (~(passThroughA | passThroughB)); //add jump_ofl here

endmodule
