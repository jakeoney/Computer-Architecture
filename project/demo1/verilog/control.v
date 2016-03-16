module control(instruction_op, 
               RegDst, Jump, Branch, MemRead, MemToReg, ALU_op, MemWrite, ALUSrc, RegWrite, err);

  input [4:0] instruction_op;    //OP Code from instruction fetch

  output reg err;
  output reg RegDst;          // Instruction Decode -> Write register MUX control
  output reg Jump;            // To jump or not to jump MUX control
  output reg Branch;          // To branch or not to branch MUX control
  output reg MemRead;         // To read from data memory or not MUX control
  output reg MemToReg;        // Data memory or ALU result MUX control
  output [4:0] ALU_op;    // ALU OP code
  output reg MemWrite;        // To write to memory or not MUX control
  output reg ALUSrc;         // Register file data2 or immediate MUX control
  output reg RegWrite;        // To write to register file or not

  assign ALU_op = instruction_op;

  always @(instruction_op)
  begin
    /*Defaults*/
    RegDst   = 1'b0;
    Jump     = 1'b0;
    Branch   = 1'b0;
    MemRead  = 1'b0;
    MemToReg = 1'b0;
    MemWrite = 1'b0;
    ALUSrc   = 1'b0;
    RegWrite = 1'b0;
    casex(instruction_op)
      5'b0_0000: //halt
        begin

        end
      5'b0_0001: //nop
        begin

        end
      5'b0_1000: //ADDI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b0_1001: //SUBI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b0_1010: //XORI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b0_1011: //ANDNI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0100: //ROLI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0101: //SLLI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0110: //RORI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0111: //SRLI
        begin
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0000: //ST
        begin
          ALUSrc = 1'b1;
          MemWrite = 1'b1;
          MemToReg = 1'b1;
        end
      5'b1_0001: //LD
        begin
          MemToReg = 1'b1;
          ALUSrc = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_0011: //STU
        begin
          RegWrite = 1'b1;
          MemToReg = 1'b1;
          MemWrite = 1'b1;
          ALUSrc = 1'b1;
        end
      5'b1_1001: //BTR
        begin
          RegWrite = 1'b1;
          RegDst = 1'b1;
        end
      5'b1_1011: //ADD, SUB, XOR, ANDN
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_1010: // ROL, SLL, ROR, SRL 
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_1100: //SEQ
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_1101: //SLT
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_1110: //SLE
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b1_1111: //SCO
        begin
          RegDst = 1'b1;
          RegWrite = 1'b1;
        end
      5'b0_1100: //BEQZ
        begin
          ALUSrc = 1'b1;
          Branch = 1'b1;
        end
      5'b0_1101: //BNEZ
        begin
          ALUSrc = 1'b1;
          Branch = 1'b1;
        end
      5'b0_1110: //BLTZ
        begin
          ALUSrc = 1'b1;
          Branch = 1'b1;
        end
      5'b0_1111: //BGEZ
        begin
          ALUSrc = 1'b1;
          Branch = 1'b1;
        end
      5'b1_1000: //LBI
        begin
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
        end
      5'b1_0010: //SLBI
        begin
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
        end
      5'b0_0100: //J
        begin
          Jump = 1'b1;
        end
      5'b0_0101: //JR
        begin
          Jump = 1'b1;
          ALUSrc = 1'b1;
        end
      5'b0_0110: //JAL
        begin
          Jump = 1'b1;
          RegWrite = 1'b1;
        end
      5'b0_0111: //JALR
        begin
          Jump = 1'b1;
          RegWrite = 1'b1;
          ALUSrc = 1'b1;
        end
      5'b0_0010: //siic RS
        begin

        end
      5'b0_0011: //NOP / RTI
        begin

        end
      default:
        begin
          err = 1'b1; //should never get here. Unknown op code
        end
    endcase
  end
endmodule
