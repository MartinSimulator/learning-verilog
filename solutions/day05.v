`timescale 1ns/1ps
`default_nettype none
module pipe_madd(
    input wire clk, rst, in_valid,
    input wire [7:0] pixel,
    input wire signed [7:0] coeff, bias,
    output reg out_valid,
    output reg signed [19:0] result
);
wire signed [8:0] pixel_s = $signed({1'b0,pixel});
wire signed [16:0] prod = pixel_s * coeff;
reg signed [19:0] prod1, bias1;
reg valid1;
always @(posedge clk) begin
    if (rst) begin
        prod1 <= 0; bias1 <= 0; valid1 <= 0;
        result <= 0; out_valid <= 0;
    end else begin
        prod1 <= {{3{prod[16]}},prod};
        bias1 <= {{12{bias[7]}},bias};
        valid1 <= in_valid;
        result <= prod1 + bias1;
        out_valid <= valid1;
    end
end
endmodule
`default_nettype wire
