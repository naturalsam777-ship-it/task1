`timescale 1ns/1ps
`default_nettype none
module full_adder_top (
    input  wire btn_a_n,
    input  wire btn_b_n,
    input  wire btn_cin_n,
    output wire led_s_n,
    output wire led_cout_n
);
    wire a, b, cin;
    wire s, cout;
    // Board buttons are active-low; internal values are logical button states.
    assign a   = ~btn_a_n;
    assign b   = ~btn_b_n;
    assign cin = ~btn_cin_n;
    assign s    = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
    // A logical one must illuminate the active-low LED.
    assign led_s_n    = ~s;
    assign led_cout_n = ~cout;
endmodule
`default_nettype wire
