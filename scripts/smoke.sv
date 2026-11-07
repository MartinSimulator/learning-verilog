`timescale 1ns/1ps
module tb;
reg [7:0] a=255,b=1;
wire [8:0] sum={1'b0,a}+{1'b0,b};
initial begin
    #1;
    if(sum !== 9'd256) $fatal(1,"smoke arithmetic");
    $display("PASS smoke: simulator is working"); $finish;
end
endmodule
