module data_mem(zero, Branch, branchAddr, pc, MemWrite, MemRead, ALU_result, writedata, clk, rst, halt,
           branch_or_pc, readData, ltz, branch_op);

  input zero;             //Used for branch logic
  input Branch;           //From control: if branch
  input [15:0] branchAddr;//Branch address
  input [15:0] pc;        //PC
  input MemWrite;         //Write to memory or not. from control
  input [15:0] ALU_result;//ALU unit result
  input [15:0] writedata; //From instruction decode unit
  input MemRead;          //Read from Mem or not. From control
  input clk, rst;
  input halt;
  input ltz;
  input [1:0] branch_op;

  output [15:0] branch_or_pc;//Result from MUX
  output [15:0] readData;    //From Memory unit

  wire nZero;
  wire enable;
  wire isThereABranch, toBranch;
  wire lessThan_or_greatOrEqual, equalZ_or_notEqualZ;
  wire gez; //greater or equal to zero

  assign nZero = ~zero;
  assign enable = (~halt) & MemRead;
  assign gez = ~ltz; 
  //JUMP logic
  //Will want to do some sort of jump logic in here...
  
  //BRANCH logic
  mux2_1 LOW1(.InB(nZero), .InA(zero), .S(branch_op[0]), .Out(equalZ_or_notEqualZ));
  mux2_1 LOW2(.InB(gez), .InA(ltz), .S(branch_op[0]), .Out(lessThan_or_greatOrEqual));
  mux2_1 HIGH(.InB(lessThan_or_greatOrEqual), .InA(equalZ_or_notEqualZ), .S(branch_op[1]), .Out(isThereABranch));
  
  assign toBranch = Branch & isThereABranch;
  mux2_1_16bit BMUX(.InB(branchAddr), .InA(pc), .S(toBranch), .Out(branch_or_pc));

  //Data Memory
  memory2c DMEM(.data_out(readData), .data_in(writedata), .addr(ALU_result), 
                .enable(enable), .wr(MemWrite), .createdump(halt), .clk(clk), .rst(rst));  

endmodule
