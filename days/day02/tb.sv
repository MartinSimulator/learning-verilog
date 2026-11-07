`timescale 1ns/1ps
module tb;
reg signed [19:0] value; wire [7:0] pixel;
integer i, expected;
pixel_clamp dut(.value(value),.pixel(pixel));
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

for(i=-524288;i<=524287;i=i+1) begin
    value=i; expected=(i<0) ? 0 : ((i>255) ? 255 : i); #1;
    if(pixel !== expected) $fatal(1,"clamp input=%0d got=%0d expected=%0d",i,pixel,expected);
end
    $display("PASS day02"); $finish;
end
endmodule
