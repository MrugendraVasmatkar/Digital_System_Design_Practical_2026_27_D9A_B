`timescale 1ns/1ps
module tb_game_score;
    reg        clk = 0, rst = 0, start = 0, ack = 0;
    reg  [4:0] score_in = 0;
    wire [2:0] state;  wire [4:0] score_reg;
    wire       led_low, led_med, led_high, led_err;

    localparam [2:0] S_IDLE=3'b000, S_LOW=3'b001, S_MED=3'b010, S_HIGH=3'b011, S_ERR=3'b100;

    game_score_fsm dut (.clk(clk), .rst(rst), .start(start), .ack(ack),
        .score_in(score_in), .state(state), .score_reg(score_reg),
        .led_low(led_low), .led_med(led_med), .led_high(led_high), .led_err(led_err));

    always #5 clk = ~clk;   // 100 MHz

    integer pass_cnt = 0, fail_cnt = 0, i, k;

    // ---------- Reference model ----------
    function [2:0] exp_state(input [4:0] s);
        begin
            if      (s <= 4)  exp_state = S_LOW;
            else if (s <= 10) exp_state = S_MED;
            else if (s <= 15) exp_state = S_HIGH;
            else              exp_state = S_ERR;
        end
    endfunction

    // ---------- Checkers ----------
    task check(input [2:0] e_state, input [8*28-1:0] label);
        reg [3:0] e_led, a_led;
        begin
            e_led = { e_state==S_ERR, e_state==S_HIGH, e_state==S_MED, e_state==S_LOW };
            a_led = { led_err, led_high, led_med, led_low };
            if (state === e_state && a_led === e_led) begin
                pass_cnt = pass_cnt + 1;
                $display("[PASS] %0s | score=%0d state=%b LEDs(E,H,M,L)=%b", label, score_in, state, a_led);
            end else begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] %0s | score=%0d exp state=%b LEDs=%b | got state=%b LEDs=%b",
                          label, score_in, e_state, e_led, state, a_led);
            end
        end
    endtask

    task check_reg(input [4:0] e_reg, input [8*28-1:0] label);
        begin
            if (score_reg === e_reg) pass_cnt = pass_cnt + 1;
            else begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] %0s | exp score_reg=%0d got=%0d", label, e_reg, score_reg);
            end
        end
    endtask

    // ---------- Stimulus tasks ----------
    task pulse_start; begin @(negedge clk) start = 1; @(negedge clk) start = 0; end endtask
    task pulse_ack;   begin @(negedge clk) ack   = 1; @(negedge clk) ack   = 0; end endtask
    task pulse_rst;   begin @(negedge clk) rst   = 1; @(negedge clk) rst   = 0; end endtask

    initial begin
        $display("=== Game Score Categorizer self-checking testbench ===");

        // T1: reset
        $display("--- T1: Reset ---");
        pulse_rst;
        check(S_IDLE, "T1 reset -> IDLE");
        check_reg(5'd0, "T1 reset clears score_reg");

        // T2: all 16 valid scores
        $display("--- T2: Scores 0..15 ---");
        for (i = 0; i < 16; i = i + 1) begin
            score_in = i[4:0];
            @(negedge clk);
            check(S_IDLE, "T2 IDLE before START");
            pulse_start;
            check(exp_state(i[4:0]), "T2 category after START");
            check_reg(i[4:0], "T2 score latched");
            score_in = (i + 7) % 16;              // must be ignored
            pulse_start;
            check(exp_state(i[4:0]), "T2 holds, START ignored");
            check_reg(i[4:0], "T2 score_reg unchanged");
            pulse_ack;
            check(S_IDLE, "T2 ACK -> IDLE");
        end

        // T3: IDLE stability
        $display("--- T3: IDLE stability ---");
        score_in = 5'd12;
        repeat (3) @(negedge clk);
        check(S_IDLE, "T3 no START -> stays IDLE");
        pulse_ack;
        check(S_IDLE, "T3 ACK in IDLE -> IDLE");

        // T4: reset from each state
        $display("--- T4: Reset from each state ---");
        for (k = 0; k < 4; k = k + 1) begin
            case (k) 0: score_in = 5'd3; 1: score_in = 5'd8;
                     2: score_in = 5'd14; default: score_in = 5'd20; endcase
            pulse_start;
            check(exp_state(score_in), "T4 entered state");
            pulse_rst;
            check(S_IDLE, "T4 reset -> IDLE");
            check_reg(5'd0, "T4 reset clears score_reg");
        end
        score_in = 5'd9;
        @(negedge clk) begin rst = 1; start = 1; end
        @(negedge clk) begin rst = 0; start = 0; end
        check(S_IDLE, "T4 reset beats START");

        // T5: H3 invalid scores 16..31
        $display("--- T5: ERROR state (16..31) ---");
        for (i = 16; i < 32; i = i + 1) begin
            score_in = i[4:0];
            pulse_start;
            check(S_ERR, "T5 invalid -> ERROR");
            pulse_ack;
            check(S_IDLE, "T5 ACK -> IDLE");
        end

        // Summary
        $display("======================================================");
        $display(" TOTAL CHECKS: %0d   PASS: %0d   FAIL: %0d",
                  pass_cnt + fail_cnt, pass_cnt, fail_cnt);
        if (fail_cnt == 0) $display(" *** OVERALL RESULT: PASS ***");
        else               $display(" *** OVERALL RESULT: FAIL ***");
        $display("======================================================");
        $finish;
    end
endmodule