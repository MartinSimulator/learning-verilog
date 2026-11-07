`timescale 1ns/1ps
`default_nettype none
module pixel_product(
    input wire [7:0] pixel,
    input wire signed [7:0] coeff,
    output wire signed [19:0] product
);
assign product = 20'sd0; // TODO: signed multiply with correct widening
endmodule
`default_nettype wire
