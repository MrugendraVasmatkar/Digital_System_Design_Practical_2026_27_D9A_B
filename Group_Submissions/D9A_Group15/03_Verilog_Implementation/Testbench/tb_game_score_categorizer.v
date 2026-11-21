`timescale 1ns / 1ps
module tb_game_score_categorizer;
    reg        clk = 1'b0, rst = 1'b0, start = 1'b0, ack = 1'b0;
    reg  [3:0] score = 4'd0;
    wire       low_led, med_led, high_led;
    wire [3:0] low_count, med_count, high_count;
    wire [1:0] state_out;

    game_score_categorizer dut (
        .clk(clk), .rst(rst), .start(start), .ack(ack), .score(score),
        .low_led(low_led), .med_led(med_led), .high_led(high_led),
        .low_count(low_count), .med_count(med_count), .high_count(high_count),
        .state_out(state_out));

    always #5 clk = ~clk;                       // 100 MHz

    integer errors = 0, checks = 0, i, k;
    reg [3:0] exp_low = 4'd0, exp_med = 4'd0, exp_high = 4'd0;

    function [1:0] cat;                         // expected category state
        input [3:0] s;
        begin
            if (s < 5)       cat = 2'b01;       // LOW
            else if (s > 10) cat = 2'b11;       // HIGH
            else             cat = 2'b10;       // MEDIUM
        end
    endfunction

    task check;
        input [1:0] e_state;
        begin
            checks = checks + 1;
            if (state_out !== e_state ||
                low_led  !== (e_state == 2'b01) || med_led !== (e_state == 2'b10) ||
                high_led !== (e_state == 2'b11) ||
                low_count !== exp_low || med_count !== exp_med || high_count !== exp_high) begin
                errors = errors + 1;
                $display("FAIL t=%0t score=%0d: state=%b (exp %b) LED L/M/H=%b%b%b counts L/M/H=%0d/%0d/%0d (exp %0d/%0d/%0d)",
                         $time, score, state_out, e_state, low_led, med_led, high_led,
                         low_count, med_count, high_count, exp_low, exp_med, exp_high);
            end
        end
    endtask

    task bump_expected;
        input [3:0] s;
        begin
            case (cat(s))
                2'b01:   exp_low  = exp_low  + 4'd1;
                2'b10:   exp_med  = exp_med  + 4'd1;
                default: exp_high = exp_high + 4'd1;
            endcase
        end
    endtask

    task detect;                                // press START for 'hold' clocks
        input [3:0] s;
        input integer hold;
        begin
            @(negedge clk); score = s; start = 1'b1;
            repeat (hold) @(negedge clk);
            start = 1'b0;
        end
    endtask

    task do_ack;
        begin
            @(negedge clk); ack = 1'b1;
            @(negedge clk); ack = 1'b0;
        end
    endtask

    initial begin
        #1000000; $display("TIMEOUT"); $finish;
    end

    initial begin
        rst = 1'b1; #12; rst = 1'b0;            // reset pulse
        @(negedge clk); check(2'b00);

        // Test 1: every score 0..15 -> correct category, counted once, holds, ACK -> IDLE
        for (i = 0; i < 16; i = i + 1) begin
            detect(i[3:0], 1);
            bump_expected(i[3:0]);
            check(cat(i[3:0]));
            score = ~i[3:0]; start = 1'b1;      // new START + different score must be ignored
            repeat (2) @(negedge clk);
            start = 1'b0;
            check(cat(i[3:0]));
            do_ack; check(2'b00);
        end

        // Test 2: START held for 3 clocks counts only once
        detect(4'd7, 3); bump_expected(4'd7); check(2'b10);
        do_ack; check(2'b00);

        // Test 3: no START -> stays IDLE even if score changes or ACK is pressed
        score = 4'd15; repeat (3) @(negedge clk); check(2'b00);
        do_ack; check(2'b00);

        // Test 4: 16 LOW detections wrap the 4-bit counter back to its old value
        for (k = 0; k < 16; k = k + 1) begin
            detect(4'd0, 1); bump_expected(4'd0); check(2'b01);
            do_ack; check(2'b00);
        end

        // Test 5: asynchronous reset clears state and counters
        detect(4'd15, 1); bump_expected(4'd15); check(2'b11);
        #1 rst = 1'b1; #2;
        exp_low = 4'd0; exp_med = 4'd0; exp_high = 4'd0;
        check(2'b00);
        rst = 1'b0; @(negedge clk); check(2'b00);

        $display("-----------------------------------------");
        $display("Checks run: %0d   Errors: %0d", checks, errors);
        if (errors == 0) $display("TEST PASSED");
        else             $display("TEST FAILED");
        $finish;
    end
endmodule
