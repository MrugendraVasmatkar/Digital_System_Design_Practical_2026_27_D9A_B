`timescale 1ns / 1ps

module Gray_code_tb;

    reg        clk;
    reg        reset;
    reg        start;
    reg        ack;
    reg  [3:0] x;
    wire       valid;
    wire       invalid;

    // Instantiates gray_mealy from Gray_Code.v
    gray_mealy uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .x(x),
        .valid(valid),
        .invalid(invalid)
    );

    // 10ns Clock Period
    always #5 clk = ~clk;

    task apply_and_check;
        input [3:0] test_in;
        input       exp_valid;
        begin
            @(negedge clk);
            start = 1'b1;
            x     = test_in;

            @(posedge clk);
            #1;

            if (valid == exp_valid && invalid == ~exp_valid)
                $display("Time=%0t | Input=%b | Valid=%b | Invalid=%b -> PASS", $time, x, valid, invalid);
            else
                $display("Time=%0t | Input=%b | Valid=%b | Invalid=%b -> FAIL (Expected Valid=%b)", $time, x, valid, invalid, exp_valid);
        end
    endtask

    initial begin
        clk   = 0;
        reset = 1;
        start = 0;
        ack   = 0;
        x     = 4'b0000;

        #12 reset = 0;

        $display("=== STARTING GRAY CODE MEALY TEST ===");

        apply_and_check(4'b0000, 1'b0); // Initial load -> Invalid
        apply_and_check(4'b0001, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b0011, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b0111, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b0101, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b1101, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b1100, 1'b1); // 1-bit change -> Valid
        apply_and_check(4'b1111, 1'b0); // 2-bit change -> Invalid
        apply_and_check(4'b1111, 1'b0); // 0-bit change -> Invalid

        // Test ACK returning to IDLE
        @(negedge clk);
        start = 0;
        ack   = 1;
        @(posedge clk);
        #1;
        if (valid == 0 && invalid == 0)
            $display("Time=%0t | ACK Pressed | Valid=%b | Invalid=%b -> PASS (Returned to IDLE)", $time, valid, invalid);
        else
            $display("Time=%0t | ACK Pressed | FAIL", $time);

        $display("=== TEST COMPLETE ===");
        $finish;
    end

endmodule
