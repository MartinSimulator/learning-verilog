`timescale 1ns/1ps
`default_nettype none
module pixel_clamp(
    input wire signed [19:0] value,
    output reg [7:0] pixel
);
always @* begin
    pixel = 8'd0; // TODO: complete clamp
end
endmodule
`default_nettype wire
