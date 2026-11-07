`timescale 1ns/1ps
`default_nettype none
module mac9(
    input wire clk, rst, in_valid,
    input wire [7:0] pixel,
    input wire signed [7:0] coeff,
    output wire in_ready,
    output wire out_valid,
    input wire out_ready,
    output reg signed [19:0] result
);
assign in_ready = 1'b0; // TODO
assign out_valid = 1'b0; // TODO
always @(posedge clk) begin
    if (rst) result <= 0;
    // TODO: accumulate accepted pairs and retain completed result
end
endmodule
`default_nettype wire
