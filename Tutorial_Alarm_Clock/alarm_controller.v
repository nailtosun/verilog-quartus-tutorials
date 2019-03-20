// alarm_controller.v

// The Verilog Tutorial Project
// METU EE314 Digital Electronics Laboratory

module alarm_controller ( CLK, start_stop_button, set_button, snooze_button, ssd_led_out, led_out) ;

input CLK, start_stop_button, set_button, snooze_button;

output reg [3:0] ssd_led_out; // seven segment display output
output reg [8:0] led_out; // led output

// state parameter definiton, in total 5 states represented with three bits

reg [2:0] alarm_state;
 
parameter st00_idle = 'd0;
parameter st01_set = 'd1;
parameter st02_start = 'd2;
parameter st03_alarm = 'd3;
parameter st04_snooze_start ='d4;

// internal registers
reg clk_en, set_en;

integer start_stop_counter, set_button_counter, counter_clk, rem_time, set_time;

// initial setup of the system
initial begin 
	alarm_state = st00_idle;
	clk_en = 0;
	set_en = 0;
	
	start_stop_counter = 0;
	set_button_counter = 0;
	counter_clk = 0;
	rem_time = 0;
	set_time = 0;
	
	ssd_led_out = 3'b0;
	led_out = 9'b0;
end

// Process 1 :  enabling the FPGA clock during operation
always @(posedge CLK) 
begin
 if (alarm_state == st02_start || alarm_state == st03_alarm) begin
	if(counter_clk == 'd49999999) begin
		counter_clk <= 'd0;
		clk_en = 1;
	end else begin
		counter_clk <= counter_clk +1;
		clk_en <= 0;
	end

 end else begin
   counter_clk <= 'd0;
   clk_en <= 0; 
 end
 
end

// Process 2 :  set and start/stop counters
always @(posedge CLK) begin
	if (set_button == 0 && set_button_counter < 'd100) begin
			set_button_counter <= set_button_counter + 'd1;
	end else if (set_button == 1) begin
			set_button_counter <= 0;
	end
		
	if (start_stop_button == 0 && start_stop_counter < 'd100 ) begin
		start_stop_counter <= start_stop_counter + 'd1;
	end else if (start_stop_button == 1) begin
		start_stop_counter <= 'd0;
	end	
end
 
// Process 3 : state machine
always @(posedge CLK) begin
	case (alarm_state)
	
	st00_idle : begin 
					alarm_state <= st01_set;
					led_out <= 9'b0;
					set_time <= 0;
					set_en <= 0;
					end
					
	st01_set :  begin
				   if (set_button_counter == 'd98 && set_time < 'd8) begin
						set_time <= set_time+'d1;
						set_en <= 1;
						led_out <= {led_out[7:0],1'b1}; // shifting left with 1, i.e. swithcing on the MSB led
					end else if (start_stop_counter == 'd98 & set_time == 1) begin
						alarm_state <= st02_start;
						end
				   end
					
	st02_start : begin
					if (rem_time == 0 ) begin
						alarm_state <= st03_alarm;
					end else if (clk_en == 1) begin
						led_out <= {1'b0, led_out[8:1]}; // shifting right with 0, i.e. swithcing off the MSB led
						end
					end
					
	st03_alarm : begin
					if(snooze_button == 0) begin
						alarm_state <= st04_snooze_start;
					end else if (start_stop_button == 0 && start_stop_counter == 98) begin
						alarm_state <= st00_idle;
						end else if (clk_en == 1) begin
						led_out <= ~led_out; // blinking during alarm
						end
					end
					
	st04_snooze_start :  begin
						alarm_state <= st02_start;
						led_out<= 9'b000011111;
						end
						
	default : begin // optional default case
				 alarm_state <= st00_idle;
				 end
				 
	endcase
end

//Process 4 : remaining time setup
always @(posedge CLK) begin
		if (alarm_state == st01_set) begin
			rem_time <= set_time;
			if (set_button_counter == 'd98 && set_time < 'd8) begin
				ssd_led_out<= ssd_led_out + 'd1;
			end else if (alarm_state == st02_start ) begin
				if (clk_en == 1 & rem_time > 'd0 )begin
					rem_time <= rem_time -'d1;
					ssd_led_out <= ssd_led_out - 'd1;
				end
			end
		end else if (alarm_state == st04_snooze_start) begin
			rem_time <= 'd5;
			ssd_led_out <= 4'b0101;
		end
end
endmodule 