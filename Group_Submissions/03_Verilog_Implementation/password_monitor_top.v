`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 01:57:20 PM
// Design Name: 
// Module Name: password_monitor_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module password_monitor_top (
    input wire clk,
    input wire reset,
    input wire start,
    input wire ack,
    input wire [2:0] attempt_switch,

    output wire green_led,
    output wire yellow_led,
    output wire red_led,
    output wire critical_led
);

    wire [2:0] stored_attempt;

    wire now_range;
    wire warn_range;
    wire lock_range;
    wire critical_range;

    wire [2:0] current_state;

    reg start_previous;
    reg start_pending;

    wire start_edge = start & ~start_previous;

    // Generate a one-clock delayed START pulse.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start_previous <= 1'b0;
            start_pending  <= 1'b0;
        end
        else begin
            start_previous <= start;
            start_pending  <= start_edge;
        end
    end

    // 3-bit attempt register
    attempt_register U1 (
        .clk(clk),
        .reset(reset),
        .load(start_edge),
        .attempt_in(attempt_switch),
        .attempt_out(stored_attempt)
    );

    // Four-level range decoder
    range_decoder U2 (
        .attempt(stored_attempt),
        .now_range(now_range),
        .warn_range(warn_range),
        .lock_range(lock_range),
        .critical_range(critical_range)
    );

    // Five-state Moore FSM
    password_fsm U3 (
                    .clk(clk),
                    .reset(reset),
                    .start_valid(start_pending),
                    .ack(ack),
                    .now_range(now_range),
                    .warn_range(warn_range),
                    .lock_range(lock_range),
                    .critical_range(critical_range),
                    .state(current_state),
                    .green_led(green_led),
                    .yellow_led(yellow_led),
                    .red_led(red_led),
                    .critical_led(critical_led)
                    );

endmodule
