library verilog;
use verilog.vl_types.all;
entity clkrst is
    port(
        clk             : out    vl_logic;
        rst             : out    vl_logic;
        err             : in     vl_logic
    );
end clkrst;
