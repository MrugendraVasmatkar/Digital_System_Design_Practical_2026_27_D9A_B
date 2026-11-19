`timescale 1ns / 1ps
//==============================================================================
// Self-checking testbench for gaming_xp_decoder   (v2)
//
// HOW TO RUN IN VIVADO
//   Run Behavioral Simulation, then click "Run All" (or type  run all  in the
//   Tcl Console) ONCE. The test needs ~2.2 us, but Vivado stops at 1 us by
//   default. The clock stops when the test is done, so Run All ends by itself
//   (the run is over at about 200 us because of the watchdog timer).
//   Read the result in the Tcl Console: "ALL TESTS PASSED".
//
// Inputs change on the falling edge, so they are stable at every rising edge.
// Pass/fail lines are printed in the Tcl Console.
//==============================================================================
module tb_gaming_xp_decoder;

    // ---------------- DUT signals ----------------
    reg        clk   = 1'b0;
    reg        reset = 1'b0;
    reg        start = 1'b0;
    reg        ack   = 1'b0;
    reg  [4:0] xp    = 5'd0;
    wire       led_beginner, led_intermediate, led_expert, led_error;

    gaming_xp_decoder dut (
        .clk              (clk),
        .reset            (reset),
        .start            (start),
        .ack              (ack),
        .xp               (xp),
        .led_beginner     (led_beginner),
        .led_intermediate (led_intermediate),
        .led_expert       (led_expert),
        .led_error        (led_error)
    );

    // State codes (same as the design)
    localparam [2:0] ST_IDLE = 3'b000, ST_BEG = 3'b001, ST_INT = 3'b010,
                     ST_EXP  = 3'b011, ST_ERR = 3'b100;

    //--------------------------------------------------------------------------
    // Waveform helpers: internal signals made visible at the testbench level,
    // so they show up in the wave window without browsing into "dut".
    //   state_name: set its radix to ASCII to see IDLE / BEG / INT / EXP / ERR
    //--------------------------------------------------------------------------
    wire [2:0] state  = dut.state;
    wire [4:0] xp_reg = dut.xp_reg;

    reg [31:0] state_name;
    always @* begin
        case (state)
            ST_IDLE: state_name = "IDLE";
            ST_BEG : state_name = "BEG ";
            ST_INT : state_name = "INT ";
            ST_EXP : state_name = "EXP ";
            ST_ERR : state_name = "ERR ";
            default: state_name = "----";   // illegal state 101..111
        endcase
    end

    // 10 ns clock. It stops when the test sets "done", so the simulator runs
    // out of events and "Run All" ends by itself (an always-running clock
    // would make Run All go on forever in Vivado).
    reg done = 1'b0;
    initial begin
        while (!done) #5 clk = ~clk;
    end

    integer errors = 0;
    integer checks = 0;
    reg [5:0] k;                // loop variable (a reg, so it shows in the wave)

    //--------------------------------------------------------------------------
    // Check state + all four LEDs against the expected state (Moore outputs)
    //--------------------------------------------------------------------------
    task check(input [2:0] s, input [255:0] name);
        reg ok;
        begin
            checks = checks + 1;
            ok = (state === s)
              && (led_beginner     === (s == ST_BEG))
              && (led_intermediate === (s == ST_INT))
              && (led_expert       === (s == ST_EXP))
              && (led_error        === (s == ST_ERR));
            if (ok)
                $display("[%0t] PASS  %0s  state=%b LEDs(B,I,X,E)=%b%b%b%b",
                         $time, name, state,
                         led_beginner, led_intermediate, led_expert, led_error);
            else begin
                errors = errors + 1;
                $display("[%0t] FAIL  %0s  state=%b (expected %b) LEDs(B,I,X,E)=%b%b%b%b",
                         $time, name, state, s,
                         led_beginner, led_intermediate, led_expert, led_error);
            end
        end
    endtask

    //--------------------------------------------------------------------------
    // Full cycle for one XP value:
    //   load XP -> START -> check level -> hold (START/XP ignored) -> ACK -> IDLE
    //--------------------------------------------------------------------------
    task test_level(input [4:0] value, input [2:0] s_expected);
        begin
            // 1) present XP; XP_REG samples it on the next rising edge (IDLE)
            @(negedge clk); xp = value; start = 1'b0; ack = 1'b0;
            @(negedge clk);
            check(ST_IDLE, "XP applied, no START -> still IDLE");

            // 2) START for one clock -> state loads the level
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;
            $write("XP=%0d : ", value);
            check(s_expected, "after START");

            // 3) state must hold, even if XP changes and START is pulsed again
            xp = ~value; start = 1'b1;
            repeat (3) @(negedge clk);
            start = 1'b0;
            check(s_expected, "held (no ACK, XP changed, START ignored)");

            // 4) ACK -> back to IDLE
            ack = 1'b1;
            @(negedge clk);
            ack = 1'b0;
            check(ST_IDLE, "after ACK -> IDLE");
        end
    endtask

    //--------------------------------------------------------------------------
    // Main stimulus
    //--------------------------------------------------------------------------
    initial begin
        $display("==== Gaming XP Decoder testbench ====");

        // ---- Power-up reset ----
        reset = 1'b1;
        repeat (2) @(negedge clk);
        reset = 1'b0;
        check(ST_IDLE, "after RESET");

        // ---- Range boundaries ----
        test_level(5'd0,  ST_BEG);   // BEGINNER     0..3
        test_level(5'd3,  ST_BEG);
        test_level(5'd4,  ST_INT);   // INTERMEDIATE 4..10
        test_level(5'd7,  ST_INT);
        test_level(5'd10, ST_INT);
        test_level(5'd11, ST_EXP);   // EXPERT       11..15
        test_level(5'd15, ST_EXP);
        test_level(5'd16, ST_ERR);   // ERROR        16..31
        test_level(5'd31, ST_ERR);

        // ---- Exhaustive sweep of all 32 XP values ----
        $display("---- sweep XP = 0..31 ----");
        for (k = 0; k < 32; k = k + 1) begin
            @(negedge clk); xp = k[4:0];
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            checks = checks + 1;
            if (state !== ((k < 4)  ? ST_BEG :
                           (k < 11) ? ST_INT :
                           (k < 16) ? ST_EXP : ST_ERR)) begin
                errors = errors + 1;
                $display("[%0t] FAIL  sweep XP=%0d state=%b", $time, k, state);
            end
            ack = 1'b1; @(negedge clk); ack = 1'b0;
        end
        $display("sweep done");

        // ---- START not pressed, ACK pressed in IDLE: nothing happens ----
        $display("---- IDLE behaviour ----");
        xp = 5'd5; start = 1'b0; ack = 1'b1;
        repeat (3) @(negedge clk);
        ack = 1'b0;
        check(ST_IDLE, "IDLE stays IDLE (no START, ACK ignored)");

        // ---- RESET has priority over START ----
        $display("---- RESET priority ----");
        xp = 5'd5;
        @(negedge clk);                       // XP_REG <- 5
        start = 1'b1; reset = 1'b1;
        @(negedge clk);
        start = 1'b0; reset = 1'b0;
        check(ST_IDLE, "RESET + START together -> IDLE");

        // ---- RESET while in a level state ----
        xp = 5'd12;
        @(negedge clk);
        start = 1'b1; @(negedge clk); start = 1'b0;
        check(ST_EXP, "reached EXPERT");
        reset = 1'b1; @(negedge clk); reset = 1'b0;
        check(ST_IDLE, "RESET in EXPERT -> IDLE");

        // ---- Unused states 101,110,111 must light nothing and go to IDLE ----
        $display("---- unused states ----");
        for (k = 5; k < 8; k = k + 1) begin
            @(negedge clk);
            dut.state = k[2:0];               // force an illegal state
            #1;
            checks = checks + 1;
            if ({led_beginner, led_intermediate, led_expert, led_error} !== 4'b0000) begin
                errors = errors + 1;
                $display("[%0t] FAIL  illegal state %b lights an LED", $time, state);
            end else
                $display("[%0t] PASS  illegal state %b: all LEDs off", $time, state);
            @(negedge clk);
            check(ST_IDLE, "illegal state recovers to IDLE");
        end

        // ---- One-clock input delay (documents the design's behaviour) ----
        // XP_REG holds the XP of the PREVIOUS edge. If XP changes in the same
        // clock as START, the level is decided from the OLD value.
        $display("---- one-clock delay demo ----");
        @(negedge clk); xp = 5'd5;            // will be sampled into XP_REG
        @(negedge clk);                       // XP_REG = 5 now
        xp = 5'd0; start = 1'b1;              // new XP (BEG) + START together
        @(negedge clk);
        start = 1'b0;
        check(ST_INT, "XP 5->0 with START in same clock: OLD XP (5) used -> INT");
        ack = 1'b1; @(negedge clk); ack = 1'b0;
        check(ST_IDLE, "ACK -> IDLE");

        // ---- Summary ----
        $display("=====================================");
        if (errors == 0)
            $display("ALL TESTS PASSED (%0d checks)", checks);
        else
            $display("TESTS FAILED: %0d error(s) in %0d checks", errors, checks);
        $display("=====================================");
        done = 1'b1;                 // stop the clock -> simulation ends
    end

    // Watchdog (only matters if the test above hangs)
    initial begin
        #200000;
        if (!done) begin
            $display("TIMEOUT");
            done = 1'b1;
        end
    end

endmodule