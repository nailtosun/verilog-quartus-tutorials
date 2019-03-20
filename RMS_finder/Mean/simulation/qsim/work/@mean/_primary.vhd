library verilog;
use verilog.vl_types.all;
entity Mean is
    port(
        clk             : in     vl_logic;
        period          : in     vl_logic_vector(31 downto 0);
        serial_square_in: in     vl_logic_vector(31 downto 0);
        mean            : out    vl_logic_vector(31 downto 0)
    );
end Mean;
