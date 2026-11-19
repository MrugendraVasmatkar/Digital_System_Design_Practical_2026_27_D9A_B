`timescale 1ns / 1ps
//==============================================================================
// FPGA top level - Gray Code Transition Detector
// Target: Digilent Arty S7-50 (Spartan-7 XC7S50-CSGA324-1), 100 MHz clock, N = 4
//
//   sw[3:0]  : data input X
//   btn[0]   : START  (load sample)
//   btn[1]   : ACK    (return to IDLE)
//   btn[2]   : RESET  (synchronous, active-high)
//
//   led[0]   VALID   LED   (exactly one bit changed)
//   led[1]   INVALID LED   (zero or >1 bit changed)
//   led[2]   IDLE    LED
//   led[3]   V  (one-bit-change detector output for the stored X and P)
//
// NOTE: use this file INSTEAD of gray_code_top.v (both contain module "debounce").
//==============================================================================
module gray_code_top_arty #(
    parameter DEBOUNCE_CYCLES = 1_000_000      // 10 ms at 100 MHz
)(
    input  wire        clk,
    input  wire [3:0]  sw,
    input  wire [2:0]  btn,
    output wire [3:0]  led
);
    localparam N = 4;

    // 2-flop synchroniser for the switches
    reg [N-1:0] sw_s0, sw_s1;
    initial begin sw_s0 = 0; sw_s1 = 0; end
    always @(posedge clk) begin
        sw_s0 <= sw;
        sw_s1 <= sw_s0;
    end

    // debounced + synchronised buttons
    wire start_db, ack_db, rst_db;
    debounce #(.CYCLES(DEBOUNCE_CYCLES)) u_db_start (.clk(clk), .in(btn[0]), .out(start_db));
    debounce #(.CYCLES(DEBOUNCE_CYCLES)) u_db_ack   (.clk(clk), .in(btn[1]), .out(ack_db));
    debounce #(.CYCLES(DEBOUNCE_CYCLES)) u_db_rst   (.clk(clk), .in(btn[2]), .out(rst_db));

    wire           valid_led, invalid_led, idle_led, v;
    wire [1:0]     state;
    wire [N-1:0]   curr, prev;

    gray_code_detector #(.N(N)) u_det (
        .clk        (clk),
        .rst        (rst_db),
        .start      (start_db),
        .ack        (ack_db),
        .data_in    (sw_s1),
        .valid_led  (valid_led),
        .invalid_led(invalid_led),
        .idle_led   (idle_led),
        .state_out  (state),
        .curr_out   (curr),
        .prev_out   (prev),
        .v_out      (v)
    );

    assign led[0] = valid_led;
    assign led[1] = invalid_led;
    assign led[2] = idle_led;
    assign led[3] = v;

endmodule


//==============================================================================
// Button debouncer: 2-flop synchroniser + stable-for-CYCLES counter
//==============================================================================
module debounce #(
    parameter CYCLES = 1_000_000
)(
    input  wire clk,
    input  wire in,
    output reg  out
);
    reg        s0, s1;
    reg [23:0] cnt;

    initial begin s0 = 0; s1 = 0; cnt = 0; out = 0; end

    always @(posedge clk) begin
        s0 <= in;
        s1 <= s0;
        if (s1 == out)
            cnt <= 24'd0;
        else if (cnt == CYCLES - 1) begin
            out <= s1;
            cnt <= 24'd0;
        end else
            cnt <= cnt + 24'd1;
    end
endmodule
