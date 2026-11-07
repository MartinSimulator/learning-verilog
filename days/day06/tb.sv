`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk;
reg rst=0,in_valid=0,out_ready=0;
wire in_ready,out_valid;
integer count=0,holding=0,i,seed=345;
burst9 dut(.clk(clk),.rst(rst),.in_valid(in_valid),.out_ready(out_ready),.in_ready(in_ready),.out_valid(out_valid));
task step(input integer r,v,ready);
begin
    @(negedge clk); rst=r; in_valid=v; out_ready=ready; #1;
    if(in_ready !== (!r && !holding) || out_valid !== (!r && holding)) $fatal(1,"controller pre-edge outputs");
    if(r) begin count=0; holding=0; end
    else if(holding) begin if(ready) begin holding=0;count=0;end end
    else if(v) begin
        count=count+1;
        if(count==9) holding=1;
    end
    @(posedge clk); #1;
    if(in_ready !== (!r && !holding) || out_valid !== (!r && holding)) $fatal(1,"controller post-edge outputs");
end endtask
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

step(1,1,1);
for(i=0;i<9;i=i+1) begin step(0,0,0); step(0,1,0); end
repeat(4) step(0,1,0);
step(0,1,1); // input ignored while consuming held output
for(i=0;i<500;i=i+1) step(i==177,$random(seed)&1,$random(seed)&1);
step(1,1,1);
    $display("PASS day06"); $finish;
end
endmodule
