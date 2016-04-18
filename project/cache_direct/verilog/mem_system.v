module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

  //Mem signals 
  wire [15:0] mem_addr;
  wire mem_err;
  wire [3:0] mem_busy;
  wire mem_stall;
  wire [15:0] mem_data_out;

  //Cache out wires
  wire cache_err;
  wire cache_hit;
  wire cache_dirty;
  wire [4:0] cache_tag_out;
  wire cache_valid;

  //Control out wires
  wire control_err;
  wire mem_rd, mem_wr, mem_sel;
  wire [1:0] mem_offset;
  wire cache_wr, cache_sel, comp;
  wire [1:0] cache_offset;

  /* data_mem = 1, inst_mem = 0 *
   * needed for cache parameter */
  wire [2:0] cache_off;
  wire [15:0] cache_data_in;
  wire cache_write;

  assign cache_write = (cache_sel) ? cache_wr : Wr;
  assign cache_data_in = (cache_sel) ? mem_data_out : DataIn;
  assign cache_off = (cache_sel) ? {cache_offset, 1'b0} : Addr[2:0];


  assign mem_addr = (mem_sel) ? {Addr[15:3], mem_offset, 1'b0} :
                                {cache_tag_out, Addr[10:3], mem_offset, 1'b0};
  
  parameter mem_type = 0;
  cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (cache_tag_out),
                          .data_out             (DataOut),
                          .hit                  (cache_hit),
                          .dirty                (cache_dirty),
                          .valid                (cache_valid),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (Rd | Wr),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (Addr[15:11]),
                          .index                (Addr[10:3]),
                          .offset               (cache_off),
                          .data_in              (cache_data_in),
                          .comp                 (comp),
                          .write                (cache_write),
                          .valid_in             (1'b1)
                          );
    
  four_bank_mem mem(// Outputs
                     .data_out          (mem_data_out),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (DataOut),
                     .wr                (mem_wr),
                     .rd                (mem_rd)
                     );

   
  // your code here
  mem_system_control ctl(//Outputs
                         .err(control_err),
                         .stall(Stall),
                         .done(Done),

                         .cache_wr(cache_wr),
                         .cache_hit(CacheHit),
                         .cache_sel(cache_sel), 
                         .cache_offset(cache_offset),
                         .comp(comp),

                         .mem_rd(mem_rd), 
                         .mem_wr(mem_wr),
                         .mem_sel(mem_sel),
                         .mem_offset(mem_offset),

                         //Inputs
                         .clk(clk),
                         .rst(rst),
                         .rd(Rd),
                         .wr(Wr),
                         .hit(cache_hit & cache_valid),
                         .dirty(cache_dirty)
                        );
   
  assign err = cache_err | mem_err | control_err;

endmodule // mem_system
