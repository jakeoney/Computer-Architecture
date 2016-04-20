module mem_next_state(//Inputs
                 rd, wr, hit, dirty, state,
                 //Outputs
                 err,next_state
                );

  input rd, wr;
  input hit, dirty;
  input [3:0] state;

  output reg err;
  output reg [3:0] next_state;
  
  always @(*)
    begin
      //Defaults
      err <= 1'b0;
      next_state <= 4'b0000;

      casex({state, rd, wr, dirty, hit})
        //STATE 0
        //if no read or write, stay in this state
        8'b0000_0_0_x_x:
          begin
            next_state <= 4'b0000;
          end
        //if hit, stay in this state
        8'b0000_x_x_x_1:
          begin
            next_state <= 4'b0000;
          end

        //if read and dirty and not hit
        8'b0000_1_x_1_0:
          begin
            next_state <= 4'b0001;
          end
        //if write and dirty and not hit
        8'b0000_x_1_1_0:
          begin
            next_state <= 4'b0001;
          end

        //if read and not dirty and not hit
        8'b0000_1_x_0_0:
          begin
            next_state <= 4'b0101;
          end
        //if write and not dirty and not hit
        8'b0000_x_1_0_0:
          begin
            next_state <= 4'b0101;
          end
        //END State 0
        
        //Mem wr 4 cycle
        8'b0001_x_x_x_x:
          begin
            next_state <= 4'b0010;
          end
        8'b0010_x_x_x_x:
          begin
            next_state <= 4'b0011;
          end
        8'b0011_x_x_x_x:
          begin
            next_state <= 4'b0100;
          end
        8'b0100_x_x_x_x:
          begin
            next_state <= 4'b0101;
          end
        //END Mem wr 4 cycle
        //Mem rd 4 cycle
        8'b0101_x_x_x_x:
          begin
            next_state <= 4'b0110;
          end
        8'b0110_x_x_x_x:
          begin
            next_state <= 4'b0111;
          end
        8'b0111_x_x_x_x:
          begin
            next_state <= 4'b1000;
          end
        8'b1000_x_x_x_x:
          begin
            next_state <= 4'b1001;
          end
        //END mem rd 4 cycle
        8'b1001_x_x_x_x:
          begin
            next_state <= 4'b1010;
          end
        8'b1010_x_x_x_x:
          begin
            next_state <= 4'b1011;
          end
        8'b1011_x_x_x_x:
          begin
            next_state <= 4'b1100;
          end
        //Last state - nothing
        8'b1100_0_0_x_x:
          begin
            next_state <= 4'b0000;
          end
        //Last state - hit
        8'b1100_x_x_x_1:
          begin
            next_state <= 4'b0000;
          end
        
        //Last state - read, dirty, not hit
        8'b1100_1_x_1_0:
          begin
            next_state <= 4'b0001;
          end
        //Last state - write, dirty, not hit
        8'b1100_x_1_1_0:
          begin
            next_state <= 4'b0001;
          end

        //Last state - read, not dirty, not hit
        8'b1100_1_x_0_0:
          begin
            next_state <= 4'b0101;
          end
        //Last state - write, not dirty, not hit
        8'b1100_x_1_0_0:
          begin
            next_state <= 4'b0101;
          end
          
        default:
          begin
            err <= 1'b1;
            next_state <= 4'b1111;
          end
      endcase
    end
endmodule
