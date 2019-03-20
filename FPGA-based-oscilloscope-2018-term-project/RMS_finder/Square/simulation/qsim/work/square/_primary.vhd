library verilog;
use verilog.vl_types.all;
entity square is
    port(
        clk             : in     vl_logic;
        serial_in       : in     vl_logic_vector(11 downto 0);
        square_out      : out    vl_logic_vector(31 downto 0)
    );
end square;
