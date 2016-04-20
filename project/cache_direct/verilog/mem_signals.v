module mem_signals(//Inputs
                 hit, state,
                 //Outputs
                 stall, done,
                 cache_wr, cache_hit, cache_offset, cache_sel, comp,
                 mem_wr, mem_rd, mem_offset, mem_sel
                );

  input hit;
  input [3:0] state;

  output stall, done;
  
  output cache_wr, comp, cache_sel, cache_hit;
  output [1:0] cache_offset;

  output mem_wr, mem_rd, mem_sel;
  output [1:0] mem_offset;

  //Output signals
  assign stall = (state !== 4'b0000) & (state !== 4'b1100);
  assign done = ((state === 4'b0000)&hit) | (state === 4'b1100);

  //Cache signals
  assign cache_wr = (state === 4'b0000) | (state === 4'b0101) | (state === 4'b0110) | (state === 4'b0111) |
                    (state === 4'b1000) | (state === 4'b1001) | (state === 4'b1010) | (state === 4'b1011) | (state === 4'b1100);
  assign cache_hit = ((state === 4'b0000) & hit);
  assign cache_offset[0] = (state === 4'b0010) | (state === 4'b0100) | (state === 4'b1000) | (state === 4'b1010);
  assign cache_offset[1] = (state === 4'b0011) | (state === 4'b0100) | (state === 4'b1001) | (state === 4'b1010);
  assign cache_sel = (state === 4'b0001) | (state === 4'b0010) | (state === 4'b0011) | (state === 4'b0100) |
                     (state === 4'b0111) | (state === 4'b1000) | (state === 4'b1001) | (state === 4'b1010);
  assign comp = (state === 4'b0000) | (state === 4'b1011) | (state === 4'b1100);

  //Memory signals
  assign mem_wr = (state === 4'b0001) | (state === 4'b0010) | (state === 4'b0011) | (state === 4'b0100);
  assign mem_rd = (state === 4'b0101) | (state === 4'b0110) | (state === 4'b0111) | (state === 4'b1000);
  assign mem_offset[0] = (state === 4'b0010) | (state === 4'b0100) | (state === 4'b0110) | (state === 4'b1000);
  assign mem_offset[1] = (state === 4'b0011) | (state === 4'b0100) | (state === 4'b0111) | (state === 4'b1000);
  assign mem_sel = (state === 4'b0101) | (state === 4'b0110) | (state === 4'b0111) | (state === 4'b1000);

endmodule
