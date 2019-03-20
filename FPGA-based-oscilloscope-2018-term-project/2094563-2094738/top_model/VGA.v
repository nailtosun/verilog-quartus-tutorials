//Top level connections done
//Buggy vertical lines??? --fixed
//Wave templates added --deleted
//Frequency digits added (buggy 4096 overflow) NOT FIXED
//peak to peak values digits added
//dc offset digits added (buggy) --fixed
module VGA(peak_to_peak,offset,freq,clk, h_sync, v_sync, vga_R, vga_G, vga_B, vga_clk, vga_blank, vga_sync);
input clk;
input wire [11:0] peak_to_peak,offset,freq;
output h_sync, v_sync, vga_clk, vga_blank, vga_sync;
output reg [7:0] vga_R,vga_G,vga_B;
wire display_area;
wire [9:0] counter_x;
wire [8:0] counter_y;
reg [7:0] red,blue,green;
integer peak_digit1,peak_digit2;
integer rms_digit1,rms_digit2;
integer dc_offset_digit1,dc_offset_digit2;
//frequency digits
integer freq_digit1,freq_digit2,freq_digit3,freq_digit4,freq_digit5;
reg [31:0] peak_reg;
reg [31:0] offset_reg;
reg [31:0] freq_reg;

integer a1,a2,a3,a4,a5,a6,a7,a8;
integer b1,b2,b3,b4,b5,b6,b7;
integer c1,c2,c3,c4,c5,c6,c7,c8;
integer d1,d2,d3,d4,d5,d6,d7;
integer e1,e2,e3,e4,e5,e6,e7,e8;
integer f1,f2,f3,f4,f5,f6,f7;
integer g1,g2,g3,g4,g5,g6,g7;
integer h1,h2,h3,h4,h5,h6,h7;
integer k1,k2,k3,k4,k5,k6,k7;
integer l1,l2,l3,l4,l5,l6,l7;
integer m1,m2,m3,m4,m5,m6,m7;
integer n1,n2,n3,n4,n5,n6,n7;
integer p1,p2,p3,p4,p5,p6,p7;
integer r1,r2,r3,r4,r5,r6,r7;
integer S1,S2,S3,S4,S5,S6,S7;
integer u1,u2,u3,u4,u5,u6,u7;
integer t1,t2,t3,t4,t5,t6,t7;
integer v1,v2,v3,v4,v5,v6,v7,v8;
integer y1,y2,y3,y4,y5,y6,y7;
integer clk_1s;
integer count;
integer clk_2;
integer vga_25;
initial begin
clk_2 = clk;
clk_1s=0;
end
///vga clk
always @(posedge clk)
begin
	vga_25 <= ~vga_25;
end
always @(posedge clk_2)
begin
	if(count==60) begin
		count <= 0;
		clk_1s <= ~clk_1s;
	end
		count <= count +1;
end

// module connection
hvsync_generator(.clk(vga_clk), .h_sync(h_sync), .v_sync(v_sync),
                            .display_area(display_area), .counter_x(counter_x), .counter_y(counter_y));
always @(*) begin
	peak_reg =(50*peak_to_peak)/4096;
	peak_digit1 = peak_reg/10;
	peak_digit2 = peak_reg%10;
	offset_reg = (50*offset)/4096;
	dc_offset_digit1 = offset_reg/10;
	dc_offset_digit2 = offset_reg%10;
	freq_digit5 = freq%10;
	freq_digit4 = (freq/10)%10;
	freq_digit3 = (freq/100)%10;
	freq_digit2 = (freq/1000);
	freq_digit1 = (freq/10000);
