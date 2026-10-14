`timescale 1ns/1ps
`default_nettype none
module tb_full_adder;
    reg btn_a_n, btn_b_n, btn_cin_n;
    wire led_s_n, led_cout_n;
    integer checks, fd;
    full_adder_top dut (
        .btn_a_n(btn_a_n), .btn_b_n(btn_b_n), .btn_cin_n(btn_cin_n),
        .led_s_n(led_s_n), .led_cout_n(led_cout_n)
    );
    task check_case;
        input integer case_id;
        input [2:0] logical_inputs;
        input [1:0] expected_cout_s;
        begin
            {btn_a_n, btn_b_n, btn_cin_n} = ~logical_inputs;
            #1; // Allow delta-cycle settling; this is not a hardware delay model.
            if ({dut.a, dut.b, dut.cin} !== logical_inputs)
                $fatal(1, "Input polarity mismatch at case %0d", case_id);
            if ({dut.cout, dut.s} !== expected_cout_s)
                $fatal(1, "Internal result mismatch at case %0d", case_id);
            if ({led_cout_n, led_s_n} !== ~expected_cout_s)
                $fatal(1, "LED polarity mismatch at case %0d", case_id);
            $fdisplay(fd, "%0d,%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,PASS",
                case_id, $time, logical_inputs[2], logical_inputs[1], logical_inputs[0],
                btn_a_n, btn_b_n, btn_cin_n, expected_cout_s[0], expected_cout_s[1],
                dut.s, dut.cout, led_s_n, led_cout_n);
            checks = checks + 1;
            #9;
        end
    endtask
    initial begin
        $dumpfile("evidence/full_adder.vcd");
        $dumpvars(0, tb_full_adder);
        fd = $fopen("evidence/full_adder_results.csv", "w");
        if (!fd) $fatal(1, "Cannot create results file");
        $fdisplay(fd, "case,time_ns,A,B,Cin,btn_a_n,btn_b_n,btn_cin_n,expected_S,expected_Cout,actual_S,actual_Cout,led_s_n,led_cout_n,status");
        checks = 0;
        // Inputs A B Cin; expected output order is Cout S.
        check_case(0, 3'b000, 2'b00);
        check_case(1, 3'b001, 2'b01);
        check_case(2, 3'b010, 2'b01);
        check_case(3, 3'b011, 2'b10);
        check_case(4, 3'b100, 2'b01);
        check_case(5, 3'b101, 2'b10);
        check_case(6, 3'b110, 2'b10);
        check_case(7, 3'b111, 2'b11);
        $fclose(fd);
        $display("PASS: full_adder_top %0d/8 exhaustive cases", checks);
        $finish;
    end
endmodule
`default_nettype wire
