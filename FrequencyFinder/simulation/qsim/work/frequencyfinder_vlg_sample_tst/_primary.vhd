library verilog;
use verilog.vl_types.all;
entity frequencyfinder_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        pushbuttond     : in     vl_logic;
        pushbuttoni     : in     vl_logic;
        serial_in       : in     vl_logic_vector(11 downto 0);
        sampler_tx      : out    vl_logic
    );
end frequencyfinder_vlg_sample_tst;
