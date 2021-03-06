//Frequency finder
//Frequency bug (overflow) fixed
//This version doesn't cover FIXED Bug to do so change 2.5 volt
//trigger to mean.
	module frequency_finder(clk,data,freq_out);
	input clk;
	input [11:0] data;
	output reg [31:0] freq_out;
	reg [1:0] mode;
	integer counter;
	integer freq_int;
	integer freq_const;
	integer counter_clk;
	reg clk_en;
	initial begin
		counter <= 'd0;
		counter_clk <= 'd0;
		mode <= 2'b00;
		freq_out <= 32'b0000000000;
		freq_const <= 'd100000;  // clk/500 since our loop is 500
		freq_int <= 'd0;
	end
	always @(posedge clk) begin
		if(counter_clk == 'd499) begin
			counter_clk <= 'd0;
			clk_en = 1;
		end else begin
			counter_clk <= counter_clk + 1;
			clk_en <= 0;
		end
	end
	always @(posedge clk_en) begin

		if(data < 12'b000000000010 && mode == 2'b00) begin
			counter <= counter + 'd1;
		end else if(data > 12'b000000000010 && mode == 2'b00) begin
			freq_int <= freq_const / counter;
			freq_out <= freq_int[31:0]; //
			counter <= 'd1;
			mode <= 2'b11;
		end else if(data > 12'b000000000010 && mode == 2'b11) begin
			counter <= counter + 'd1;
			mode <= 2'b01;
		end else if(data > 12'b000000000010 && mode == 2'b01) begin
			counter <= counter + 'd1;
		end else if(data < 12'b000000000010 && mode == 2'b01) begin
			counter <= counter + 'd1;
			mode <= 2'b00;
		end
	end
endmodule

module p2p_tb ();
	reg clk;
	reg[11: 0] data;
	wire[11: 0] freq_out;

	frequency_finder DUT (clk, data, freq_out);

	always begin
		clk = 0; #1000; clk = 1; #1000;
	end

	initial begin
		data = 12'b0; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;
		data = data + 1; // V = 1
		#8000000;
		data = data + 1; // V = 2
		#8000000;
		data = data + 1; // V = 3
		#8000000;
		data = data + 1; // V = 4
		#8000000;
		data = data - 1; // V = 3
		#8000000;
		data = data - 1; // V = 2
		#8000000;
		data = data - 1; // V = 1
		#8000000;
		data = data - 1; // V = 0
		#8000000;

	end
endmodule // p2p_tb
