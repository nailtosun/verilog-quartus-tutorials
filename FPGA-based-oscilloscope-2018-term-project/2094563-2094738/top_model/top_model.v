module top_model(clock, reset, ADC_CS_N, ADC_DIN, ADC_SCLK, ADC_DOUT, vga_R, vga_G,
vga_B, vga_clk, vga_blank, vga_sync, h_sync, v_sync);

	output [7:0] vga_R, vga_G, vga_B;
	//output wire [7:0] vga_r, vga_g, vga_b;
	output wire vga_clk, vga_blank, vga_sync, h_sync, v_sync;
	input clock, reset;
	output wire ADC_CS_N;         // ADC chip selection
	output wire  ADC_DIN;          // ADC serial data in (to ADC)
	output wire ADC_SCLK;         // ADC serial clock
	input ADC_DOUT;              // ADC serial data out (from ADC)
	wire [11:0] serial_parallel_data;
	wire [11:0] signal_amplitude;
	wire  [11:0] signal_offset;
	wire  [31:0] signal_frequency;


ADC system_1(.clock(clock), .reset(reset), .ADC_CS_N(ADC_CS_N), .ADC_DIN(ADC_DIN), .ADC_SCLK(ADC_SCLK), .ADC_DOUT(ADC_DOUT), .serial_parallel_data(serial_parallel_data));

magnitude_finder system_2(.magnitude_in(serial_parallel_data), .clk(clock), .dc_offset(signal_offset), .amplitude(signal_amplitude));

frequency_finder system_3(.clk(clock), .data(serial_parallel_data), .freq_out(signal_frequency));

VGA system_4(.peak_to_peak(signal_amplitude), .offset(signal_offset), .freq(signal_frequency),.clk(clock), .h_sync(h_sync), .v_sync(v_sync),
.vga_R(vga_R), .vga_G(vga_G), .vga_B(vga_B), .vga_clk(vga_clk), .vga_blank(vga_blank), .vga_sync(vga_sync));

endmodule
