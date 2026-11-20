`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 20:30:37
// Design Name: 
// Module Name: water_temp_mealy
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



// Mealy water temperature classifier - mirrors the Logisim circuit block by block
module water_temp_mealy (
    input  wire       clk,
    input  wire       rst,        // synchronous, active-high (acts through enable e)
    input  wire       en,         // clock enable (tie to 1)
    input  wire       start,
    input  wire       ack,
    input  wire [2:0] temp_in,
    output wire       cold_valve,
    output wire       neutral_valve,
    output wire       hot_valve,
    output wire [1:0] state_out,
    output wire [2:0] temp_reg_out
);
    // 00 IDLE, 01 COLD, 10 NEUTRAL, 11 HOT
    reg [1:0] state    = 2'b00;
    reg [2:0] temp_reg = 3'b000;

    assign state_out    = state;
    assign temp_reg_out = temp_reg;

    // 2) Input select: live temp when START, else held register
    wire [2:0] temp_sel = start ? temp_in : temp_reg;

    // 3) Range decoder
    wire cat_cold    = (temp_sel < 3'd3);
    wire cat_hot     = (temp_sel > 3'd5);
    wire cat_neutral = ~(cat_cold | cat_hot);

    // 4) Mealy enable: e = v AND NOT(ACK OR RESET), v = START OR state != IDLE
    wire valid = start | (state != 2'b00);
    wire e     = valid & ~(ack | rst);

    // 5) Mealy outputs: depend on state (via v) and inputs
    assign cold_valve    = e & cat_cold;
    assign neutral_valve = e & cat_neutral;
    assign hot_valve     = e & cat_hot;

    // 6) State register: S1' = e & ~cold, S0' = e & ~neutral
    wire [1:0] next_state = { e & ~cat_cold, e & ~cat_neutral };

    always @(posedge clk) begin
        if (en) begin
            state <= next_state;
            if (start) temp_reg <= temp_in;   // input register loads on START
        end
    end
endmodule