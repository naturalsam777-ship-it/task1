`timescale 1ns/1ps
`default_nettype none
module comparator_top (
    input  wire btn_a_n,
    input  wire btn_b_n,
    output wire led_lt_n,
    output wire led_eq_n,
    output wire led_gt_n
);
    wire a, b;
    wire lt, eq, gt;
    assign a = ~btn_a_n;
    assign b = ~btn_b_n;
    assign lt = (~a) & b;
    assign eq = ~(a ^ b);
    assign gt = a & (~b);
    assign led_lt_n = ~lt;
    assign led_eq_n = ~eq;
    assign led_gt_n = ~gt;
endmodule
`default_nettype wire
