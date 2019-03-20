library verilog;
use verilog.vl_types.all;
entity serial_to_parallel_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        serial_in       : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end serial_to_parallel_vlg_sample_tst;
