module ADC	#(parameter CODING = 1'b1, parameter RANGE = 1'b0) 

	(clock, reset, ADC_CS_N, ADC_DIN, ADC_SCLK, ADC_DOUT,serial_parallel_data);

	//reset should be zero // desired
	//ADC_CS_N = PIN_AJ4
	//ADC_DIN = PIN_AK4
	//ADC_SCLK = PIN_AK2
	//ADC_DOUT = PIN_AK3

	input clock, reset;

	reg [11:0] data;        //output reg       // ADC data out, 8 channels, 12 bits per channel
	// connect to top level pins
	output reg ADC_CS_N;         // ADC chip selection
	output reg ADC_DIN;          // ADC serial data in (to ADC)
	output reg ADC_SCLK;         // ADC serial clock
	input ADC_DOUT;              // ADC serial data out (from ADC)
	integer temp;

	output reg [11:0] serial_parallel_data;

	// states
	parameter QUIET0 = 3'b000, QUIET1 = 3'b001, QUIET2 = 3'b010;
	parameter CYCLE0 = 3'b100, CYCLE1 = 3'b101, CYCLE2 = 3'b110, CYCLE3 = 3'b111;

	reg [2:0] state;   // present state
	reg [2:0] addr;    // present channel address
	reg [3:0] count;   // present count
	reg [14:0] buffer; // present buffer contents

	integer counter_clk;
	reg clk;

	initial begin
		ADC_CS_N <= 1'b1;
		ADC_DIN <= 1'b0;
		ADC_SCLK <= 1'b1;
		state <= QUIET0;
		addr <= 3'b0;
		count <= 4'b0;
		buffer <= 15'b0;
		data <= 12'b0;
		temp <= 'd0;
	end

	wire [3:0] count_incr; // count + 1
	reg ctrl;              // present control bit

	assign count_incr = count + 1'b1;

	always @(*)
		case (count)
			4'b0000: // WRITE
				ctrl = 1'b1;
			4'b0001: // SEQ
				ctrl = 1'b0;
			4'b0010: // DON'T CARE
				ctrl = 1'bx;
			4'b0011: // ADD2
				ctrl = 0; //addr[2];
			4'b0100: // ADD1
				ctrl = 0; //addr[1];
			4'b0101: // ADD0
				ctrl = 0; //addr[0];
			4'b0110: // PM1
				ctrl = 1'b1;
			4'b0111: // PM0
				ctrl = 1'b1;
			4'b1000: // SHADOW
				ctrl = 1'b0;
			4'b1001: // DON'T CARE
				ctrl = 1'bx;
			4'b1010: // RANGE
				ctrl = RANGE;
			4'b1011: // CODING
				ctrl = CODING;
			default: // DON'T CARE
				ctrl = 1'bx;
		endcase

	always @(posedge clock) begin

		if(counter_clk == 'd4) begin
			counter_clk <= 'd0;
			clk = 1;
		end else begin
			counter_clk <= counter_clk + 1;
			clk <= 0;
		end

	end

	//state machine

	always @(posedge clk)
		if (reset)
			begin
				ADC_CS_N <= 1'b1;
				ADC_DIN <= 1'b0;
				ADC_SCLK <= 1'b1;
				state <= QUIET0;
				addr <= 3'b0;
				count <= 4'b0;
				buffer <= 15'b0;
				//data <= 12'b0;
			end
		else
			begin
				case (state)
					QUIET0: // first clock cycle of quiet period, xfer buffer to data
						begin
							state <= QUIET1;
							data <= buffer[11:0];
							serial_parallel_data <= data[11:0];
						end
					QUIET1:
						begin
							state <= QUIET2;
						end
					QUIET2: // end the quiet period by bringing CS low and setting up first data bit
						begin
							state <= CYCLE0;
							ADC_CS_N <= 1'b0;
							ADC_DIN <= ctrl;
							count <= count_incr;
						end
					CYCLE0: // first clock cycle of serial data xfer cycle, bring SCLK low
						begin
							state <= CYCLE1;
							ADC_SCLK <= 1'b0;
						end
					CYCLE1:
						begin
							state <= CYCLE2;
						end
					CYCLE2: // bring SCLK high
						begin
							state <= CYCLE3;
							ADC_SCLK <= 1'b1;
						end
					CYCLE3: // get data in and prepare for next cycle or transition back to quiet
						begin
							if (count == 4'b1111) // back to quiet
								begin
									state <= QUIET0;
									ADC_CS_N <= 1'b1;
									addr <= addr + 1'b1;
								end
							else
								begin
									state <= CYCLE0;
								end
							ADC_DIN <= ctrl;
							buffer <= {buffer[13:0], ADC_DOUT};
							count <= count_incr;
						end
				endcase
			end
endmodule
