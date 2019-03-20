library verilog;
use verilog.vl_types.all;
entity Mean_vlg_check_tst is
    port(
        mean            : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end Mean_vlg_check_tst;
