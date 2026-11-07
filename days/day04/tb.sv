`timescale 1ns/1ps
module tb;
reg [7:0] pixel; reg signed [7:0] coeff;
wire signed [19:0] product;
integer p,c,expected;
pixel_product dut(.pixel(pixel),.coeff(coeff),.product(product));
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

for(p=0;p<256;p=p+1) for(c=-128;c<128;c=c+1) begin
    pixel=p; coeff=c; expected=p*c; #1;
    if(product !== expected) $fatal(1,"product %0d*%0d got=%0d expected=%0d",p,c,product,expected);
end
    $display("PASS day04"); $finish;
end
endmodule
