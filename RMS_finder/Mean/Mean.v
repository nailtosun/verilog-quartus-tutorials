module Mean(clk,period,serial_square_in,mean);
input [31:0] serial_square_in;
input clk;
input [31:0] period; //how many clock hit in one period
output reg [31:0] mean;

integer period_discrete, counter, sum;
initial
begin
period_discrete<=0;
counter <= 0;
sum <= 0;
end


always @(posedge clk)
begin
period_discrete <= period/1; //1ns for testing real value 20ns 

if (counter < period_discrete)
	begin
		sum <= sum + serial_square_in;
		counter <= counter + 1;
	end
else if (counter == period_discrete)
	begin
		mean <= sum/period;
		sum <= 0;
		counter <= 0;
	end
end

endmodule