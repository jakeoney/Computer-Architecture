module register_control(instruction, Rs, Rt, Rd, Rs_valid, Rt_valid, Rd_valid);
  
  input [15:0] instruction;
   
  //Register Identifiers for data hazards
  output reg [2:0] Rs, Rt, Rd;
  output reg Rs_valid, Rt_valid, Rd_valid;
  
  always @(instruction)
  begin
    //Defaults
    Rs = 3'b000;
    Rs_valid = 1'b0;
    Rt = 3'b000;
    Rt_valid = 1'b0;
    Rd = 3'b000;
    Rd_valid = 1'b0;
    casex(instruction[15:11])
      5'b0_00xx: //HALT, NOP, SIIC, NOP/RTI
        begin
        end
      
      5'b0_10xx: //ADDI, SUBI, XORI, ANDNI
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rd = instruction[7:5]; 
          Rd_valid = 1'b1;
        end

      5'b1_01xx: //ROLI, SLLI, RORI, SRLI
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rd = instruction[7:5];
          Rd_valid = 1'b1;
        end

      5'b1_101x: //ADD, SUB, XOR, ANDN, ROL, SLL, ROR, SRL
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rt = instruction[7:5];
          Rt_valid = 1'b1;
          Rd = instruction[4:2];
          Rd_valid = 1'b1;
        end
  
      5'b1_11xx: //SEQ, SLT, SLE, SCO
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rt = instruction[7:5];
          Rt_valid = 1'b1;
          Rd = instruction[4:2];
          Rd_valid = 1'b1;
        end

      5'b1_1001: // BTR
        begin
          Rs = instruction[10:8];
          Rd = instruction[4:2];
          Rs_valid = 1'b1;
          Rd_valid = 1'b1;
        end

      5'b0_1100: //BEQZ, BNEZ, BLTZ, BGEZ
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
        end
      
      5'b1_1000: //LBI
        begin
          //Rs = instruction[10:8];
          //Rs_valid = 1'b1;
          Rd = instruction[10:8];
          Rd_valid = 1'b1;
        end
  
      5'b1_0010: //SLBI
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rd = instruction[10:8];
          Rd_valid = 1'b1;
        end

      5'b1_0000: //ST, LD
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rt = instruction[7:5];
          Rt_valid = 1'b1;
          Rd = instruction[7:5];
          Rd_valid = 1'b1;
        end
      5'b1_0001: //ST, LD
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rt = instruction[7:5];
          Rt_valid = 1'b1;
          Rd = instruction[7:5];
          Rd_valid = 1'b1;
        end
      
      5'b1_0011: //STU
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rt = instruction[7:5];
          Rt_valid = 1'b1;
          Rd = instruction[10:8];
          Rd_valid = 1'b1;
        end

      5'b0_0100: //J
        begin
        end
      5'b0_0101: //JR
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
        end
      5'b0_0110: //JAL
        begin
          Rd = 3'b111;
          Rd_valid = 1'b1;
          Rt = 3'b111;
          Rt_valid = 1'b1;
        end
      5'b0_0111: //JALR
        begin
          Rs = instruction[10:8];
          Rs_valid = 1'b1;
          Rd = 3'b111;
          Rd_valid = 1'b1;
          Rt = 3'b111;
          Rt_valid = 1'b1;
        end
      default:
        begin
          //do nothing? throw err?
        end
    endcase
  end
endmodule
