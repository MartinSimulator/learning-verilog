`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk;
reg rst=0,in_valid=0; reg [7:0] pixel=0; reg signed [7:0] coeff=0,bias=0;
wire out_valid; wire signed [19:0] result;
integer pending_valid=0,pending_value=0,i,seed=234;
pipe_madd dut(.clk(clk),.rst(rst),.in_valid(in_valid),.pixel(pixel),.coeff(coeff),.bias(bias),.out_valid(out_valid),.result(result));
task step(input integer r,v,p,c,b);
integer expected_valid,expected_value;
begin
    @(negedge clk); rst=r; in_valid=v; pixel=p; coeff=c; bias=b;
    expected_valid=r ? 0 : pending_valid;
    expected_value=pending_value;
    pending_valid=r ? 0 : v;
    pending_value=p*c+b;
    @(posedge clk); #1;
    if(out_valid !== expected_valid) $fatal(1,"pipeline valid misaligned");
    if(expected_valid && result !== expected_value)
        $fatal(1,"pipeline result=%0d expected=%0d",result,expected_value);
end endtask
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

step(1,0,0,0,0);
step(0,1,255,-128,-128); step(0,1,3,4,7); step(0,0,9,9,9);
step(0,1,255,127,127); step(1,1,10,10,10); step(0,0,0,0,0);
for(i=0;i<100;i=i+1) step(i==45,$random(seed)&1,$random(seed)&255,($random(seed)&255)-128,($random(seed)&255)-128);
step(0,0,0,0,0); step(0,0,0,0,0);
    $display("PASS day05"); $finish;
end
endmodule
