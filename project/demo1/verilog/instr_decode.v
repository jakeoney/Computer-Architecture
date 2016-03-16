module instr_decode(instruction, writeData, RegWrite, RegDst, clk, rst, pc,
                    jumpAddr, read1data, read2data, immediate, err);

  input [10:0] instruction; // Used for read1 & read2 regs, write reg, branch
  input RegWrite;           // Write to register or not
  input RegDst;             // Write register MUX control signal
  input [15:0] writeData;   // From write_back stage
  input clk, rst;
  input [4:0] pc;           //top bits from pc

  output err;
  output [15:0] jumpAddr;   // Some sort of jump logic
  output [15:0] read1data;
  output [15:0] read2data;
  output [15:0] immediate;

  wire [2:0] write_reg;
  wire [2:0] read1reg, read2reg, write1_reg;
  wire [12:0] temp_jump;    //Before being combined with pc
  wire [1:0] sll;           //sll op code
  wire toShift;             //Always want to shift

  assign read1reg = instruction[10:8];
  assign read2reg = instruction[7:5];
  assign write1_reg = instruction[4:2];
  assign sll = 2'b01;
  assign toShift = 1'b1;

  //Decide which register is to be used as the write_reg
  assign write_reg = (RegDst == 1'b0) ? read2reg : write1_reg;
  
  //Instantiate the register file
  rf_bypass REGS(//Output
                 .read1data(read1data), .read2data(read2data), .err(err),
                 //Input
                 .clk(clk), .rst(rst), .read1regsel(read1reg), .read2regsel(read2reg), 
                 .writeregsel(write_reg), .writedata(writeData), .write(RegWrite));
  
  //JUMP logic
  //shift jump digits left 2
//  shifter_two_bit SHIFT(.In(instruction), .Cnt(toShift), .Op(sll), .Out(temp_jump));
  
  //Combine with top bits from PC to make it a 16bit value
  assign jumpAddr = {pc,instruction};

  //Sign extend Immediate value
  sign_extend5bit EXTEND(.in(instruction[4:0]), .out(immediate));

endmodule
