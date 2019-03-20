// alarm_controller_tb.v

// The Verilog Tutorial Project Test Bench
// METU EE314 Digital Electronics Laboratory

`timescale 10 ns / 1 ps

module alarm_controller_tb();


reg CLK, start_stop_button, set_button, snooze_button;

wire [3:0] ssd_led_out; // seven segment display output
wire [8:0] led_out; // led output

alarm_controller dut ( .CLK(CLK), .start_stop_button(start_stop_button),
							  .set_button(set_button), .snooze_button(snooze_button),
							  .ssd_led_out(ssd_led_out), .led_out(led_out)) ;
							  
initial begin
CLK = 0;
start_stop_button = 1;
set_button = 1;
snooze_button = 1;
end
							  
							  
// Clock setup							  
always begin
 CLK <= 0; #1 ;  CLK <= 1; #1 ;
end

always begin
#1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #2000000 ;
start_stop_button <= 0; #50000 ;
start_stop_button <= 1; #1000000 ;
snooze_button <= 0; #50000;
snooze_button <= 1; #1000000 ;
snooze_button <= 0; #50000 ;
snooze_button <= 1; #1000000 ;
start_stop_button <= 0; #50000 ;
start_stop_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #50000 ;
set_button <= 1; #1000000 ;
set_button <= 0; #1000000 ;
start_stop_button <= 0; #50000 ;
start_stop_button <= 1; #1000000 ;
start_stop_button <= 0; #50000 ;
start_stop_button <= 1;
end
endmodule 