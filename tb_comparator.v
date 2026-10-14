`timescale 1ns/1ps
`default_nettype none
module tb_comparator;
    reg btn_a_n, btn_b_n;
    wire led_lt_n, led_eq_n, led_gt_n;
    integer checks, fd;
    comparator_top dut (
        .btn_a_n(btn_a_n), .btn_b_n(btn_b_n),
        .led_lt_n(led_lt_n), .led_eq_n(led_eq_n), .led_gt_n(led_gt_n)
    );
    task check_case;
        input integer case_id;
        input [1:0] logical_inputs;
        input [2:0] expected_lt_eq_gt;
        begin
            {btn_a_n, btn_b_n} = ~logical_inputs;
            #1;
            if ({dut.a, dut.b} !== logical_inputs)
                $fatal(1, "Input polarity mismatch at case %0d", case_id);
            if ({dut.lt, dut.eq, dut.gt} !== expected_lt_eq_gt)
                $fatal(1, "Internal result mismatch at case %0d", case_id);
            if ({led_lt_n, led_eq_n, led_gt_n} !== ~expected_lt_eq_gt)
                $fatal(1, "LED polarity mismatch at case %0d", case_id);
            if (({1'b0,dut.lt} + {1'b0,dut.eq} + {1'b0,dut.gt}) !== 2'd1)
                $fatal(1, "Outputs are not one-hot at case %0d", case_id);
            $fdisplay(fd, "%0d,%0d,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,PASS",
                case_id, $time, logical_inputs[1], logical_inputs[0], btn_a_n, btn_b_n,
                expected_lt_eq_gt[2], expected_lt_eq_gt[1], expected_lt_eq_gt[0],
                dut.lt, dut.eq, dut.gt, led_lt_n, led_eq_n, led_gt_n);
            checks = checks + 1;
            #9;
        end
    endtask
    initial begin
        $dumpfile("evidence/comparator.vcd");
        $dumpvars(0, tb_comparator);
        fd = $fopen("evidence/comparator_results.csv", "w");
        if (!fd) $fatal(1, "Cannot create results file");
        $fdisplay(fd, "case,time_ns,A,B,btn_a_n,btn_b_n,expected_LT,expected_EQ,expected_GT,actual_LT,actual_EQ,actual_GT,led_lt_n,led_eq_n,led_gt_n,status");
        checks = 0;
        // Inputs A B; expected output order is LT EQ GT.
        check_case(0, 2'b00, 3'b010);
        check_case(1, 2'b01, 3'b100);
        check_case(2, 2'b10, 3'b001);
        check_case(3, 2'b11, 3'b010);
        $fclose(fd);
        $display("PASS: comparator_top %0d/4 exhaustive cases", checks);
        $finish;
    end
endmodule
`default_nettype wire
