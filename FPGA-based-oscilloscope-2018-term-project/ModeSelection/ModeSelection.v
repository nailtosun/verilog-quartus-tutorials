module ModeSelection(clk, ac_button, dc_button, result, serial_in, offset);
input clk, ac_button, dc_button;
input [11:0] serial_in; 
input [11:0] offset;
output reg [11:0] result; //Undefined
integer ac_button_counter, dc_button_counter;

initial
begin
ac_button_counter = 0;
dc_button_counter = 0;
end

always @(posedge clk) begin
	if (ac_button == 0 && ac_button_counter < 'd100)
	begin
		ac_button_counter <= ac_button_counter + 'd1;
	end
	else if (ac_button == 1)
	begin
		ac_button_counter <= 0;
	end
	else
	begin
	result <= serial_in - offset;
	end

	if (dc_button == 0 && dc_button_counter < 'd100 )
	begin
		dc_button_counter <= dc_button_counter + 'd1;
	end
	else if (dc_button == 1)
	begin
		dc_button_counter <= 'd0;
	end
	else
	begin
	result <= serial_in;
	end
end
endmodule
