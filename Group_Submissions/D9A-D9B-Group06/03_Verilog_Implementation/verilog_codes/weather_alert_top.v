`timescale 1ns / 1ps
// ============================================================================
// Weather Alert System - H1 - FPGA top level for the RealDigital Boolean Board
// (AMD/Xilinx Spartan-7 XC7S50-CSGA324-1, 100 MHz clock on F14)
//
// Board mapping
//   sw[2:0]  -> W2..W0 wind input
//   btn[0]   -> RESET (synchronous, active-high)
//   btn[1]   -> START
//   btn[2]   -> ACK
//   led[0]   -> CALM      led[1] -> BREEZY   led[2] -> WARNING
//   led[3]   -> STORM     led[4] -> BUZZER indicator (board has no buzzer)
//   led[15:13] -> FSM state code, led[10:8] -> registered wind value
//   RGB0     -> category colour: green / yellow / orange / red
//   RGB1     -> red, blinking ~3 Hz while STORM (visual "buzzer")
//
// Buttons and switches are passed through 2-flip-flop synchronisers.
// No debouncing is needed: START only acts in IDLE and ACK only acts in an
// alert state, so contact bounce cannot cause a wrong transition.
// ============================================================================
module weather_alert_top (
    input  wire        clk,        // 100 MHz
    input  wire [2:0]  sw,
    input  wire [2:0]  btn,
    output wire [15:0] led,
    output wire [2:0]  rgb0,       // {B,G,R} -> index 0=R 1=G 2=B
    output wire [2:0]  rgb1
);

    // ---------------- synchronisers ----------------
    reg [5:0] sync1, sync2;
    always @(posedge clk) begin
        sync1 <= {btn, sw};
        sync2 <= sync1;
    end
    wire [2:0] wind_s  = sync2[2:0];
    wire       reset_s = sync2[3];
    wire       start_s = sync2[4];
    wire       ack_s   = sync2[5];

    // ---------------- core ----------------
    wire calm, breezy, warning, storm, buzzer;
    wire [2:0] state, wind_reg;

    weather_alert_core u_core (
        .clk         (clk),
        .reset       (reset_s),
        .start       (start_s),
        .ack         (ack_s),
        .wind_in     (wind_s),
        .calm_led    (calm),
        .breezy_led  (breezy),
        .warning_led (warning),
        .storm_led   (storm),
        .buzzer      (buzzer),
        .state_out   (state),
        .wind_reg_out(wind_reg)
    );

    // ---------------- free-running counter (PWM + blink) ----------------
    reg [24:0] cnt = 25'd0;
    always @(posedge clk) cnt <= cnt + 25'd1;
    wire pwm_25 = (cnt[7:6] == 2'b00);   // 25 % duty, ~390 kHz
    wire blink  = cnt[24];               // ~3 Hz

    // ---------------- LEDs ----------------
    assign led[0]     = calm;
    assign led[1]     = breezy;
    assign led[2]     = warning;
    assign led[3]     = storm;
    assign led[4]     = buzzer;
    assign led[7:5]   = 3'b000;
    assign led[10:8]  = wind_reg;
    assign led[12:11] = 2'b00;
    assign led[15:13] = state;

    // RGB0 colour: CALM green, BREEZY yellow (R+G), WARNING orange (R + 25% G), STORM red
    assign rgb0[0] = breezy | warning | storm;            // red
    assign rgb0[1] = calm | breezy | (warning & pwm_25);  // green
    assign rgb0[2] = 1'b0;                                 // blue unused
    // RGB1: blinking red "buzzer"
    assign rgb1[0] = buzzer & blink;
    assign rgb1[1] = 1'b0;
    assign rgb1[2] = 1'b0;

endmodule

