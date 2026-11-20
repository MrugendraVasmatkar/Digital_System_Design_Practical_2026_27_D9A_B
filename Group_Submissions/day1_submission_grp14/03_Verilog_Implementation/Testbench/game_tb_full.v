`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Self-checking testbench for mealy_simple (Game Score Categorizer, Mealy FSM)
// Problem 3H2 - covers: all 16 score values, all four FSM states (IDLE, LOW,
// MED, HIGH), reset, START/ACK behaviour, and LED outputs, with PASS/FAIL messages.
//
// Timing: clock period 10 ns (posedge at 5, 15, 25 ... ns). Inputs are driven at
// the negative edge and outputs are checked 3 ns later, i.e. before the next
// positive edge, so Mealy (combinational) outputs are observed in the same cycle.
// LED vector order in all checks: {high_led, med_led, low_led}.
//
// NOTE: written to be run in Vivado Simulator (or any Verilog simulator) with
// mealy_simple.v as the design under test.
//////////////////////////////////////////////////////////////////////////////////
module game_tb_full;
    reg        clk, reset, start, ack;
    reg  [3:0] score;
    wire       low_led, med_led, high_led;

    mealy_simple dut (
        .clk(clk), .reset(reset), .start(start), .ack(ack), .score(score),
        .low_led(low_led), .med_led(med_led), .high_led(high_led)
    );

    integer errors;
    integer checks;
    integer i, k, seed;
    reg [3:0] other;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ------------------------------------------------------------------
    // Spec-based expected LED vector for a score: LOW 0-4, MED 5-10, HIGH 11-15
    // ------------------------------------------------------------------
    function [2:0] led_of;
        input [3:0] s;
        begin
            if (s <= 4)       led_of = 3'b001;   // LOW
            else if (s <= 10) led_of = 3'b010;   // MEDIUM
            else              led_of = 3'b100;   // HIGH
        end
    endfunction

    // ------------------------------------------------------------------
    // Independent behavioural reference model (used by the random test)
    // ------------------------------------------------------------------
    localparam M_IDLE = 2'd0, M_LOW = 2'd1, M_MED = 2'd2, M_HIGH = 2'd3;
    reg [1:0] mstate;

    function [1:0] cat;
        input [3:0] s;
        begin
            if (s <= 4)       cat = M_LOW;
            else if (s <= 10) cat = M_MED;
            else              cat = M_HIGH;
        end
    endfunction

    always @(posedge clk) begin
        if (reset)                   mstate <= M_IDLE;
        else if (mstate == M_IDLE) begin
            if (start)               mstate <= cat(score);
        end
        else if (ack)                mstate <= M_IDLE;
    end

    function [2:0] model_out;
        input       s_reset;
        input [1:0] st;
        input       s_start;
        input       s_ack;
        input [3:0] sc;
        begin
            if (s_reset)                    // all LEDs are off whenever reset = 1 (as in Logisim)
                model_out = 3'b000;
            else if (st == M_IDLE)
                model_out = s_start ? led_of(sc) : 3'b000;
            else if (s_ack)
                model_out = 3'b000;
            else
                model_out = (st == M_LOW) ? 3'b001 : (st == M_MED) ? 3'b010 : 3'b100;
        end
    endfunction

    // ------------------------------------------------------------------
    // Helpers
    // ------------------------------------------------------------------
    // Drive inputs at the negative edge, then wait 3 ns (before the next posedge)
    task apply;
        input       r;
        input       s;
        input       a;
        input [3:0] sc;
        begin
            @(negedge clk);
            reset = r; start = s; ack = a; score = sc;
            #3;
        end
    endtask

    task check;
        input [2:0]      expected;
        input [8*48:1]   label;
        begin
            checks = checks + 1;
            if ({high_led, med_led, low_led} !== expected) begin
                errors = errors + 1;
                $display("FAIL [%0d ns] %0s : score=%0d start=%b ack=%b reset=%b  expected H/M/L=%b  got H/M/L=%b%b%b",
                         $time, label, score, start, ack, reset, expected, high_led, med_led, low_led);
            end else begin
                $display("PASS [%0d ns] %0s : score=%0d start=%b ack=%b reset=%b  H/M/L=%b%b%b",
                         $time, label, score, start, ack, reset, high_led, med_led, low_led);
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------------
    initial begin
        errors = 0; checks = 0; seed = 32'h1234;
        reset = 1'b1; start = 1'b0; ack = 1'b0; score = 4'd0;

        // ---------------- Test 1: reset to IDLE ----------------
        $display("=== Test 1: reset forces IDLE, all LEDs off ===");
        @(negedge clk); @(negedge clk);          // two clock edges with reset=1
        apply(1'b1, 1'b0, 1'b0, 4'd0);
        check(3'b000, "T1 reset -> IDLE, LEDs off");
        apply(1'b0, 1'b0, 1'b0, 4'd0);
        check(3'b000, "T1 IDLE after reset, LEDs off");

        // ---------------- Test 2: all 16 scores, full round each ----------------
        $display("=== Test 2: all 16 scores (0-15), START then hold then ACK ===");
        for (i = 0; i < 16; i = i + 1) begin
            apply(1'b0, 1'b0, 1'b0, i[3:0]);
            check(3'b000, "T2 IDLE before START");
            apply(1'b0, 1'b1, 1'b0, i[3:0]);
            check(led_of(i[3:0]), "T2 START: Mealy LED same cycle");
            apply(1'b0, 1'b0, 1'b0, 4'd15 - i[3:0]);   // score changes after START
            check(led_of(i[3:0]), "T2 result held, score changed");
            apply(1'b0, 1'b0, 1'b0, i[3:0]);
            check(led_of(i[3:0]), "T2 result held (next cycle)");
            apply(1'b0, 1'b0, 1'b1, i[3:0]);
            check(3'b000, "T2 ACK: LEDs off");
            apply(1'b0, 1'b0, 1'b0, i[3:0]);
            check(3'b000, "T2 back in IDLE, LEDs off");
        end

        // ---------------- Test 3: START ignored while a result is shown ----------------
        $display("=== Test 3: START ignored in LOW / MED / HIGH states ===");
        for (k = 0; k < 3; k = k + 1) begin
            other = (k == 0) ? 4'd2 : (k == 1) ? 4'd7 : 4'd13;    // scores for LOW, MED, HIGH
            apply(1'b0, 1'b1, 1'b0, other);
            check(led_of(other), "T3 round started");
            apply(1'b0, 1'b1, 1'b0, 4'd15 - other);                // START again with another score
            check(led_of(other), "T3 START ignored in result state");
            apply(1'b0, 1'b0, 1'b1, 4'd15 - other);
            check(3'b000, "T3 ACK clears result");
            apply(1'b0, 1'b0, 1'b0, 4'd0);
            check(3'b000, "T3 IDLE again");
        end

        // ---------------- Test 4: ACK ignored in IDLE; START with ACK together ----------------
        $display("=== Test 4: ACK ignored in IDLE; START and ACK together ===");
        apply(1'b0, 1'b0, 1'b1, 4'd5);
        check(3'b000, "T4 ACK in IDLE: LEDs stay off");
        apply(1'b0, 1'b0, 1'b0, 4'd5);
        check(3'b000, "T4 still IDLE (no result created)");
        apply(1'b0, 1'b1, 1'b1, 4'd12);
        check(3'b100, "T4 START+ACK in IDLE: START wins (HIGH)");
        apply(1'b0, 1'b0, 1'b0, 4'd12);
        check(3'b100, "T4 HIGH held after START+ACK");
        apply(1'b0, 1'b0, 1'b1, 4'd12);
        check(3'b000, "T4 ACK clears HIGH");
        apply(1'b0, 1'b0, 1'b0, 4'd12);
        check(3'b000, "T4 IDLE again");

        // ---------------- Test 5: reset in every state ----------------
        $display("=== Test 5: reset from LOW / MED / HIGH and reset priority in IDLE ===");
        for (k = 0; k < 3; k = k + 1) begin
            other = (k == 0) ? 4'd2 : (k == 1) ? 4'd7 : 4'd13;
            apply(1'b0, 1'b1, 1'b0, other);
            check(led_of(other), "T5 round started");
            apply(1'b0, 1'b0, 1'b0, other);
            check(led_of(other), "T5 result held");
            apply(1'b1, 1'b0, 1'b0, other);
            check(3'b000, "T5 reset asserted: LEDs off at once");
            apply(1'b0, 1'b0, 1'b0, other);
            check(3'b000, "T5 after reset edge: IDLE, LEDs off");
        end
        apply(1'b1, 1'b1, 1'b0, 4'd13);
        check(3'b000, "T5 START+RESET in IDLE: LEDs stay off");
        apply(1'b0, 1'b0, 1'b0, 4'd13);
        check(3'b000, "T5 reset has priority: stayed IDLE");

        // ---------------- Test 6: START held over several cycles ----------------
        $display("=== Test 6: START held high for several cycles ===");
        apply(1'b0, 1'b1, 1'b0, 4'd2);
        check(3'b001, "T6 START cycle 1 (LOW)");
        apply(1'b0, 1'b1, 1'b0, 4'd13);
        check(3'b001, "T6 START cycle 2, score changed (LOW held)");
        apply(1'b0, 1'b1, 1'b0, 4'd7);
        check(3'b001, "T6 START cycle 3, score changed (LOW held)");
        apply(1'b0, 1'b0, 1'b1, 4'd7);
        check(3'b000, "T6 ACK clears");
        apply(1'b0, 1'b0, 1'b0, 4'd7);
        check(3'b000, "T6 IDLE again");

        // ---------------- Test 7: random inputs against the reference model ----------------
        $display("=== Test 7: 400 random cycles vs reference model ===");
        for (i = 0; i < 400; i = i + 1) begin
            @(negedge clk);
            reset = (($random(seed) & 15) == 0);
            start = $random(seed);
            ack   = $random(seed);
            score = $random(seed);
            #3;
            check(model_out(reset, mstate, start, ack, score), "T7 random vs model");
        end

        // ---------------- Summary ----------------
        $display("==================================================");
        if (errors == 0)
            $display("RESULT: ALL %0d CHECKS PASSED", checks);
        else
            $display("RESULT: %0d OF %0d CHECKS FAILED", errors, checks);
        $display("==================================================");
        $finish;
    end
endmodule
