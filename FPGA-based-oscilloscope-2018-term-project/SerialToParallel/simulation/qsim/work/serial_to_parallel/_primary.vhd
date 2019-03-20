library verilog;
use verilog.vl_types.all;
entity serial_to_parallel is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        serial_in       : in     vl_logic;
        parallel_out    : out    vl_logic_vector(11 downto 0)
    );
end serial_to_parallel;
