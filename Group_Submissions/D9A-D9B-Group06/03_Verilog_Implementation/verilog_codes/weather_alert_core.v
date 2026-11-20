`timescale 1ns / 1ps
// ============================================================================
// Weather Alert System - H1: Four-Category Weather Alert (adds WARNING level)
// Group06 - Digital System Design Practical 2026
//
// Module : weather_alert_core
// Type   : Moore FSM + datapath (3-bit input register + range decoder)
//
// Wind categories (H1):
//   0-1 -> CALM     2-4 -> BREEZY     5 -> WARNING     6-7 -> STORM
//
// State encoding (3-bit binary, 5 used states):
//   IDLE=000  CALM=001  BREEZY=010  WARNING=011  STORM=100
//   Unused codes 101/110/111 return to IDLE (safe recovery).
//
// Timing: the input register samples wind_in on every clock while the FSM is
// in IDLE and freezes as soon as an alert state is entered. When START is
// seen in IDLE, the FSM classifies the value already held in the register,
// so the category shown always matches the stored wind value.
//
// RESET is synchronous and active-high and has the highest priority.
// ============================================================================
module weather_alert_core (
    input  wire       clk,
    input  wire       reset,        // synchronous, active-high
    input  wire       start,        // classify the registered wind value
    input  wire       ack,          // acknowledge alert, return to IDLE
    input  wire [2:0] wind_in,      // W2..W0 from switches
    output reg        calm_led,     // green
    output reg        breezy_led,   // yellow
    output reg        warning_led,  // orange  (new in H1)
    output reg        storm_led,    // red
    output reg        buzzer,       // active in STORM
    output wire [2:0] state_out,    // current state (debug / display)
    output wire [2:0] wind_reg_out  // registered wind value (debug / display)
);

    // ---------------- state encoding ----------------
    localparam [2:0] S_IDLE    = 3'b000,
                     S_CALM    = 3'b001,
                     S_BREEZY  = 3'b010,
                     S_WARNING = 3'b011,
                     S_STORM   = 3'b100;

    reg [2:0] state, next_state;
    reg [2:0] wind_reg;

    // ---------------- 3-bit input register ----------------
    always @(posedge clk) begin
        if (reset)
            wind_reg <= 3'b000;
        else if (state == S_IDLE)
            wind_reg <= wind_in;     // track switches only while idle
    end

    // ---------------- range decoder (combinational) ----------------
    wire is_calm    = (wind_reg <= 3'd1);
    wire is_breezy  = (wind_reg >= 3'd2) && (wind_reg <= 3'd4);
    wire is_warning = (wind_reg == 3'd5);
    wire is_storm   = (wind_reg >= 3'd6);

    // ---------------- state register ----------------
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    // ---------------- next-state logic ----------------
    always @(*) begin
        next_state = state;                 // default: hold
        case (state)
            S_IDLE: begin
                if (start) begin
                    if      (is_storm)   next_state = S_STORM;
                    else if (is_warning) next_state = S_WARNING;
                    else if (is_breezy)  next_state = S_BREEZY;
                    else                 next_state = S_CALM;
                end
            end
            S_CALM, S_BREEZY, S_WARNING, S_STORM: begin
                if (ack) next_state = S_IDLE;
            end
            default: next_state = S_IDLE;   // unused codes -> IDLE
        endcase
    end

    // ---------------- Moore output logic (depends on state only) ----------------
    always @(*) begin
        calm_led    = 1'b0;
        breezy_led  = 1'b0;
        warning_led = 1'b0;
        storm_led   = 1'b0;
        buzzer      = 1'b0;
        case (state)
            S_CALM:    calm_led    = 1'b1;
            S_BREEZY:  breezy_led  = 1'b1;
            S_WARNING: warning_led = 1'b1;
            S_STORM:   begin storm_led = 1'b1; buzzer = 1'b1; end
            default:   ;                     // IDLE: all off
        endcase
    end

    assign state_out    = state;
    assign wind_reg_out = wind_reg;

endmodule

