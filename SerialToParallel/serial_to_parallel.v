module serial_to_parallel(clk,reset,serial_in,parallel_out);
input clk, reset, serial_in;
output reg [11:0] parallel_out;
initial
begin
parallel_out <= 12'b0;
end
always @(posedge clk)
if (reset == 1)
begin
parallel_out <= 12'b0;
end
else parallel_out <= {parallel_out[10:0],serial_in}; //concentration
endmodule
