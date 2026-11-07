`timescale 1ns/1ps
`default_nettype none
module pixel_mux(
    input wire [7:0] a, b,
    input wire sel,
    output wire [7:0] y,
    output wire [8:0] sum
);
assign y = sel ? b : a;
assign sum = {1'b0,a} + {1'b0,b};
endmodule
`default_nettype wire
