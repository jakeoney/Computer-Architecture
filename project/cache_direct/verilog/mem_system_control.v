module mem_system_control(clk, rst, rd, wr, hit, dirty,
                          cache_wr, cache_hit, cache_sel, cache_offset, comp,
                          stall, err, done,
                          mem_rd, mem_wr, mem_sel, mem_offset
                         );

  input clk, rst;
  input rd, wr;
  input hit, dirty;

  //Cache out
  output cache_wr;
  output cache_hit;
  output cache_sel;
  output [1:0] cache_offset;
  output comp;
  
  //Out
  output stall;
  output err;
  output done;

  //Mem out
  output mem_rd;
  output mem_wr;
  output mem_sel;
  output [1:0] mem_offset;

  wire [3:0] state, next_state;

  mem_logic LOGIC(//Inputs
                  .rd(rd), .wr(wr), .hit(hit), .dirty(dirty), .state(state),
                  //Outputs
                  .stall(stall), .err(err), .done(done), .next_state(next_state),
                  //Outputs - Cache
                  .cache_wr(cache_wr), .comp(comp),
                  .cache_offset(cache_offset), .cache_sel(cache_sel),
                  .cache_hit(cache_hit),
                  //Outputs - Mem
                  .mem_wr(mem_wr), .mem_rd(mem_rd), .mem_sel(mem_sel),
                  .mem_offset(mem_offset)
  );

  mem_state STATE(.next_state(next_state), .state(state), .clk(clk), .rst(rst));


endmodule
