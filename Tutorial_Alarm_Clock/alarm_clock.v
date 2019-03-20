// alarm_clock.v

// The Verilog Tutorial Project
// METU EE314 Digital Electronics Laboratory

module alarm_clock(CLK, start_stop_button, set_button, snooze_button , seven_segment, led_out);
input CLK, start_stop_button, set_button, snooze_button;               

output reg [3:0] seven_segment; // seven segment display output
output reg [8:0] led_out; // led output

wire [3:0] ssd_led_out;
reg [3:0] ssd_led_in;

wire [6:0] seven_display;
wire [8:0] led_out_wire;

alarm_controller control ( .CLK(CLK), .start_stop_button(start_stop_button),
							  .set_button(set_button), .snooze_button(snooze_button),
							  .ssd_led_out(ssd_led_out), .led_out(led_out_wire)) ;


ssm display(.clk(CLK), .alarm_time(ssd_led_in), .seven_display(seven_display));

always begin
		 ssd_led_in <= ssd_led_out;
		 seven_segment <= seven_display;
		 led_out <= led_out_wire;
end

endmodule 