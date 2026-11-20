`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:08:59
// Design Name: 
// Module Name: tb_weather_alert_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:`timescale 1ns / 1ps
// ============================================================================
// Self-checking testbench for weather_alert_core (H1: four-category alert)
// Group06 - Digital System Design Practical 2026
//
// Covers: all 8 wind values (0-7), all 5 FSM states, synchronous RESET,
// START / ACK operation, hold behaviour, START+ACK together, RESET priority,
// and 300 random cycles checked against a behavioural reference model.
// Prints PASS/FAIL for each check and a final summary.
// Run in Vivado: set as simulation top, Run Behavioral Simulation, run all.
// ============================================================================
module tb_weather_alert_core;

    // ---------------- DUT signals ----------------
    reg        clk = 1'b0;
    reg        reset = 1'b0, start = 1'b0, ack = 1'b0;
    reg  [2:0] wind_in = 3'd0;
    wire       calm_led, breezy_led, warning_led, storm_led, buzzer;
    wire [2:0] state_out, wind_reg_out;

    weather_alert_core dut (
        .clk(clk), .reset(reset), .start(start), .ack(ack), .wind_in(wind_in),
        .calm_led(calm_led), .breezy_led(breezy_led), .warning_led(warning_led),
        .storm_led(storm_led), .buzzer(buzzer),
        .state_out(state_out), .wind_reg_out(wind_reg_out)
    );

    always #5 clk = ~clk;   // 100 MHz

    // ---------------- reference model ----------------
    localparam [2:0] IDLE = 3'd0, CALM = 3'd1, BREEZY = 3'd2, WARNING = 3'd3, STORM = 3'd4;
    reg [2:0] m_state = IDLE, m_reg = 3'd0;
    integer   checks = 0, errors = 0, i;

    function [2:0] category;            // H1 range decoder
        input [2:0] w;
        begin
            if      (w <= 3'd1) category = CALM;
            else if (w <= 3'd4) category = BREEZY;
            else if (w == 3'd5) category = WARNING;
            else                category = STORM;
        end
    endfunction

    function [8*7-1:0] sname;
        input [2:0] s;
        case (s)
            IDLE:    sname = "IDLE";
            CALM:    sname = "CALM";
            BREEZY:  sname = "BREEZY";
            WARNING: sname = "WARNING";
            STORM:   sname = "STORM";
            default: sname = "INVALID";
        endcase
    endfunction

    // Apply inputs away from the clock edge, then advance one rising edge and
    // update the reference model with the values that were sampled at that edge.
    task step;
        input [2:0] w; input s, a, r;
        begin
            @(negedge clk);
            wind_in = w; start = s; ack = a; reset = r;
            @(posedge clk);
            if (r) begin
                m_state = IDLE; m_reg = 3'd0;
            end else if (m_state == IDLE) begin
                m_state = s ? category(m_reg) : IDLE;
                m_reg   = w;
            end else if (a) begin
                m_state = IDLE;
            end
            #1;  // let DUT outputs settle after the edge
        end
    endtask

    task check;
        input [8*40-1:0] name;
        input            show;   // 1 = always print, 0 = print only on failure
        reg   [4:0]      exp_leds;
        reg              ok;
        begin
            checks   = checks + 1;
            exp_leds = { m_state == CALM, m_state == BREEZY, m_state == WARNING,
                         m_state == STORM, m_state == STORM };
            ok = (state_out === m_state) && (wind_reg_out === m_reg) &&
                 ({calm_led, breezy_led, warning_led, storm_led, buzzer} === exp_leds);
            if (!ok) errors = errors + 1;
            if (!ok || show)
                $display("%s  %0s | state=%0s reg=%0d LEDs{C,B,W,S,Bz}=%b%b%b%b%b %0s",
                         ok ? "PASS" : "FAIL", name, sname(state_out), wind_reg_out,
                         calm_led, breezy_led, warning_led, storm_led, buzzer,
                         ok ? "" : "<-- MISMATCH");
            if (!ok)
                $display("      expected state=%0s reg=%0d LEDs=%b", sname(m_state), m_reg, exp_leds);
        end
    endtask

    // ---------------- test sequence ----------------
    initial begin
        $dumpfile("tb_weather_alert_core.vcd");
        $dumpvars(0, tb_weather_alert_core);
        $display("==== Weather Alert System (H1) - self-checking testbench ====");

        step(3'd0, 0, 0, 1); check("T00 synchronous RESET -> IDLE", 1);
        step(3'd0, 0, 0, 0); check("T01 IDLE, no START -> stay IDLE", 1);
        step(3'd0, 0, 1, 0); check("T02 ACK in IDLE is ignored", 1);

        // all 8 wind values: load -> START -> hold -> START ignored -> ACK
        for (i = 0; i < 8; i = i + 1) begin
            step(i[2:0], 0, 0, 0);       check("     wind loaded into register (IDLE)", 1);
            step(i[2:0], 1, 0, 0);       check("T03+ START -> category state", 1);
            step(i[2:0], 0, 0, 0);       check("     hold after START released", 1);
            step(i[2:0] + 3'd3, 1, 0, 0); check("     hold: new wind + START ignored", 1);
            step(i[2:0], 0, 1, 0);       check("     ACK -> IDLE", 1);
        end

        // reset from STORM
        step(3'd6, 0, 0, 0); step(3'd6, 1, 0, 0);
        check("T11 STORM reached (wind=6)", 1);
        step(3'd6, 0, 0, 1); check("T12 RESET from STORM -> IDLE", 1);

        // START and ACK pressed together while IDLE: START wins (ACK only acts in alert states)
        step(3'd5, 0, 0, 0); step(3'd5, 1, 1, 0);
        check("T13 START+ACK in IDLE -> WARNING", 1);
        step(3'd5, 0, 1, 1); check("T14 RESET has priority over ACK", 1);

        // constrained-random regression
        for (i = 0; i < 300; i = i + 1) begin
            step($random, ($random % 3) == 0, ($random % 4) == 0, ($random % 25) == 0);
            check("     random cycle", 0);
        end

        $display("============================================================");
        $display("SUMMARY: %0d checks, %0d passed, %0d failed", checks, checks - errors, errors);
        if (errors == 0) $display("RESULT: ALL TESTS PASSED");
        else             $display("RESULT: TESTS FAILED");
        $display("============================================================");
        $finish;
    end

endmodule


