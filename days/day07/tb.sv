`timescale 1ns/1ps
module tb;
reg clk=0; always #5 clk=~clk;
reg rst=0,in_valid=0,out_ready=0;
reg [7:0] pixel=0; reg signed [7:0] coeff=0;
wire in_ready,out_valid; wire signed [19:0] result;
integer f,g,rc,rg,p,c,expected,n,i,j,seed=456;
integer model_count=0,model_acc=0,model_hold=0,model_result=0;
mac9 dut(.clk(clk),.rst(rst),.in_valid(in_valid),.pixel(pixel),.coeff(coeff),.in_ready(in_ready),.out_valid(out_valid),.out_ready(out_ready),.result(result));
task step(input integer r,v,px,cf,ready);
begin
    @(negedge clk); rst=r; in_valid=v; pixel=px; coeff=cf; out_ready=ready; #1;
    if(in_ready !== (!r && !model_hold) || out_valid !== (!r && model_hold)) $fatal(1,"MAC pre-edge handshake");
    if(!r && model_hold && result !== model_result) $fatal(1,"MAC changed pending result");
    if(r) begin model_count=0;model_acc=0;model_hold=0;model_result=0;end
    else if(model_hold) begin
        if(ready) begin model_count=0;model_acc=0;model_hold=0;end
    end else if(v) begin
        model_acc=model_acc+px*cf;
        model_count=model_count+1;
        if(model_count==9) begin model_hold=1;model_result=model_acc;end
    end
    @(posedge clk); #1;
    if(in_ready !== (!r && !model_hold) || out_valid !== (!r && model_hold)) $fatal(1,"MAC post-edge handshake");
    if(model_hold && result !== model_result) $fatal(1,"MAC got=%0d expected=%0d",result,model_result);
end endtask
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

step(1,0,0,0,0);
f=$fopen("pairs.txt","r"); g=$fopen("expected.txt","r");
if(!f || !g) $fatal(1,"missing vectors: run scripts/run.py 7");
rg=$fscanf(g,"%d",n);
if(rg!=1) $fatal(1,"missing case count");
for(i=0;i<n;i=i+1) begin
    for(j=0;j<9;j=j+1) begin
        rc=$fscanf(f,"%d %d",p,c); if(rc!=2) $fatal(1,"short pair file");
        if($random(seed)&1) step(0,0,0,0,0);
        step(0,1,p,c,0);
    end
    rg=$fscanf(g,"%d",expected); if(rg!=1) $fatal(1,"short expected file");
    if(result !== expected || out_valid !== 1'b1) $fatal(1,"Python case %0d mismatch",i);
    repeat(3) step(0,0,255,-128,0); // hold output under backpressure
    step(0,0,255,-128,1); // consume output; no input transfer
end
$fclose(f); $fclose(g);
// Reset aborts a partial window.
repeat(4) step(0,1,255,127,0);
step(1,0,0,0,0);
repeat(9) step(0,1,1,1,0);
if(result !== 20'sd9) $fatal(1,"partial reset leaked data");
// Reset also discards a pending result.
step(1,1,255,-128,0); step(0,0,0,0,0);
repeat(9) step(0,1,255,-128,0);
if(result !== -20'sd293760) $fatal(1,"negative extreme");
step(0,0,0,0,1);
    $display("PASS day07"); $finish;
end
endmodule
