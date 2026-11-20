// ============================================================================
//  Self-checking testbench for the 4-bit Forbidden Zone Rejector
//  Checks: reset, all 16 inputs (0..15), FSM states, START/ACK, LED outputs
// ============================================================================
`timescale 1ns/1ps

module testbench;

    // ---------------- signals ----------------
    reg        clk, rst, start, ack;
    reg  [3:0] x;
    wire       y, accept_led, reject_led, fz;
    wire [1:0] state;
    wire [3:0] xreg;

    integer    i;
    integer    pass_count, fail_count;
    reg        exp_y;

    // ---------------- device under test ----------------
    rejector dut (
        .clk(clk), .rst(rst), .start(start), .ack(ack), .x(x),
        .y(y), .accept_led(accept_led), .reject_led(reject_led),
        .fz(fz), .state(state), .xreg(xreg));

    // ---------------- 10 ns clock ----------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ---------------- compare outputs with expected ----------------
    task check;
        input        e_y;          // expected Y
        input  [1:0] e_state;      // expected state
        input  [8*28:1] name;      // test name
        begin
            if ((y === e_y) && (accept_led === e_y) && (reject_led === ~e_y) &&
                (state === e_state)) begin
                pass_count = pass_count + 1;
                $display("PASS | %0s | X=%b (%0d) FZ=%b state=%b Y=%b ACCEPT=%b REJECT=%b",
                         name, xreg, xreg, fz, state, y, accept_led, reject_led);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL | %0s | X=%b FZ=%b state=%b Y=%b ACCEPT=%b REJECT=%b  (expected state=%b Y=%b)",
                         name, xreg, fz, state, y, accept_led, reject_led, e_state, e_y);
            end
        end
    endtask

    // ---------------- load one value with START ----------------
    // inputs change on the falling edge so they are stable at the rising edge
    task load_value;
        input [3:0] v;
        begin
            x     = v;
            start = 1'b1;
            @(negedge clk);       // rising edge in between: register loads X
            start = 1'b0;
            @(negedge clk);       // rising edge in between: FSM reacts to FZ
        end
    endtask

    // ---------------- test sequence ----------------
    initial begin
        pass_count = 0;  fail_count = 0;
        rst = 1'b1;  start = 1'b0;  ack = 1'b0;  x = 4'b0000;

        $display("=========== FORBIDDEN ZONE REJECTOR TEST ===========");

        // 1) synchronous reset
        @(negedge clk);
        @(negedge clk);
        rst = 1'b0;
        check(1'b1, 2'b00, "RESET -> IDLE");

        // 2) all 16 input values
        for (i = 0; i < 16; i = i + 1) begin
            load_value(i[3:0]);
            exp_y = ((i >= 6) && (i <= 9)) ? 1'b0 : 1'b1;
            if (fz !== ~exp_y) begin
                fail_count = fail_count + 1;
                $display("FAIL | FZ wrong for X=%0d (FZ=%b)", i, fz);
            end
            if (exp_y) check(exp_y, 2'b00, "allowed   -> IDLE/ACCEPT");
            else       check(exp_y, 2'b01, "forbidden -> REJECT");
        end

        // 3) REJECT holds while the stored value stays forbidden,
        //    even if the switches change without START
        load_value(4'd9);
        x = 4'd2;
        @(negedge clk);
        @(negedge clk);
        check(1'b0, 2'b01, "no START: stays REJECT");

        // 4) ACK returns to IDLE
        ack = 1'b1;
        @(negedge clk);
        ack = 1'b0;
        check(1'b1, 2'b00, "ACK -> IDLE");
        @(negedge clk);
        check(1'b1, 2'b00, "after ACK stays IDLE");

        // 5) RESET from REJECT
        load_value(4'd6);
        check(1'b0, 2'b01, "load 6 -> REJECT");
        rst = 1'b1;
        @(negedge clk);
        rst = 1'b0;
        check(1'b1, 2'b00, "RESET: REJECT -> IDLE");

        // 6) REJECT -> IDLE when an allowed value is loaded (FZ = 0)
        load_value(4'd8);
        check(1'b0, 2'b01, "load 8 -> REJECT");
        load_value(4'd12);
        check(1'b1, 2'b00, "load 12 -> IDLE (FZ=0)");

        // ---------------- summary ----------------
        $display("====================================================");
        $display("TOTAL: %0d PASSED, %0d FAILED", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED");
        $display("====================================================");
        $finish;
    end

endmodule
