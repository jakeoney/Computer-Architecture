library verilog;
use verilog.vl_types.all;
entity mux2_1 is
    port(
        ina             : in     vl_logic;
        inb             : in     vl_logic;
        s               : in     vl_logic;
        \Out\           : out    vl_logic
    );
end mux2_1;