end
// Margins
always @(posedge vga_clk)
begin
  if(display_area)begin
		if(counter_y==0 || counter_y==479)
		begin
			if(0<=counter_x && counter_x<680)
			begin
				green <= 8'h00;red <= 8'hFF;blue <= 8'h00;		// top
			end
			else
			begin
				red <= 8'h00;green <= 8'h00;blue <= 8'h00;
			end
		end
		if(counter_x==0 || counter_x==679) //right and left side
		begin
			if(0<=counter_y && counter_y<480)
			begin
				green <= 8'h00;red <= 8'hFF;blue <= 8'h00;
			end
			end
		else red <= 8'h00;green <= 8'h00;blue <= 8'h00;
		if((counter_y ==439))
			begin
			if(50 < counter_x && counter_x< 601)
			begin
				green <= 8'hFF;red <= 8'hFF;blue <= 8'h00;
			end
			else
			begin
				red <= 8'h00;green <= 8'h00;blue <= 8'h00;
			end
			end

		if((counter_x == 41))//vertical lines
			begin
			if(40<counter_y && counter_y<440)
			begin
			green <= 8'hFF;red <= 8'hFF;blue <= 8'h00;
			end
			else
			begin
			red <= 8'h00;green <= 8'h00;blue <= 8'h00;
			end
			end
		if(41<counter_x && counter_x<51)
			begin
			if(counter_y==41 || counter_y==80 || counter_y==120 || counter_y==160 || counter_y==200 || counter_y==240 || counter_y==280
						|| counter_y==320 || counter_y==360 || counter_y==400 || counter_y==439)
						begin
						green <= 8'hFF;red <= 8'h00;blue <= 8'h00;
						end
			else red <= 8'h00;green <= 8'h00;blue <= 8'h00;
			end

		if(430<counter_y && counter_y<439) begin   // Dikey centikler
			if(counter_x==41 || counter_x==80 || counter_x==120 || counter_x==160 || counter_x==200 || counter_x==240 || counter_x==280 ||
						counter_x==320 || counter_x==360 || counter_x==400 || counter_x==440 || counter_x==480 || counter_x==520 || counter_x==560 || counter_x==600)
						begin
							green <= 8'hFF;red <= 8'h00;blue <= 8'h00;
						end
				else red <= 8'h00;green <= 8'h00;blue <= 8'h00;
			end
		// Peak to Peak
			case(peak_digit1)
			0: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = (counter_x==79  && (counter_y>459 && counter_y<471));
				a6 = (counter_x==79  && (counter_y>449 && counter_y<460));
				a7 = 0;
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			1: begin
				a1 = 0;
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = 0;
				a5 = 0;
				a6 = 0;
				a7 = 0;
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			2: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = 0;
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = (counter_x==79  && (counter_y>459 && counter_y<471));
				a6 = 0;
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			3: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = 0;
				a6 = 0;
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			4: begin
				a1 = 0;
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = 0;
				a5 = 0;
				a6 = (counter_x==79  && (counter_y>449 && counter_y<460));
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			5: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = 0;
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = 0;
				a6 = (counter_x==79  && (counter_y>449 && counter_y<460));
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end

			6: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = 0;
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = (counter_x==79  && (counter_y>459 && counter_y<471));
				a6 = (counter_x==79  && (counter_y>449 && counter_y<460));
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			7: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = 0;
				a5 = 0;
				a6 = 0;
				a7 = 0;
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			8: begin
				a1 = (counter_y==450 && (counter_x>79  && counter_x<91));
				a2 = (counter_x==90  && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90  && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79  && counter_x<91));
				a5 = (counter_x==79  && (counter_y>459 && counter_y<471));
				a6 = (counter_x==79  && (counter_y>449 && counter_y<460));
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			9: begin
				a1 = (counter_y==450 && (counter_x>79 && counter_x<91));
				a2 = (counter_x==90 && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90 && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79 && counter_x<91));
				a5 = 0;
				a6 = (counter_x==79 && (counter_y>449 && counter_y<460));
				a7 = (counter_y==460 && (counter_x>79  && counter_x<91));
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
			default: begin
				a1 = (counter_y==450 && (counter_x>79 && counter_x<91));
				a2 = (counter_x==90 && (counter_y>449 && counter_y<460));
				a3 = (counter_x==90 && (counter_y>459 && counter_y<471));
				a4 = (counter_y==470 && (counter_x>79 && counter_x<91));
				a5 = (counter_x==79 && (counter_y>459 && counter_y<471));
				a6 = (counter_x==79 && (counter_y>449 && counter_y<460));
				a7 = 0;
				a8 = ((468<counter_y && counter_y<471) && (counter_x>93 && counter_x<96));
			end
		endcase
		//Peak to Peak

			case(peak_digit2)
			0: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = (counter_x==98 && (counter_y>459 && counter_y<471));
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = 0;
			end
			1: begin
				b1 = 0;
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = 0;
				b5 = 0;
				b6 = 0;
				b7 = 0;
			end
			2: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = 0;
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = (counter_x==98 && (counter_y>459 && counter_y<471));
				b6 = 0;
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			3: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = 0;
				b6 = 0;
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			4: begin
				b1 = 0;
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = 0;
				b5 = 0;
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			5: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = 0;
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = 0;
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end

			6: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = 0;
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = (counter_x==98 && (counter_y>459 && counter_y<471));
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			7: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = 0;
				b5 = 0;
				b6 = 0;
				b7 = 0;
			end
			8: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = (counter_x==98 && (counter_y>459 && counter_y<471));
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			9: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = 0;
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
			default: begin
				b1 = (counter_y==450 && (counter_x>98  && counter_x<108));
				b2 = (counter_x==108 && (counter_y>449 && counter_y<460));
				b3 = (counter_x==108 && (counter_y>459 && counter_y<471));
				b4 = (counter_y==470 && (counter_x>98 && counter_x<108));
				b5 = (counter_x==98 && (counter_y>459 && counter_y<471));
				b6 = (counter_x==98 && (counter_y>449 && counter_y<460));
				b7 = (counter_y==460 && (counter_x>98  && counter_x<108));
			end
		endcase
		// RMS
		case(rms_digit1)
			0:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = (counter_x==158 && (counter_y>459 && counter_y<471));
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = 0;
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			1:begin
				c1 = 0;
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = 0;
				c5 = 0;
				c6 = 0;
				c7 = 0;
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			2:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = 0;
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = (counter_x==158 && (counter_y>459 && counter_y<471));
				c6 = 0;
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			3:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = 0;
				c6 = 0;
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			4:begin
				c1 = 0;
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = 0;
				c5 = 0;
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			5:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = 0;
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = 0;
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			6:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = 0;
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = (counter_x==158 && (counter_y>459 && counter_y<471));
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			7:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = 0;
				c5 = 0;
				c6 = 0;
				c7 = 0;
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			8:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = (counter_x==158 && (counter_y>459 && counter_y<471));
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			9:begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = 0;
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = (counter_y==460 && (counter_x>158  && counter_x<168));
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
			end
			default: begin
				c1 = (counter_y==450 && (counter_x>158  && counter_x<168));
				c2 = (counter_x==168 && (counter_y>449 && counter_y<460));
				c3 = (counter_x==168 && (counter_y>459 && counter_y<471));
				c4 = (counter_y==470 && (counter_x>158 && counter_x<168));
				c5 = (counter_x==158 && (counter_y>459 && counter_y<471));
				c6 = (counter_x==158 && (counter_y>449 && counter_y<460));
				c7 = 0;
				c8 = ((468<counter_y && counter_y<471) && (counter_x>170 && counter_x<173));
				end
		endcase
		case(rms_digit2)
			0: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = (counter_x==177 && (counter_y>459  && counter_y<471));
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = 0;
				end
			1: begin
				d1 = 0;
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = 0;
				d5 = 0;
				d6 = 0;
				d7 = 0;
				end
			2: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = 0;
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = (counter_x==177 && (counter_y>459  && counter_y<471));
				d6 = 0;
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			3: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = 0;
				d6 = 0;
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			4: begin
				d1 = 0;
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = 0;
				d5 = 0;
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			5: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = 0;
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = 0;
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			6: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = 0;
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = (counter_x==177 && (counter_y>459  && counter_y<471));
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			7: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = 0;
				d5 = 0;
				d6 = 0;
				d7 = 0;
				end
			8: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = (counter_x==177 && (counter_y>459  && counter_y<471));
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end
			9: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = 0;
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end

			default: begin
				d1 = (counter_y==450 && (counter_x>177  && counter_x<187));
				d2 = (counter_x==187 && (counter_y>449  && counter_y<460));
				d3 = (counter_x==187 && (counter_y>459  && counter_y<471));
				d4 = (counter_y==470 && (counter_x>177  && counter_x<187));
				d5 = (counter_x==177 && (counter_y>459  && counter_y<471));
				d6 = (counter_x==177 && (counter_y>449  && counter_y<460));
				d7 = (counter_y==460 && (counter_x>177  && counter_x<187));
				end

		endcase

		//Offset
		case(dc_offset_digit1)
			0: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = (counter_x==247 && (counter_y>459  && counter_y<471));
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = 0;
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			1: begin
				e1 = 0;
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = 0;
				e5 = 0;
				e6 = 0;
				e7 = 0;
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			2: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = 0;
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = (counter_x==247 && (counter_y>459  && counter_y<471));
				e6 = 0;
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			3: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = 0;
				e6 = 0;
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			4: begin
				e1 = 0;
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = 0;
				e5 = 0;
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			5: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = 0;
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = 0;
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			6: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = 0;
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = (counter_x==247 && (counter_y>459  && counter_y<471));
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			7: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = 0;
				e5 = 0;
				e6 = 0;
				e7 = 0;
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			8: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = (counter_x==247 && (counter_y>459  && counter_y<471));
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			9: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = 0;
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
			default: begin
				e1 = (counter_y==450 && (counter_x>247  && counter_x<257));
				e2 = (counter_x==257 && (counter_y>449  && counter_y<460));
				e3 = (counter_x==257 && (counter_y>459  && counter_y<471));
				e4 = (counter_y==470 && (counter_x>247  && counter_x<257));
				e5 = (counter_x==247 && (counter_y>459  && counter_y<471));
				e6 = (counter_x==247 && (counter_y>449  && counter_y<460));
				e7 = (counter_y==460 && (counter_x>247  && counter_x<257));
				e8 = ((468<counter_y && counter_y<471)  && (counter_x>260 && counter_x<263));
			end
		endcase

		case(dc_offset_digit2)
			0: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = (counter_x==268 && (counter_y>459  && counter_y<471));
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = 0;
			end
			1: begin
				f1 = 0;
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = 0;
				f5 = 0;
				f6 = 0;
				f7 = 0;
			end
			2: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = 0;
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = (counter_x==268 && (counter_y>459  && counter_y<471));
				f6 = 0;
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			3: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = 0;
				f5 = 0;
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			4: begin
				f1 = 0;
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = 0;
				f5 = 0;
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			5: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = 0;
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = 0;
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			6: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = 0;
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = (counter_x==268 && (counter_y>459  && counter_y<471));
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			7: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = 0;
				f5 = 0;
				f6 = 0;
				f7 = 0;
			end
			8: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = (counter_x==268 && (counter_y>459  && counter_y<471));
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			9: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = 0;
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
			default: begin
				f1 = (counter_y==450 && (counter_x>268  && counter_x<278));
				f2 = (counter_x==278 && (counter_y>449  && counter_y<460));
				f3 = (counter_x==278 && (counter_y>459  && counter_y<471));
				f4 = (counter_y==470 && (counter_x>268  && counter_x<278));
				f5 = (counter_x==268 && (counter_y>459  && counter_y<471));
				f6 = (counter_x==268 && (counter_y>449  && counter_y<460));
				f7 = (counter_y==460 && (counter_x>268  && counter_x<278));
			end
		endcase

		//Frequency
		case(freq_digit1)
	0:begin
		k1 = (counter_y==450 && (counter_x>398 && counter_x<411));
		k2 = (counter_x==410 && (counter_y>449 && counter_y<460));
		k3 = (counter_x==410 && (counter_y>459 && counter_y<471));
		k4 = (counter_y==470 && (counter_x>398 && counter_x<411));
		k5 = (counter_x==399 && (counter_y>459 && counter_y<471));
		k6 = (counter_x==399 && (counter_y>449 && counter_y<460));
		k7 = 0;
		end


	1:begin
		k1 = 0;
		k2 = (counter_x==410 && (counter_y>449 && counter_y<460));
		k3 = (counter_x==410 && (counter_y>459 && counter_y<471));
		k4 = 0;
		k5 = 0;
		k6 = 0;
		k7 = 0;
		end


	2:begin
		k1 = (counter_y==450 && (counter_x>398 && counter_x<411));
		k2 = (counter_x==410 && (counter_y>449 && counter_y<460));
		k3 = 0;
		k4 = (counter_y==470 && (counter_x>398 && counter_x<411));
		k5 = (counter_x==399 && (counter_y>459 && counter_y<471));
		k6 = 0;
		k7 = (counter_y==460 && (counter_x>398 && counter_x<411));
		end
	3:begin
		k1 = (counter_y==450 && (counter_x>398 && counter_x<411));
		k2 = (counter_x==410 && (counter_y>449 && counter_y<460));
		k3 = (counter_x==410 && (counter_y>459 && counter_y<471));
		k4 = (counter_y==470 && (counter_x>398 && counter_x<411));
		k5 = 0;
		k6 = 0;
		k7 = (counter_y==460 && (counter_x>398 && counter_x<411));
		end
	default : begin

		k1 = (counter_y==450 && (counter_x>398 && counter_x<411));
		k2 = (counter_x==410 && (counter_y>449 && counter_y<460));
		k3 = (counter_x==410 && (counter_y>459 && counter_y<471));
		k4 = (counter_y==470 && (counter_x>398 && counter_x<411));
		k5 = (counter_x==399 && (counter_y>459 && counter_y<471));
		k6 = (counter_x==399 && (counter_y>449 && counter_y<460));
		k7 = 0;

		end
