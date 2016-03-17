module instr_decode(instruction, writeData, RegWrite, RegDst, clk, rst, pc,
                    jumpAddr, read1data, read2data, immediate, err, five_bit_imm,
                    ZeroExtend);

  input [10:0] instruction; // Used for read1 & read2 regs, write reg, branch
  input RegWrite;           // Write to register or not
  input RegDst;             // Write register MUX control signal
  input [15:0] writeData;   // From write_back stage
  input clk, rst;
  input [4:0] pc;           //top bits from pc
  input five_bit_imm;
  input ZeroExtend;

  output err;
  output [15:0] jumpAddr;   // Some sort of jump logic
  output [15:0] read1data;
  output [15:0] read2data;
  output [15:0] immediate;

  wire [15:0] imm1, imm2, temp_immediate, zero_imm;
  wire [2:0] write_reg;
  wire [2:0] read1reg, read2reg, write1_reg;
  wire [12:0] temp_jump;    //Before being combined with pc
  wire [1:0] sll;           //sll op code
  wire toShift;             //Always want to shift

  assign read2reg = instruction[7:5];
  assign read1reg = instruction[10:8];
  assign write1_reg = instruction[4:2];
  assign sll = 2'b01;
  assign toShift = 1'b1;

  //Decide which register is to be used as the write_reg
  assign write_reg = (RegDst == 1'b0) ? read1reg : write1_reg;
  
  //Instantiate the register file
  rf REGS(//Output
          .read1data(read1data), .read2data(read2data), .err(err),
          //Input
          .clk(clk), .rst(rst), .read1regsel(read2reg), .read2regsel(read1reg), 
          .writeregsel(write_reg), .writedata(writeData), .write(RegWrite));
  
  //JUMP logic
  //shift jump digits left 2
//  shifter_two_bit SHIFT(.In(instruction), .Cnt(toShift), .Op(sll), .Out(temp_jump));
  
  //Combine with top bits from PC to make it a 16bit value
  assign jumpAddr = {pc,instruction};

  //Sign extend Immediate value
  sign_extend8bit EXTEND (.in(instruction[7:0]), .out(imm1));
  sign_extend5bit EXT5   (.in(instruction[4:0]), .out(imm2));
  zero_extend8bit ZEXTEND(.in(instruction[7:0]), .out(zero_imm));

  mux2_1_16bit  IMM(.InB(imm2), .InA(imm1), .S(five_bit_imm), .Out(temp_immediate));
  mux2_1_16bit ZIMM(.InB(zero_imm), .InA(temp_immediate), .S(ZeroExtend), .Out(immediate));

endmodule
