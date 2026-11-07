`timescale 1ns/1ps
`default_nettype none
module shift3(
    input wire clk, rst, en,
    input wire [7:0] pixel,
    output reg [7:0] q0, q1, q2
);
always @(posedge clk) begin
    if (rst) begin q0 <= 0; q1 <= 0; q2 <= 0; end
    // TODO: enabled shift; otherwise hold
end
endmodule
`default_nettype wire
