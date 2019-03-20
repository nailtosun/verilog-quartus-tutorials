module square(clk,serial_in,square_out);
input clk;
input [11:0] serial_in; 
output reg [31:0] square_out;
always @(posedge clk)
begin
square_out<=serial_in*serial_in;
end
endmodule