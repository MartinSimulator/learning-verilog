`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk;
reg rst=0,en=0; reg [7:0] pixel=0;
wire [7:0] q0,q1,q2;
integer a=0,b=0,c=0,i,seed=123;
shift3 dut(.clk(clk),.rst(rst),.en(en),.pixel(pixel),.q0(q0),.q1(q1),.q2(q2));
task step(input integer r,e,p);
begin
    @(negedge clk); rst=r; en=e; pixel=p;
    if(r) begin a=0;b=0;c=0;end
    else if(e) begin c=b;b=a;a=p&255;end
    @(posedge clk); #1;
    if(q0 !== a || q1 !== b || q2 !== c) $fatal(1,"shift got=%0d,%0d,%0d expected=%0d,%0d,%0d",q0,q1,q2,a,b,c);
end endtask
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

step(1,1,99); step(0,1,10); step(0,1,20); step(0,0,99); step(0,1,30);
for(i=0;i<100;i=i+1) step(i==30,$random(seed)&1,$random(seed)&255);
step(1,1,255); step(0,0,1);
    $display("PASS day03"); $finish;
end
endmodule
