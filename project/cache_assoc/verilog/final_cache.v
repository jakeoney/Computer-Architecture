module final_cache(enable, clk, rst, createdump, tag_in, index, offset,
                   data_in, comp, write, valid_in,
                   tag_out, data_out, hit, dirty, valid, err
                  );

  input enable, clk, rst, createdump;
  input [4:0] tag_in;
  input [7:0] index;
  input [2:0] offset;
  input [15:0] data_in;
  input comp, write, valid_in;

  output [4:0] tag_out;
  output [15:0] data_out;
  output hit, dirty, valid, err;

  parameter mem_type = 0;

  //Cache0 and Cach1 output signals to be used to determine correct output
  //signals
  wire [4:0] cache_tag_out0;
  wire [15:0]  DataOut0;
  wire cache_hit0, cache_dirty0, cache_valid0, cache_err0;
  wire [4:0] cache_tag_out1;
  wire [15:0]  DataOut1;
  wire cache_hit1, cache_dirty1, cache_valid1, cache_err1;
  
  //Internal victim, cache_select, and valid/invalid signals
  wire victim, victim_in;
  wire cache_sel;
  wire cache_en0, cache_en1;
  wire valid_invalid0, valid_invalid1;
  wire v_inv_in0, v_inv_in1;
  wire dirty_sel;

  //Victim way - each read or write, the state is inverted
  assign victim_in = (comp & hit & valid) ? ~victim : victim;
  dff victimway(.q(victim), .d(victim_in), .clk(clk), .rst(rst));
  
  //Assigning valid/invalid each cache
  assign v_inv_in0 = (~comp) ? valid_invalid0 : cache_valid0;
  assign v_inv_in1 = (~comp) ? valid_invalid1 : cache_valid1;
  dff VALID0(.q(valid_invalid0), .d(v_inv_in0), .clk(clk), .rst(rst));
  dff VALID1(.q(valid_invalid1), .d(v_inv_in1), .clk(clk), .rst(rst));

  //Defining cache select signal and cache enable signals
  assign cache_sel = (valid_invalid0 & ~valid_invalid1) | (valid_invalid0 & victim);
  assign cache_en0 = (comp) ? enable : ~cache_sel;
  assign cache_en1 = (comp) ? enable : cache_sel;

  //First cache unit
  cache #(0 + mem_type) c0(// Outputs
                          .tag_out              (cache_tag_out0),
                          .data_out             (DataOut0),
                          .hit                  (cache_hit0),
                          .dirty                (cache_dirty0),
                          .valid                (cache_valid0),
                          .err                  (cache_err0),
                          // Inputs
                          .enable               (cache_en0),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in)
                          );
  //Second cache unit
  cache #(2 + mem_type) c1(// Outputs
                          .tag_out              (cache_tag_out1),
                          .data_out             (DataOut1),
                          .hit                  (cache_hit1),
                          .dirty                (cache_dirty1),
                          .valid                (cache_valid1),
                          .err                  (cache_err1),
                          // Inputs
                          .enable               (cache_en1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in)
                          );

  //Assigning output signals
  assign data_out = (comp) ? (DataOut0 & {16{cache_hit0 & cache_valid0}} | DataOut1 & {16{cache_hit1 & cache_valid1}}) : ((cache_sel) ? DataOut1 : DataOut0);
  
  //Simple output based on whether signal from cache0 or cache1
  assign tag_out = (cache_sel) ? cache_tag_out1 : cache_tag_out0;
  assign valid = (cache_valid0 & cache_hit0) | (cache_valid1 & cache_hit1);
  assign hit = cache_hit0 | cache_hit1;
  assign err = cache_err0 | cache_err1;
  
  //Dirty logic
  assign dirty_sel = (victim & cache_valid0) | (cache_valid0 & ~cache_valid1);
  assign dirty = (dirty_sel) ? cache_dirty1 : cache_dirty0;

endmodule
