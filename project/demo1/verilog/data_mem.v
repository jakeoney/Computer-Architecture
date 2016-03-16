module data_mem(zero, Branch, branchAddr, pc, MemWrite, MemRead, ALU_result, writedata, clk, rst,
           branch_or_pc, readData);

  input zero;             //Used for branch logic
  input Branch;           //From control: if branch
  input [15:0] branchAddr;//Branch address
  input [15:0] pc;        //PC
  input MemWrite;         //Write to memory or not. from control
  input [15:0] ALU_result;//ALU unit result
  input [15:0] writedata; //From instruction decode unit
  input MemRead;          //Read from Mem or not. From control
  input clk, rst;

  output [15:0] branch_or_pc;//Result from MUX
  output [15:0] readData;    //From Memory unit

  //JUMP logic
  //Will want to do some sort of jump logic in here...
  
  //BRANCH logic
  //Need to do some stuff with zero...
  //branch ne, branch lt, branch gt, branch eq...
  mux2_1_16bit BMUX(.InB(branchAddr), .InA(pc), .S(Branch), .Out(branch_or_pc));

  //Data Memory
  memory2c DMEM(.data_out(readData), .data_in(writedata), .addr(ALU_result), 
                .enable(MemRead), .wr(MemWrite), .createdump(), .clk(clk), .rst(rst));  

endmodule
