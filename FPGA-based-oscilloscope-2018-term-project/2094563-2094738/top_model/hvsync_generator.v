//VGA Synchronization
//Last version 25 Mhz clock due to 800x525 60hz
module hvsync_generator(clk, h_sync, v_sync, display_area,counter_x,counter_y);
input clk;
output h_sync,v_sync;
output reg display_area;
output reg [9:0] counter_x;
output reg [8:0] counter_y;
reg vga_HS, vga_VS;
wire x_max = (counter_x == 800); // 16 + 48 + 96 + 640
wire y_max = (counter_y == 525); // 10 + 2 + 33 + 480

always @(posedge clk)
  if (x_max) counter_x <= 0;
  else counter_x <= counter_x + 1; //counter for horizontal writing
always @(posedge clk)
  begin
    if (x_max)
    begin
      if(y_max)
        counter_y <= 0;
      else counter_y <= counter_y + 1; //counter for vertical sweep
    end
  end

always @(posedge clk)
  begin
    vga_HS <= ~(counter_x > (640 + 16) && (counter_x < (640 + 16 + 96)));   // active for 96 clocks
    vga_VS <= ~(counter_y > (480 + 10) && (counter_y < (480 + 10 + 2)));   // active for 2 clocks
  end

always @(posedge clk)
  begin
    display_area <= (counter_x < 640) && (counter_y < 480); //display settings
  end
    assign h_sync = vga_HS; //assigning
    assign v_sync = vga_VS;
endmodule