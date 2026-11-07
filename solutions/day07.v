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
wire signed [8:0] pixel_s = $signed({1'b0,pixel});
wire signed [16:0] prod = pixel_s * coeff;
wire signed [19:0] product = {{3{prod[16]}},prod};
reg signed [19:0] acc;
reg [3:0] count;
reg holding;
assign in_ready = !rst && !holding;
assign out_valid = !rst && holding;
always @(posedge clk) begin
    if (rst) begin acc <= 0; count <= 0; holding <= 0; result <= 0; end
    else if (holding) begin
        if (out_ready) begin holding <= 0; count <= 0; acc <= 0; end
    end else if (in_valid && in_ready) begin
        if (count == 4'd8) begin
            result <= acc + product;
            holding <= 1;
        end else begin
            acc <= acc + product;
            count <= count + 1'b1;
        end
    end
end
endmodule
`default_nettype wire
