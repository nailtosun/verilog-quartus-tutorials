library verilog;
use verilog.vl_types.all;
entity square_vlg_check_tst is
    port(
        square_out      : in     vl_logic_vector(31 downto 0);
        sampler_rx      : in     vl_logic
    );
end square_vlg_check_tst;