endcase

		case(freq_digit2)
	0:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = 0;
		end

	1:begin
		m1 = 0;
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = 0;
		m5 = 0;
		m6 = 0;
		m7 = 0;
		end

	2:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = 0;
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = 0;
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end
	3:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = 0;
		m6 = 0;
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end

	4:begin
		m1 = 0;
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = 0;
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = 0;
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end

	5:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = 0;
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = 0;
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end

	6:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = 0;
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end

	7:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = 0;
		m5 = 0;
		m6 = 0;
		m7 = 0;
		end

	8:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end

	9:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = 0;
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = (counter_y==460 && (counter_x>413 && counter_x<425));
		end
	default:begin
		m1 = (counter_y==450 && (counter_x>413 && counter_x<425));
		m2 = (counter_x==425 && (counter_y>449 && counter_y<460));
		m3 = (counter_x==425 && (counter_y>459 && counter_y<471));
		m4 = (counter_y==470 && (counter_x>413 && counter_x<425));
		m5 = (counter_x==413 && (counter_y>459 && counter_y<471));
		m6 = (counter_x==413 && (counter_y>449 && counter_y<460));
		m7 = 0;
		end

endcase

		case(freq_digit3)
	0:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = (counter_x==428 && (counter_y>459 && counter_y<471));
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = 0;
		end

	1:begin
		n1 = 0;
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = 0;
		n5 = 0;
		n6 = 0;
		n7 = 0;
		end

	2:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = 0;
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = (counter_x==428 && (counter_y>459 && counter_y<471));
		n6 = 0;
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end

	3:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = 0;
		n6 = 0;
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end


	4:begin
		n1 = 0;
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = 0;
		n5 = 0;
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end

	5:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = 0;
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = 0;
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end

	6:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = 0;
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = (counter_x==428 && (counter_y>459 && counter_y<471));
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end

	7:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = 0;
		n5 = 0;
		n6 = 0;
		n7 = 0;
		end
	8:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = (counter_x==428 && (counter_y>459 && counter_y<471));
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end
	9:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = 0;
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = (counter_y==460 && (counter_x>428 && counter_x<440));
		end


	default:begin
		n1 = (counter_y==450 && (counter_x>428 && counter_x<440));
		n2 = (counter_x==440 && (counter_y>449 && counter_y<460));
		n3 = (counter_x==440 && (counter_y>459 && counter_y<471));
		n4 = (counter_y==470 && (counter_x>428 && counter_x<440));
		n5 = (counter_x==428 && (counter_y>459 && counter_y<471));
		n6 = (counter_x==428 && (counter_y>449 && counter_y<460));
		n7 = 0;
		end
