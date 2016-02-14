library verilog;
use verilog.vl_types.all;
entity nand2 is
    port(
        in1             : in     vl_logic;
        in2             : in     vl_logic;
        \out\           : out    vl_logic
    );
end nand2;
