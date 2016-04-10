module instr_fetch(pc, clk, rst, branch_or_jump, toJump, toBranch, instruction, next_pc, instr_valid, err);

  input [15:0] pc, branch_or_jump; 
  input clk, rst;
  input toBranch, toJump;

  output [15:0] next_pc;
  output [15:0] instruction;
  output instr_valid;
  output err;

  wire [15:0] next; //next isn't actually the next pc, it is the intermediate value before add 2 
  wire cin;
  wire [15:0] increment_pc;
  wire sign;
  wire dump, wr, enable;
  wire [15:0] data_in;
  wire [15:0] jump_or_pc_or_branch;

  assign increment_pc = 16'b0000_0000_0000_0010;
  assign sign = 1'b0; //I don't think it is signed
  assign cin = 1'b0;  //No cin
  assign data_in = 16'b0000_0000_0000_0000;
  assign dump = 1'b0;
  assign wr = 1'b0;
  assign enable = ~rst;  //Might not want to always have this enabled

  assign instr_valid = 1'b1;
  
  mux2_1_16bit NEXTPC (.InB(branch_or_jump), .InA(pc), .S((toJump | toBranch)), .Out(jump_or_pc_or_branch));

  dff PC [15:0] (.q(next),  .d(jump_or_pc_or_branch),  .clk(clk), .rst(rst));

  //add 2 to the get the next pc
  adder16 ADD(.A(next), .B(increment_pc), .Cin(cin), .sign(sign), .Out(next_pc), .Ofl(err));

  //Get next instruction from instruction memory
  memory2c IMEM(.data_out(instruction), .data_in(data_in), .addr(next), .enable(enable), .wr(wr), .createdump(dump), .clk(clk), .rst(rst)); 

endmodule
