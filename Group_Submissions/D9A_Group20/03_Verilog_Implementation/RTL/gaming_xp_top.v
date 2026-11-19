`timescale 1ns / 1ps
//==============================================================================
// gaming_xp_top - Boolean Board (Spartan-7 xc7s50csga324-1) top level
//
// Board connections (see 04_FPGA_Hardware/boolean_gaming_xp.xdc):
//   clk      100 MHz oscillator (F14)
//   sw[4:0]  XP value, SW4 = MSB ... SW0 = LSB
//   btn[0]   START
//   btn[1]   ACK
//   btn[2]   RESET
//   led[0]   BEGINNER      led[1] INTERMEDIATE
//   led[2]   EXPERT        led[3] ERROR
//
// Why only synchronizers (no debouncer, no edge detector):
//   * Switches and buttons change at any time, not in step with the clock.
//     Two flip-flops in series (a "2-FF synchronizer") stop a half-way
//     (metastable) value from reaching the FSM.
//   * A held or bouncing button does not break this FSM:
//       START is only used in IDLE; once a level is loaded, START is ignored.
//       ACK is only used in a level state; once back in IDLE, ACK is ignored.
//       RESET just keeps the FSM in IDLE while it is held.
//     So one press = one action, even though a press lasts millions of clocks.
//==============================================================================
module gaming_xp_top (
    input  wire       clk,
    input  wire [4:0] sw,
    input  wire [2:0] btn,
    output wire [3:0] led
);

    // 2-FF synchronizers for all asynchronous inputs
    reg [4:0] sw_meta  = 5'd0, sw_sync  = 5'd0;
    reg [2:0] btn_meta = 3'd0, btn_sync = 3'd0;

    always @(posedge clk) begin
        sw_meta  <= sw;
        sw_sync  <= sw_meta;
        btn_meta <= btn;
        btn_sync <= btn_meta;
    end

    gaming_xp_decoder u_fsm (
        .clk              (clk),
        .reset            (btn_sync[2]),
        .start            (btn_sync[0]),
        .ack              (btn_sync[1]),
        .xp               (sw_sync),
        .led_beginner     (led[0]),
        .led_intermediate (led[1]),
        .led_expert       (led[2]),
        .led_error        (led[3])
    );

endmodule
