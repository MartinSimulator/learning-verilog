`timescale 1ns/1ps
`default_nettype none
module pixel_clamp(
    input wire signed [19:0] value,
    output reg [7:0] pixel
);
always @* begin
    if (value < 20'sd0) pixel = 8'd0;
    else if (value > 20'sd255) pixel = 8'd255;
    else pixel = value[7:0];
end
endmodule
`default_nettype wire
