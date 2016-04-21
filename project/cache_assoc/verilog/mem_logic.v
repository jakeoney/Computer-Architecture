module mem_logic(//Inputs
                 rd, wr, hit, dirty, state,
                 //Outputs
                 stall, err, done, next_state,
                 cache_wr, cache_hit, cache_offset, cache_sel, comp,
                 mem_wr, mem_rd, mem_offset, mem_sel
                );

  input rd, wr;
  input hit, dirty;
  input [3:0] state;

  output reg stall, err, done;
  output reg [3:0] next_state;
  
  output reg cache_wr, comp, cache_sel, cache_hit;
  output reg [1:0] cache_offset;

  output reg mem_wr, mem_rd, mem_sel;
  output reg [1:0] mem_offset;

  always @(*)
    begin
      //Defaults
      err <= 1'b0;
      stall <= 1'b1;
      done <= 1'b0;
      next_state <= 4'b0000;

      comp <= 1'b0;
      cache_wr <= 1'b1;
      cache_hit <= 1'b0;
      cache_offset <= 2'b00;
      cache_sel <= 1'b0;

      mem_rd <= 1'b0;
      mem_wr <= 1'b0;
      mem_sel <= 1'b0;
      mem_offset <= 2'b00;
      //END defaults

      casex({state, rd, wr, dirty, hit})
        //STATE 0
        //if no read or write, stay in this state
        8'b0000_0_0_x_x:
          begin
            next_state <= 4'b0000;
            stall <= 1'b0;
            comp <=1'b0;
          end
        //if hit, stay in this state
        8'b0000_x_x_x_1:
          begin
            next_state <= 4'b0000;
            cache_hit <= 1'b1;
            done <= 1'b1;
            comp <=1'b0;
            stall <= 1'b0;
          end

        //if read and dirty and not hit
        8'b0000_1_x_1_0:
          begin
            next_state <= 4'b0001;
            stall <= 1'b0;
            comp <=1'b0;
          end
        //if write and dirty and not hit
        8'b0000_x_1_1_0:
          begin
            next_state <= 4'b0001;
            stall <= 1'b0;
            comp <=1'b0;
          end

        //if read and not dirty and not hit
        8'b0000_1_x_0_0:
          begin
            next_state <= 4'b0101;
            stall <= 1'b0;
            comp <=1'b0;
          end
        //if write and not dirty and not hit
        8'b0000_x_1_0_0:
          begin
            next_state <= 4'b0101;
            stall <= 1'b0;
            comp <=1'b0;
          end
        //END State 0
        
        //Mem wr 4 cycle
        8'b0001_x_x_x_x:
          begin
            next_state <= 4'b0010;
            cache_wr <= 1'b0;
            mem_wr <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b0010_x_x_x_x:
          begin
            next_state <= 4'b0011;
            cache_wr <= 1'b0;
            mem_wr <= 1'b1;
            mem_offset[0] <= 1'b1;
            cache_offset[0] <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b0011_x_x_x_x:
          begin
            next_state <= 4'b0100;
            cache_wr <= 1'b0;
            mem_wr <= 1'b1;
            mem_offset[1] <= 1'b1;
            cache_offset[1] <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b0100_x_x_x_x:
          begin
            next_state <= 4'b0101;
            cache_wr <= 1'b0;
            mem_wr <= 1'b1;
            mem_offset[1] <= 1'b1;
            mem_offset[0] <= 1'b1;
            cache_offset[1] <= 1'b1;
            cache_offset[0] <= 1'b1;
            cache_sel <= 1'b1;
          end
        //END Mem wr 4 cycle
        //Mem rd 4 cycle
        8'b0101_x_x_x_x:
          begin
            next_state <= 4'b0110;
            mem_rd <= 1'b1;
            mem_sel <= 1'b1;
          end
        8'b0110_x_x_x_x:
          begin
            next_state <= 4'b0111;
            mem_rd <= 1'b1;
            mem_offset[0] <= 1'b1;
            mem_sel <= 1'b1;
          end
        8'b0111_x_x_x_x:
          begin
            next_state <= 4'b1000;
            mem_rd <= 1'b1;
            mem_offset[1] <= 1'b1;
            mem_sel <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b1000_x_x_x_x:
          begin
            next_state <= 4'b1001;
            mem_rd <= 1'b1;
            mem_offset[1] <= 1'b1;
            mem_offset[0] <= 1'b1;
            mem_sel <= 1'b1;
            cache_offset[0] <= 1'b1;
            cache_sel <= 1'b1;
          end
        //END mem rd 4 cycle
        8'b1001_x_x_x_x:
          begin
            next_state <= 4'b1010;
            cache_offset[1] <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b1010_x_x_x_x:
          begin
            next_state <= 4'b1011;
            cache_offset[1] <= 1'b1;
            cache_offset[0] <= 1'b1;
            cache_sel <= 1'b1;
          end
        8'b1011_x_x_x_x:
          begin
            next_state <= 4'b1100;
            comp <= 1'b1;
          end
        //Last state - nothing
        8'b1100_0_0_x_x:
          begin
            next_state <= 4'b0000;
            comp <= 1'b1;
            stall <= 1'b0;
            done <= 1'b1;
          end
        //Last state - hit
        8'b1100_x_x_x_1:
          begin
            next_state <= 4'b0000;
            comp <= 1'b1;
            stall <= 1'b0;
            //cache_hit <= 1'b1;
            done <= 1'b1;
          end
        
        //Last state - read, dirty, not hit
        8'b1100_1_x_1_0:
          begin
            next_state <= 4'b0001;
            comp <= 1'b1;
            stall <= 1'b0;
            done <= 1'b1;
          end
        //Last state - write, dirty, not hit
        8'b1100_x_1_1_0:
          begin
            next_state <= 4'b0001;
            comp <= 1'b1;
            stall <= 1'b0;
            done <= 1'b1;
          end

        //Last state - read, not dirty, not hit
        8'b1100_1_x_0_0:
          begin
            next_state <= 4'b0101;
            comp <= 1'b1;
            stall <= 1'b0;
            done <= 1'b1;
          end
        //Last state - write, not dirty, not hit
        8'b1100_x_1_0_0:
          begin
            next_state <= 4'b0101;
            comp <= 1'b1;
            stall <= 1'b0;
            done <= 1'b1;
          end
          
        default:
          begin
            err <= 1'b1;
            next_state <= 4'b1111;
          end
      endcase
    end
endmodule
