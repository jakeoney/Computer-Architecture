library verilog;
use verilog.vl_types.all;
entity shifter_one_bit is
    port(
        \In\            : in     vl_logic_vector(15 downto 0);
        cnt             : in     vl_logic;
        op              : in     vl_logic_vector(1 downto 0);
        \Out\           : out    vl_logic_vector(15 downto 0)
    );
end shifter_one_bit;
