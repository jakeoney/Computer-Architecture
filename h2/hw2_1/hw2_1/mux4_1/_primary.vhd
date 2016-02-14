library verilog;
use verilog.vl_types.all;
entity mux4_1 is
    port(
        ina             : in     vl_logic;
        inb             : in     vl_logic;
        inc             : in     vl_logic;
        ind             : in     vl_logic;
        s               : in     vl_logic_vector(1 downto 0);
        \Out\           : out    vl_logic
    );
end mux4_1;
