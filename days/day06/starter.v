`timescale 1ns/1ps
`default_nettype none
module burst9(
    input wire clk, rst, in_valid, out_ready,
    output wire in_ready, out_valid
);
assign in_ready = 1'b0; // TODO
assign out_valid = 1'b0; // TODO: FSM + accepted-input counter
endmodule
`default_nettype wire
