`timescale 1ns / 1ps
//==============================================================================
// Self-checking testbench for gaming_xp_decoder   (v3 - short version)
// Vivado: Run Behavioral Simulation, then "Run All" once.
// Result in the Tcl Console: "ALL TESTS PASSED (81 checks)".
// Inputs change on the falling edge, so they are stable at every rising edge.
//==============================================================================
module tb_gaming_xp_decoder;

    reg        clk = 0, reset = 0, start = 0, ack = 0, done = 0;
    reg  [4:0] xp  = 0;
    wire       led_beginner, led_intermediate, led_expert, led_error;

    gaming_xp_decoder dut (.clk(clk), .reset(reset), .start(start), .ack(ack), .xp(xp),
        .led_beginner(led_beginner), .led_intermediate(led_intermediate),
        .led_expert(led_expert), .led_error(led_error));

    localparam [2:0] ST_IDLE = 3'b000, ST_BEG = 3'b001, ST_INT = 3'b010,
                     ST_EXP  = 3'b011, ST_ERR = 3'b100;

    // Internal signals for the wave window (state_name: set radix to ASCII)
    wire [2:0] state  = dut.state;
    wire [4:0] xp_reg = dut.xp_reg;
    wire [3:0] leds   = {led_beginner, led_intermediate, led_expert, led_error};
    reg [31:0] state_name;
    always @* case (state)
        ST_IDLE: state_name = "IDLE";  ST_BEG: state_name = "BEG ";
        ST_INT : state_name = "INT ";  ST_EXP: state_name = "EXP ";
        ST_ERR : state_name = "ERR ";  default: state_name = "----";
    endcase

    // 10 ns clock; stops at "done" so Run All ends by itself
    initial while (!done) #5 clk = ~clk;

    integer errors = 0, checks = 0;
    reg [5:0] k;
    reg quiet = 0;                       // 1 = print only FAIL lines

    // Expected level for an XP value: 0..3 BEG, 4..10 INT, 11..15 EXP, 16..31 ERR
    function [2:0] lvl(input [4:0] v);
        lvl = (v < 4) ? ST_BEG : (v < 11) ? ST_INT : (v < 16) ? ST_EXP : ST_ERR;
    endfunction

    // Check state + LEDs (Moore: exactly one LED for its state, none otherwise)
    task check(input [2:0] s, input [255:0] name);
        begin
            checks = checks + 1;
            if (state === s && leds === {s == ST_BEG, s == ST_INT, s == ST_EXP, s == ST_ERR}) begin
                if (!quiet) $display("[%0t] PASS  %0s  state=%b LEDs(B,I,X,E)=%b", $time, name, state, leds);
            end else begin
                errors = errors + 1;
                $display("[%0t] FAIL  %0s  state=%b (expected %b) xp_reg=%0d LEDs(B,I,X,E)=%b",
                         $time, name, state, s, xp_reg, leds);
            end
        end
    endtask

    task tick(input integer n);  repeat (n) @(negedge clk);           endtask
    task press_start;            begin start = 1; tick(1); start = 0; end endtask
    task press_ack;              begin ack   = 1; tick(1); ack   = 0; end endtask
    task press_reset;            begin reset = 1; tick(1); reset = 0; end endtask

    // One full cycle: load XP -> START -> level -> hold -> ACK -> IDLE
    task test_level(input [4:0] v);
        begin
            tick(1); xp = v;
            tick(1); check(ST_IDLE, "XP applied, no START -> still IDLE");
            press_start; $write("XP=%0d : ", v); check(lvl(v), "after START");
            xp = ~v; start = 1; tick(3); start = 0;
            check(lvl(v), "held (no ACK, XP changed, START ignored)");
            press_ack;   check(ST_IDLE, "after ACK -> IDLE");
        end
    endtask

    initial begin
        $display("==== Gaming XP Decoder testbench ====");
        reset = 1; tick(2); reset = 0;
        check(ST_IDLE, "after RESET");

        // Range boundaries
        test_level(0);  test_level(3);  test_level(4);  test_level(7);  test_level(10);
        test_level(11); test_level(15); test_level(16); test_level(31);

        // All 32 XP values (only failures are printed)
        $display("---- sweep XP = 0..31 ----");
        quiet = 1;
        for (k = 0; k < 32; k = k + 1) begin
            tick(1); xp = k[4:0]; tick(1); press_start;
            check(lvl(k[4:0]), "sweep");
            press_ack;
        end
        quiet = 0;
        $display("sweep done");

        $display("---- IDLE behaviour ----");
        xp = 5; ack = 1; tick(3); ack = 0;
        check(ST_IDLE, "IDLE stays IDLE (no START, ACK ignored)");

        $display("---- RESET priority ----");
        tick(1); start = 1; reset = 1; tick(1); start = 0; reset = 0;
        check(ST_IDLE, "RESET + START together -> IDLE");
        xp = 12; tick(1); press_start; check(ST_EXP, "reached EXPERT");
        press_reset;                   check(ST_IDLE, "RESET in EXPERT -> IDLE");

        // Unused states 101,110,111: all LEDs off, then back to IDLE
        $display("---- unused states ----");
        for (k = 5; k < 8; k = k + 1) begin
            tick(1); dut.state = k[2:0]; #1;
            check(k[2:0], "illegal state: all LEDs off");
            tick(1); check(ST_IDLE, "illegal state recovers to IDLE");
        end

        // XP_REG holds the PREVIOUS edge's XP: XP change + START in the same
        // clock uses the OLD value
        $display("---- one-clock delay demo ----");
        tick(1); xp = 5; tick(1); xp = 0; press_start;
        check(ST_INT, "XP 5->0 with START in same clock: OLD XP (5) used -> INT");
        press_ack; check(ST_IDLE, "ACK -> IDLE");

        $display("=====================================");
        if (errors == 0) $display("ALL TESTS PASSED (%0d checks)", checks);
        else             $display("TESTS FAILED: %0d error(s) in %0d checks", errors, checks);
        $display("=====================================");
        done = 1;
    end

    initial #200000 if (!done) begin $display("TIMEOUT"); done = 1; end

endmodule
