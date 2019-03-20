//Needed rms input
module waveform_finder(clk,amplitude,rms,waveform);
input clk;
input [31:0] amplitude;
input [31:0] rms;
output reg [1:0] waveform;
// 00 dc
// 01 square
// 10 sinus
// 11 triangular
reg [31:0] ratio; // for determining multiplying constant with rms and amplitude

always @(posedge clk)
begin
if(ratio>55)//dc
  begin
    waveform<=2'b0;
  end
else if(ratio>45)//square
  begin
    waveform<=2'b01;
    end
else if(ratio>32) //sinus
  begin
    waveform <=2'b10;
  end
else //triangular
  begin
    waveform <=2'b11;
  end
  ratio <=(100*rms)/amplitude;
  end
endmodule
