library verilog;
use verilog.vl_types.all;
entity frequencyfinder is
    port(
        clk             : in     vl_logic;
        serial_in       : in     vl_logic_vector(11 downto 0);
        pushbuttond     : in     vl_logic;
        pushbuttoni     : in     vl_logic;
        period          : out    vl_logic_vector(31 downto 0)
    );
end frequencyfinder;
