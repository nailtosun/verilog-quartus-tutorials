library verilog;
use verilog.vl_types.all;
entity Mean_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        period          : in     vl_logic_vector(31 downto 0);
        serial_square_in: in     vl_logic_vector(31 downto 0);
        sampler_tx      : out    vl_logic
    );
end Mean_vlg_sample_tst;
