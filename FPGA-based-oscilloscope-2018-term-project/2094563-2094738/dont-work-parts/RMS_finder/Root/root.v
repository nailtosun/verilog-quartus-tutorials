module root(clk, mean_input, rms);
input clk;
input [11:0] mean_input;
output reg [11:0] rms;
reg [11:0]temp=1;

always@(posedge clk)
begin
	if((temp*temp)>=mean_input)
		rms<=temp;
   else
      temp<=temp+1;
  end
endmodule