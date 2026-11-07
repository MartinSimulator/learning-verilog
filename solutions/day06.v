`timescale 1ns/1ps
`default_nettype none
module burst9(
    input wire clk, rst, in_valid, out_ready,
    output wire in_ready, out_valid
);
localparam COLLECT=1'b0, HOLD=1'b1;
reg state;
reg [3:0] count;
assign in_ready = !rst && (state == COLLECT);
assign out_valid = !rst && (state == HOLD);
always @(posedge clk) begin
    if (rst) begin state <= COLLECT; count <= 0; end
    else if (state == HOLD) begin
        if (out_ready) begin state <= COLLECT; count <= 0; end
    end else if (in_valid && in_ready) begin
        if (count == 4'd8) state <= HOLD;
        else count <= count + 1'b1;
    end
end
endmodule
`default_nettype wire
