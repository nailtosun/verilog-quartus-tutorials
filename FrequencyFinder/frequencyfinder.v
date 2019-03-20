//Frequency Finder
module frequencyfinder(clk,serial_in,pushbuttond,pushbuttoni,period);
input clk;
input pushbuttoni,pushbuttond;
input [11:0] serial_in;
output reg [31:0] period;
integer pushbuttond_counter;
integer pushbuttoni_counter;
reg [31:0] trigger;
reg [11:0] memory_serial_in; 
integer counter,dummy;
initial
begin
trigger <= 2;
memory_serial_in<=0;
dummy <= 0;
counter <= 0;
period <=0;
end

always @(posedge clk)
begin

if (serial_in == trigger && memory_serial_in != trigger)
begin
counter <= counter +1;
end

if (counter == 1)
begin
dummy<= dummy +1;
end

if (counter == 2)
begin
		dummy <= dummy + 1;
	end
	if (counter <= 3)
	period <= dummy;

	
//Buttons come here	
	if (pushbuttond == 0 && pushbuttond_counter < 'd1)
	begin
		pushbuttond_counter <= pushbuttond_counter + 'd1;
	end 
	else if (pushbuttond == 1) 
	begin
		pushbuttond_counter <= 0;
	end
	else
	begin
	trigger <= trigger - 1;
	end
	
	if (pushbuttoni == 0 && pushbuttoni_counter < 'd1)
	begin
		pushbuttoni_counter <= pushbuttoni_counter + 'd1;
	end 
	else if (pushbuttoni == 1) 
	begin
		pushbuttoni_counter <= 0;
	end
	else
	begin
		trigger <= trigger + 1;
	end
	memory_serial_in <= serial_in;
end
endmodule 