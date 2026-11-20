`timescale 1ns / 1ps

module tb_xp_h5;
    reg clk = 0, rst = 0, st = 0, ack = 0;
    reg [3:0] sw = 0;
    wire [2:0] m, l2;

    xp_h5_top #(.DB(20'd3)) dut (
        .clk(clk), .rst_btn(rst), .start_btn(st), .ack_btn(ack),
        .xp_sw(sw), .main_led(m), .led2(l2)
    );

    always #5 clk = ~clk;   // 100 MHz

    // Each LED as its own signal, easy to find in the waveform
    wire LED1_beginner     = m[0];
    wire LED2_intermediate = m[1];
    wire LED3_expert       = m[2];
    wire LED4_was_beginner = l2[0];
    wire LED5_was_inter    = l2[1];
    wire LED6_was_expert   = l2[2];
    wire change_pulse      = dut.u_core.change;

    // Text label for the waveform (set radix to ASCII)
    reg [8*12-1:0] phase = "RESET";

    // Testbench-only bookkeeping (not hardware)
    integer errors = 0;
    integer i;
    reg [1:0] prev_lvl   = 2'b00;
    reg       prev_valid = 1'b0;

    function [1:0] lvl_of(input [3:0] x);
        lvl_of = (x <= 4'd3) ? 2'd1 : (x <= 4'd10) ? 2'd2 : 2'd3;
    endfunction

    function [2:0] onehot(input [1:0] l);
        onehot = (l == 2'd1) ? 3'b001 :
                 (l == 2'd2) ? 3'b010 :
                 (l == 2'd3) ? 3'b100 : 3'b000;
    endfunction

    // One full cycle: set XP, press START, check, press ACK, check.
    // Long waits so each step is easy to read in the waveform.
    task apply(input [3:0] v);
        reg [1:0] l;
        reg [2:0] exp_main, exp_l2;
        begin
            l        = lvl_of(v);
            exp_main = onehot(l);
            exp_l2   = (prev_valid && (prev_lvl != l)) ? onehot(prev_lvl) : 3'b000;

            sw = v;   repeat (20) @(posedge clk);
            st = 1;   repeat (12) @(posedge clk);
            st = 0;   repeat (30) @(posedge clk);

            if (m !== exp_main || l2 !== exp_l2) begin
                errors = errors + 1;
                $display("FAIL xp=%0d  main=%b (exp %b)  led2=%b (exp %b)",
                         v, m, exp_main, l2, exp_l2);
            end else
                $display("PASS xp=%0d  main=%b  led2=%b", v, m, l2);

            prev_lvl = l; prev_valid = 1'b1;

            ack = 1;  repeat (12) @(posedge clk);
            ack = 0;  repeat (30) @(posedge clk);

            if (m !== 3'b000) begin
                errors = errors + 1;
                $display("FAIL after ACK: main=%b (exp 000)", m);
            end
        end
    endtask

    initial begin
        // ---- Reset ----
        phase = "RESET";
        rst = 1; repeat (12) @(posedge clk);
        rst = 0; repeat (20) @(posedge clk);
        if (m !== 3'b000 || l2 !== 3'b000) begin
            errors = errors + 1; $display("FAIL after reset");
        end

        // ---- Directed: every kind of transition ----
        phase = "DIRECTED";
        apply(4'd2);    // Beginner      (first after reset: no change)
        apply(4'd3);    // B -> B        no change
        apply(4'd5);    // B -> I        LED4 (was Beginner)
        apply(4'd9);    // I -> I        no change
        apply(4'd12);   // I -> E        LED5 (was Intermediate)
        apply(4'd15);   // E -> E        no change
        apply(4'd0);    // E -> B        LED6 (was Expert)
        apply(4'd14);   // B -> E        LED4 (was Beginner)
        apply(4'd6);    // E -> I        LED6 (was Expert)
        apply(4'd1);    // I -> B        LED5 (was Intermediate)

        // ---- All 16 values ascending ----
        phase = "ASCENDING";
        for (i = 0; i < 16; i = i + 1) apply(i[3:0]);

        // ---- All 16 values descending ----
        phase = "DESCENDING";
        for (i = 15; i >= 0; i = i - 1) apply(i[3:0]);

        // ---- Reset in the middle of operation ----
        phase = "MID RESET";
        apply(4'd2);
        apply(4'd14);                       // B -> E, LED4 lights
        rst = 1; repeat (12) @(posedge clk);
        rst = 0; repeat (20) @(posedge clk);
        prev_valid = 1'b0;                  // history is forgotten
        if (m !== 3'b000 || l2 !== 3'b000) begin
            errors = errors + 1; $display("FAIL: reset did not clear LEDs");
        end
        apply(4'd7);                        // first after reset: no change

        phase = "DONE";
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        #200;
        $finish;
    end
endmodule