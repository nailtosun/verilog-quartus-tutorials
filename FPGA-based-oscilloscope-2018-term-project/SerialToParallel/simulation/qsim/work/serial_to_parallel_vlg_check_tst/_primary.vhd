library verilog;
use verilog.vl_types.all;
entity serial_to_parallel_vlg_check_tst is
    port(
        parallel_out    : in     vl_logic_vector(11 downto 0);
        sampler_rx      : in     vl_logic
    );
end serial_to_parallel_vlg_check_tst;
