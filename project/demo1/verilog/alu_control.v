module alu_control(ALU_op, ALU_funct, invA, invB, sign, op_to_alu, cin, passA, passB);

  input [4:0] ALU_op;
  input [1:0] ALU_funct;

  output reg invA;
  output reg invB;
  output reg sign;
  output reg [2:0] op_to_alu; 
  output reg cin;
  output reg passA, passB;

  always @(*)
  begin
    /*Defaults*/
    invA = 1'b0;
    invB = 1'b0;
    sign = 1'b0;
    op_to_alu = 3'b000;
    cin = 1'b0;
    passA = 1'b0;
    passB = 1'b0;
    casex({ALU_op, ALU_funct})
      7'b00000_xx: //HALT
        begin

        end
      /*WORKING INSTRUCTIONS*/
      7'b11000_xx: //LBI
        begin
          op_to_alu = 3'b000;
          passB = 1'b1;
        end
      7'b11011_00: //ADD
        begin
          op_to_alu = 3'b100;
        end
      7'b11011_11: //ANDN
        begin
          invB = 1'b1;
          op_to_alu = 3'b111;
         end
      7'b11011_01: //SUB
        begin
          invA = 1'b1;
          cin = 1'b1;
          op_to_alu = 3'b100;
         end
      7'b11011_10: //XOR
        begin
          op_to_alu = 3'b110;
         end
      7'b11100_xx: //SEQ
        begin
          invA = 1'b1;
          cin = 1'b1;
          op_to_alu = 3'b100;
         end
      7'b11101_xx: //SLT
        begin
          invB = 1'b1;
          cin = 1'b1;
          op_to_alu = 3'b100;
         end
      7'b11110_xx: //SLE
        begin
          invB = 1'b1;
          cin = 1'b1;
          op_to_alu = 3'b100;
         end
      7'b11111_xx: //SCO
        begin
          op_to_alu = 3'b100;
         end
      7'b10010_xx: //SLBI
        begin
          op_to_alu = 3'b101; //OR
         end
      7'b01000_xx: //ADDI
        begin
          sign = 1'b1;
          op_to_alu = 3'b100;
        end
      7'b01001_xx: //SUBI
        begin
          invA = 1'b1;
          cin = 1'b1;
          op_to_alu = 3'b100;
         end
      7'b01010_xx: //XORI
        begin
          op_to_alu = 3'b110;
         end
      7'b01011_xx: //ANDNI
        begin
          invB = 1'b1;
          op_to_alu = 3'b111;
         end
///////////////////////////////////////
      7'b11010_00: //ROL
        begin
          op_to_alu = 3'b000;
         end


      default:
        begin

        end
    endcase
  end
endmodule
