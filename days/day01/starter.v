`timescale 1ns/1ps
`default_nettype none
module pixel_mux(
    input wire [7:0] a, b,
    input wire sel,
    output wire [7:0] y,
    output wire [8:0] sum
);
assign y = 8'd0; // TODO
assign sum = 9'd0; // TODO
endmodule
`default_nettype wire
