
module ssm(clk,alarm_time,seven_display);

input clk;

input [3:0] alarm_time;

output reg [6:0] seven_display;

always @(alarm_time)
begin
	case(alarm_time)
   0:seven_display<=7'b1000000;
	1:seven_display<=7'b1111001;
	2:seven_display<=7'b0100100;
	3:seven_display<=7'b0110000;
   4:seven_display<=7'b0011001;
	5:seven_display<=7'b0010010;
	6:seven_display<=7'b0000010;
	7:seven_display<=7'b1111000;
   8:seven_display<=7'b0000000;
	9:seven_display<=7'b0010000;
	endcase
   
end

endmodule 