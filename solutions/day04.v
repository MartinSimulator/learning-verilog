`timescale 1ns/1ps
`default_nettype none
module pixel_product(
    input wire [7:0] pixel,
    input wire signed [7:0] coeff,
    output wire signed [19:0] product
);
wire signed [8:0] pixel_s = $signed({1'b0,pixel});
wire signed [16:0] full_product = pixel_s * coeff;
assign product = {{3{full_product[16]}},full_product};
endmodule
`default_nettype wire
