//Both magnitude and dc offset finder.
//Dc offset output will use later for AC-DC coupling mode
//Peak to peak bug fixed but not tested on fpga
module magnitude_finder(magnitude_in,clk,amplitude,dc_offset);
input [11:0] magnitude_in;// dimension are changign wrt adc
input clk;
output reg [11:0] amplitude;
output reg [11:0] dc_offset;
reg [31:0] counter;
reg [11:0] max,min;
initial
	begin
		amplitude <= 12'b0;
		max <= 12'b0;		//maximum starts at lowest value
		min <= 12'b111111111111; 	//magnitude edited bug fixed
	end
always @(posedge clk)
begin
	if(max<magnitude_in) max<=magnitude_in; //update
	else max<=max; //dont update
	if(min>magnitude_in) min<=magnitude_in; //update
	else min<=min; //dont update
	amplitude<=(max-min);
	dc_offset<=(max+min)/2;
	counter<=counter+1;
	if(counter==49999999)  //reflesh for preventing overflow
		begin
			amplitude <= 12'b0;
			max <= 12'b0;
			min <= 12'b111111111111;
			counter <= 0;
		end
end
endmodule
module magnitude_in_tb ();
	reg clk;
	reg[11: 0] magnitude_in;
	wire[11: 0] amp, dc_offset;
	magnitude_finder DUT (magnitude_in,clk,amp,dc_offset);
	always begin
		clk = 0; #1000; clk = 1; #1000;
	end
	initial begin
		magnitude_in = 12'b000000000; // V = 0
		#8000;
		magnitude_in = magnitude_in + 1; // V = 1
		#8000;
		magnitude_in = magnitude_in + 1; // V = 2
		#8000;
		magnitude_in = magnitude_in + 1; // V = 3
		#8000;
		magnitude_in = magnitude_in + 1; // V = 4
		#8000;
		magnitude_in = magnitude_in - 1; // V = 3
		#8000;
		magnitude_in = magnitude_in - 1; // V = 2
		#8000;
		magnitude_in = magnitude_in - 1; // V = 1
		#8000;
		magnitude_in = magnitude_in - 1; // V = 0
		#8000;
		magnitude_in = magnitude_in + 1; // V = 1
		#8000;
		magnitude_in = magnitude_in + 1; // V = 2
		#8000;
		magnitude_in = magnitude_in + 1; // V = 3
		#8000;
		magnitude_in = magnitude_in + 1; // V = 4
		#8000;
		magnitude_in = magnitude_in - 1; // V = 3
		#8000;
		magnitude_in = magnitude_in - 1; // V = 2
		#8000;
		magnitude_in = magnitude_in - 1; // V = 1
		#8000;
	end
endmodule
