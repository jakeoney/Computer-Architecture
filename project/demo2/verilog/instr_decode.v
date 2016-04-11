module instr_decode(instruction, writeData, RegWrite, RegDst, clk, rst, pc,
                    jumpAddr, read1data, read2data, immediate, err, five_bit_imm,
                    ZeroExtend, MemWrite, write_reg, write_reg_in);

  input [15:0] instruction; // Used for read1 & read2 regs, write reg, branch
  input RegWrite;           // Write to register or not
  input RegDst;             // Write register MUX control signal
  input [15:0] writeData;   // From write_back stage
  input clk, rst;
  input [15:0] pc;           //top bits from pc
  input five_bit_imm;
  input ZeroExtend;
  input MemWrite;
  input [2:0] write_reg_in;

  output err;
  output [15:0] jumpAddr;   // Some sort of jump logic
  output [15:0] read1data;
  output [15:0] read2data;
  output [15:0] immediate;
  output [2:0] write_reg;

  wire [15:0] imm1, imm2, temp_immediate, zero_imm1, zero_imm2, temp_zero_imm;
  wire [2:0] write_reg_temp;
  wire [2:0] read1reg, read2reg, write1_reg;
  wire [1:0] sll;           //sll op code
  wire toShift;             //Always want to shift
  wire [15:0] read1data_temp, read2data_temp;
  wire [2:0] stuReg, write_regtemp, write_regtemp2;
  wire isSTU;
  wire jal, jalr, jal_or_jalr;
  wire [15:0]writeData1;

  assign read2reg = instruction[7:5];
  assign read1reg = instruction[10:8];
  assign write1_reg = instruction[4:2];
  assign sll = 2'b01;
  assign toShift = 1'b1;

  assign isSTU = instruction[15] & (~instruction[14]) & (~instruction[13]) & instruction[12] & instruction[11]; 
  assign stuReg = read1reg;

  assign jal = (~instruction[15]) & (~instruction[14]) & instruction[13] & instruction[12] & (~instruction[11]);
  assign jalr = (~instruction[15]) & (~instruction[14]) & instruction[13] & instruction[12] & (instruction[11]);
  assign jal_or_jalr = jal | jalr;
  //Decide which register is to be used as the write_reg
  assign write_reg_temp = (RegDst == 1'b0) ? read1reg : write1_reg;
  
  assign write_regtemp = (five_bit_imm) ? read2reg : write_reg_temp;

  assign write_regtemp2 = (isSTU) ? stuReg : write_regtemp;
  assign write_reg = (jal_or_jalr) ? 3'b111 : write_regtemp2; //write to r7
  assign writeData1 = (jal_or_jalr) ? pc : writeData;
  //Instantiate the register file
  rf_bypass REGS(//Output
          .read1data(read1data_temp), .read2data(read2data_temp), .err(err),
          //Input
          .clk(clk), .rst(rst), .read1regsel(read2reg), .read2regsel(read1reg), 
          .writeregsel(write_reg_in), .writedata(writeData1), .write(RegWrite));
  
  mux2_1_16bit MEM1(.InB(read2data_temp), .InA(read1data_temp), .S(MemWrite), .Out(read1data));
  mux2_1_16bit MEM2(.InB(read1data_temp), .InA(read2data_temp), .S(MemWrite), .Out(read2data));

  wire jr;
  wire [15:0] jumpAddr1, jumpAddr2;
  //Combine with top bits from PC to make it a 16bit value
  sign_extend11bit SJUMP(.in(instruction[10:0]), .out(jumpAddr1));
  sign_extend8bit SJUMP8(.in(instruction[7:0]), .out(jumpAddr2));
  
  assign jr = (~instruction[15]) & (~instruction[14]) & instruction[13] & (~instruction[12]) & instruction[11];
  mux2_1_16bit JADDR(.InB(jumpAddr2), .InA(jumpAddr1), .S(jr|jalr), .Out(jumpAddr));

  //Sign extend Immediate value
  sign_extend8bit EXT8 (.in(instruction[7:0]), .out(imm1));
  sign_extend5bit EXT5   (.in(instruction[4:0]), .out(imm2));
  zero_extend8bit Z8EXT(.in(instruction[7:0]), .out(zero_imm1));
  zero_extend5bit Z5EXT(.in(instruction[4:0]), .out(zero_imm2));

  mux2_1_16bit  IMM(.InB(imm2), .InA(imm1), .S(five_bit_imm), .Out(temp_immediate));
  mux2_1_16bit Z5IM(.InB(zero_imm2), .InA(zero_imm1), .S(five_bit_imm), .Out(temp_zero_imm));
  mux2_1_16bit ZIMM(.InB(temp_zero_imm), .InA(temp_immediate), .S(ZeroExtend), .Out(immediate));

endmodule
