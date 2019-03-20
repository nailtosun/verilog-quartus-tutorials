library verilog;
use verilog.vl_types.all;
entity square_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        serial_in       : in     vl_logic_vector(11 downto 0);
        sampler_tx      : out    vl_logic
    );
end square_vlg_sample_tst;
