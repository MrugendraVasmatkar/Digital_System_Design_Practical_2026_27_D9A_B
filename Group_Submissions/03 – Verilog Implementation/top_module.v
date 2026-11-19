`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:14:53
// Design Name: 
// Module Name: top_module
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



`timescale 1ns / 1ps


module top_module #(
    parameter CLK_FREQ_HZ = 100_000_000,
    parameter DEBOUNCE_MS = 20
) (


    input wire clk,

    input wire [15:0] SW,
    input wire [3:0] BTN,

    output wire [15:0] LED,

    output wire [3:0] D0_AN,
    output wire [7:0] D0_SEG,

    output wire [3:0] D1_AN,
    output wire [7:0] D1_SEG

);

    // Button signals
    wire start_pulse;
    wire ack_pulse;
    wire reset_pulse;

    // Temperature signals
    wire [2:0] temperature_stored;

    // Comparator outputs
    wire cold;
    wire neutral;
    wire hot;

    // FSM signals
    wire cold_valve;
    wire neutral_valve;
    wire hot_valve;

    wire [1:0] current_state;

    // Counter outputs
    wire [3:0] Cold_Count;
    wire [3:0] Neutral_Count;
    wire [3:0] Hot_Count;

    // Delayed START for comparator
    reg start_delayed;

    // ------------------------------------------------
    // 1. START BUTTON DEBOUNCER
    // ------------------------------------------------

    debounce START_BUTTON (
        .clk(clk),
        .reset(reset_pulse),
        .button_in(BTN[0]),
        .button_pulse(start_pulse)
    );

    // ------------------------------------------------
    // 2. ACK BUTTON DEBOUNCER
    // ------------------------------------------------

    debounce ACK_BUTTON (
        .clk(clk),
        .reset(reset_pulse),
        .button_in(BTN[1]),
        .button_pulse(ack_pulse)
    );

    // ------------------------------------------------
    // 3. RESET BUTTON DEBOUNCER
    // ------------------------------------------------

    debounce RESET_BUTTON (
        .clk(clk),
        .reset(1'b0),
        .button_in(BTN[2]),
        .button_pulse(reset_pulse)
    );

    // ------------------------------------------------
    // 4. TEMPERATURE INPUT REGISTER
    // ------------------------------------------------

    temperature_register TEMP_REGISTER (
        .clk(clk),
        .reset(reset_pulse),
        .start(start_pulse),
        .temperature_input(SW[2:0]),
        .temperature_stored(temperature_stored)
    );

    // ------------------------------------------------
    // 5. DELAY START BY ONE CLOCK CYCLE
    // ------------------------------------------------

    always @(posedge clk) begin

        if (reset_pulse)
            start_delayed <= 1'b0;

        else
            start_delayed <= start_pulse;

    end

    // ------------------------------------------------
    // 6. TEMPERATURE COMPARATOR
    // ------------------------------------------------

    temperature_comparator TEMP_COMPARATOR (
        .clk(clk),
        .reset(reset_pulse),
        .start(start_delayed),
        .temperature(temperature_stored),
        .cold(cold),
        .neutral(neutral),
        .hot(hot)
    );

    // ------------------------------------------------
    // 7. MOORE FSM
    // ------------------------------------------------

    moore_fsm FSM (
        .clk(clk),
        .reset(reset_pulse),
        .ack(ack_pulse),

        .cold(cold),
        .neutral(neutral),
        .hot(hot),

        .cold_valve(cold_valve),
        .neutral_valve(neutral_valve),
        .hot_valve(hot_valve),

        .current_state(current_state)
    );

    // ------------------------------------------------
    // 8. H4 CATEGORY COUNTERS
    // ------------------------------------------------

    category_counters COUNTERS (
        .clk(clk),
        .reset(reset_pulse),

        .cold_enable(cold),
        .neutral_enable(neutral),
        .hot_enable(hot),

        .Cold_Count(Cold_Count),
        .Neutral_Count(Neutral_Count),
        .Hot_Count(Hot_Count)
    );

    // ------------------------------------------------
    // 9. SEVEN-SEGMENT DISPLAY
    // ------------------------------------------------

    seven_segment DISPLAY (
        .clk(clk),
        .reset(reset_pulse),

        .select_cold(SW[3]),
        .select_neutral(SW[4]),
        .select_hot(SW[5]),

        .Cold_Count(Cold_Count),
        .Neutral_Count(Neutral_Count),
        .Hot_Count(Hot_Count),

        .temperature(temperature_stored),

        .D0_AN(D0_AN),
        .D0_SEG(D0_SEG),

        .D1_AN(D1_AN),
        .D1_SEG(D1_SEG)
    );

    // ------------------------------------------------
    // 10. VALVE LED OUTPUTS
    // ------------------------------------------------

    assign LED[0] = cold_valve;
    assign LED[1] = neutral_valve;
    assign LED[2] = hot_valve;

    assign LED[3] = (current_state != 2'b00);

    assign LED[15:4] = 12'b000000000000;

endmodule