endcase

		case(freq_digit4)
		0:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = (counter_x==444 && (counter_y>459 && counter_y<471));
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = 0;
		end
		1:begin
			p1 = 0;
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = 0;
			p5 = 0;
			p6 = 0;
			p7 = 0;
		end
		2:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = 0;
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = (counter_x==444 && (counter_y>459 && counter_y<471));
			p6 = 0;
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		3:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = 0;
			p6 = 0;
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		4:begin
			p1 = 0;
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = 0;
			p5 = 0;
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		5:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = 0;
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = 0;
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		6:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = 0;
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = (counter_x==444 && (counter_y>459 && counter_y<471));
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		7:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = 0;
			p5 = 0;
			p6 = 0;
			p7 = 0;
		end
		8:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = (counter_x==444 && (counter_y>459 && counter_y<471));
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end
		9:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = 0;
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = (counter_y==460 && (counter_x>444 && counter_x<456));
		end

		default:begin
			p1 = (counter_y==450 && (counter_x>444 && counter_x<456));
			p2 = (counter_x==456 && (counter_y>449 && counter_y<460));
			p3 = (counter_x==456 && (counter_y>459 && counter_y<471));
			p4 = (counter_y==470 && (counter_x>444 && counter_x<456));
			p5 = (counter_x==444 && (counter_y>459 && counter_y<471));
			p6 = (counter_x==444 && (counter_y>449 && counter_y<460));
			p7 = 0;
		end
		endcase

		case(freq_digit5)

		0:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = (counter_x==458 && (counter_y>459 && counter_y<471));
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = 0;
		end
		1:begin
			r1 = 0;
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = 0;
			r5 = 0;
			r6 = 0;
			r7 = 0;
		end
		2:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = 0;
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = (counter_x==458 && (counter_y>459 && counter_y<471));
			r6 = 0;
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		3:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = 0;
			r6 = 0;
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		4:begin
			r1 = 0;
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = 0;
			r5 = 0;
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		5:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = 0;
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = 0;
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		6:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = 0;
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = (counter_x==458 && (counter_y>459 && counter_y<471));
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		7:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = 0;
			r5 = 0;
			r6 = 0;
			r7 = 0;
		end
		8:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = (counter_x==458 && (counter_y>459 && counter_y<471));
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		9:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = 0;
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = (counter_y==460 && (counter_x>458 && counter_x<470));
		end
		default:begin
			r1 = (counter_y==450 && (counter_x>458 && counter_x<470));
			r2 = (counter_x==470 && (counter_y>449 && counter_y<460));
			r3 = (counter_x==470 && (counter_y>459 && counter_y<471));
			r4 = (counter_y==470 && (counter_x>458 && counter_x<470));
			r5 = (counter_x==458 && (counter_y>459 && counter_y<471));
			r6 = (counter_x==458 && (counter_y>449 && counter_y<460));
			r7 = 0;
		end
		endcase

		vga_B <= (blue) ? 8'hFF : 0;
		vga_R <= (a1||a2||a3||a4||a5||a6||a7||a8||b1||b2||b3||b4||b5||b6||b7||c1||c2||c3||c4||c5||c6||c7||c8||d1||d2||d3||d4||d5||d6||d7
					||e1||e2||e3||e4||e5||e6||e7||e8||f1||f2||f3||f4||f5||f6||f7||k1||k2||k3||k4||k5||k6||k7||m1||m2||m3||m4||m5||m6||m7
					||n1||n2||n3||n4||n5||n6||n7||p1||p2||p3||p4||p5||p6||p7||r1||r2||r3||r4||r5||r6||r7||v1||v2||v3||v4||v5||v6||v7||v8
					||S1||S2||S3||S4||S5||S6||S7||t1||t2||t3||t4||t5||t6||t7||g1||g2||g3||g4||g5||g6||g7||h1||h2||h3||h4||h5||h6||h7
					||y1||y2||y3||y4||y5||y6||y7||l1||l2||l3||l4||l5||l6||l7||u1||u2||u3||u4||u5||u6||u7||red) ? 8'hFF : 0;

		vga_G <= (green) ? 8'hFF : 0;
  end else begin
  vga_R <= 8'h00;
  vga_G <= 8'h00;
  vga_B <= 8'h00;
  end
end
assign vga_blank = h_sync&v_sync;
assign vga_sync = (h_sync&v_sync);
assign vga_clk = vga_25;
endmodule
