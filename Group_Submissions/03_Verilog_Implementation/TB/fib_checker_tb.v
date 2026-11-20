`timescale 1ns/1ps
module tb_fib_checker;
    reg clk;
    reg reset;
    reg start;
    reg ack;
    reg input_valid;
    reg [3:0] x;
    wire fib_led, nonfib_led, error_led;
    integer i;
    integer errors;
    reg expected;

    fib_checker_top dut (
        .clk(clk), .reset(reset), .start(start), .ack(ack),
        .input_valid(input_valid), .x(x),
        .fib_led(fib_led), .nonfib_led(nonfib_led), .error_led(error_led)
    );

    // 100 MHz clock
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        errors = 0;
        reset = 1; start = 0; ack = 0; input_valid = 0; x = 4'd0;
        #22;
        reset = 0;

        for (i = 0; i < 16; i = i + 1) begin
            x = i;
            input_valid = 1;
            @(negedge clk); start = 1;
            @(negedge clk); start = 0;
            @(negedge clk);

            if (i == 0 || i == 1 || i == 2 || i == 3 || i == 5 || i == 8 || i == 13)
                expected = 1;
            else
                expected = 0;

            if (fib_led !== expected || nonfib_led !== ~expected || error_led !== 1'b0) begin
                $display("FAIL x=%0d fib=%b nonfib=%b err=%b", i, fib_led, nonfib_led, error_led);
                errors = errors + 1;
            end else begin
                $display("PASS x=%0d fib=%b nonfib=%b", i, fib_led, nonfib_led);
            end

            ack = 1; @(negedge clk);
            ack = 0; @(negedge clk);
        end

        // error test: start pressed while input_valid = 0
        input_valid = 0; x = 4'd5;
        @(negedge clk); start = 1;
        @(negedge clk); start = 0;
        @(negedge clk);
        if (error_led !== 1'b1) begin
            $display("FAIL error test");
            errors = errors + 1;
        end else begin
            $display("PASS error test");
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d errors", errors);
        $finish;
    end
endmodule
