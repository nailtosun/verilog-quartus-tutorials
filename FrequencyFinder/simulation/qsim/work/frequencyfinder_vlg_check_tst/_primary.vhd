library verilog;
use verilog.vl_types.all;
entity frequencyfinder_vlg_check_tst is
    port(
        period          : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end frequencyfinder_vlg_check_tst;
