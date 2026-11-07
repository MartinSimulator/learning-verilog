`timescale 1ns/1ps
module tb;
reg [7:0] a,b; reg sel;
wire [7:0] y; wire [8:0] sum;
integer i,j,s;
pixel_mux dut(.a(a),.b(b),.sel(sel),.y(y),.sum(sum));
initial begin
    $dumpfile("wave.vcd"); $dumpvars(0,tb);
end
initial begin #10000000; $fatal(1,"Watchdog timeout"); end
initial begin

for(i=0;i<256;i=i+1) for(j=0;j<256;j=j+1) for(s=0;s<2;s=s+1) begin
    a=i; b=j; sel=s; #1;
    if(y !== (sel ? b : a) || sum !== (i+j))
        $fatal(1,"mux/sum a=%0d b=%0d sel=%0d y=%0d sum=%0d",a,b,sel,y,sum);
end
    $display("PASS day01"); $finish;
end
endmodule
