`timescale 1ns/1ps
`default_nettype none
module pipe_madd(
    input wire clk, rst, in_valid,
    input wire [7:0] pixel,
    input wire signed [7:0] coeff, bias,
    output reg out_valid,
    output reg signed [19:0] result
);
// TODO: product register, matching bias register, stage-valid register
always @(posedge clk) begin
    if (rst) begin result <= 0; out_valid <= 0; end
    else begin result <= 0; out_valid <= 0; end
end
endmodule
`default_nettype wire
