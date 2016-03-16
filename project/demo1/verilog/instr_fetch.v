module instr_fetch(pc, clk, rst, instruction, next_pc, err);

  input [15:0] pc;
  input clk, rst;

  output [15:0] next_pc;
  output [15:0] instruction;
  output err;

  wire [15:0] next; //next isn't actually the next pc, it is the intermediate value before add 2 
  wire cin;
  wire [15:0] increment_pc;
  wire sign;
  wire dump, wr, enable;
  wire [15:0] data_in;

  assign increment_pc = 16'b0000_0000_0000_0010;
  assign sign = 1'b0; //I don't think it is signed
  assign cin = 1'b0;  //No cin
  assign data_in = 16'b0000_0000_0000_0000;
  assign dump = 1'b0;
  assign wr = 1'b0;
  assign enable = ~rst;  //Might not want to always have this enabled

  dff ZERO(.q(next[0]),  .d(pc[0]),  .clk(clk), .rst(rst));
  dff ONE (.q(next[1]),  .d(pc[1]),  .clk(clk), .rst(rst));
  dff TWO (.q(next[2]),  .d(pc[2]),  .clk(clk), .rst(rst));
  dff THRE(.q(next[3]),  .d(pc[3]),  .clk(clk), .rst(rst));
  dff FOUR(.q(next[4]),  .d(pc[4]),  .clk(clk), .rst(rst));
  dff FIVE(.q(next[5]),  .d(pc[5]),  .clk(clk), .rst(rst));
  dff SIX (.q(next[6]),  .d(pc[6]),  .clk(clk), .rst(rst));
  dff SEVE(.q(next[7]),  .d(pc[7]),  .clk(clk), .rst(rst));
  dff EIGH(.q(next[8]),  .d(pc[8]),  .clk(clk), .rst(rst));
  dff NINE(.q(next[9]),  .d(pc[9]),  .clk(clk), .rst(rst));
  dff TEN (.q(next[10]), .d(pc[10]), .clk(clk), .rst(rst));
  dff ELEV(.q(next[11]), .d(pc[11]), .clk(clk), .rst(rst));
  dff TWEL(.q(next[12]), .d(pc[12]), .clk(clk), .rst(rst));
  dff THIR(.q(next[13]), .d(pc[13]), .clk(clk), .rst(rst));
  dff FORT(.q(next[14]), .d(pc[14]), .clk(clk), .rst(rst));
  dff FIFT(.q(next[15]), .d(pc[15]), .clk(clk), .rst(rst));

  //add 2 to the get the next pc
  adder16 ADD(.A(next), .B(increment_pc), .Cin(cin), .sign(sign), .Out(next_pc), .Ofl(err));

  //Get next instruction from instruction memory
  memory2c IMEM(.data_out(instruction), .data_in(data_in), .addr(next), .enable(enable), .wr(wr), .createdump(dump), .clk(clk), .rst(rst)); 

endmodule
