`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 06:59:03 PM
// Design Name: 
// Module Name: weather_alert_system
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
module weather_alert_system (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire       ack,
    input  wire [3:0] w,          // 4-bit input value (W3, W2, W1, W0)
    output wire       idle_led,
    output wire       calm_led,
    output wire       breezy_led,
    output wire       stormy_led,
    output wire       error_led
);

    reg [3:0] input_reg;
    reg [2:0] state_reg;
    reg [2:0] encoded_state;

    // 1. Input Register (stores 4-bit value W3..W0 on every clock)
    always @(posedge clk or posedge rst) begin
        if (rst)
            input_reg <= 4'd0;
        else
            input_reg <= w;
    end

    // 2. Comparators (>2, >5, >7) + Priority Encoder
    always @(*) begin
        if (input_reg > 4'd7)
            encoded_state = 3'd4; // Error (> 7)
        else if (input_reg > 4'd5)
            encoded_state = 3'd3; // Stormy (6 to 7)
        else if (input_reg > 4'd2)
            encoded_state = 3'd2; // Breezy (3 to 5)
        else
            encoded_state = 3'd1; // Calm (0 to 2)
    end

    // 3. 4-to-1 MUX + State Register (controlled by ACK and START)
    always @(posedge clk or posedge rst) begin
        if (rst)
            state_reg <= 3'd0;          // Async Reset -> Idle
        else if (ack)
            state_reg <= 3'd0;          // ACK = 1 -> Return to Idle
        else if (start)
            state_reg <= encoded_state; // START = 1 -> Load new weather state
        else
            state_reg <= state_reg;     // Hold current state
    end

    // 4. 3-to-8 Decoder Outputs (5 Status LEDs)
    assign idle_led   = (state_reg == 3'd0);
    assign calm_led   = (state_reg == 3'd1);
    assign breezy_led = (state_reg == 3'd2);
    assign stormy_led = (state_reg == 3'd3);
    assign error_led  = (state_reg == 3'd4);

endmodule
