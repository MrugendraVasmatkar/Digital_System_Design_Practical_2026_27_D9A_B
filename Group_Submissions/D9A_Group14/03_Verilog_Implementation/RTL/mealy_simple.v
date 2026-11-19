`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:39:43
// Design Name: 
// Module Name: mealy_game
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


module mealy_simple (
    input        clk, reset, start, ack,
    input  [3:0] score,
    output       low_led, med_led, high_led
);
    parameter IDLE = 2'd0, LOW = 2'd1, MED = 2'd2, HIGH = 2'd3;
    reg [1:0] state;

    // 1) State register + next-state logic
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else if (state == IDLE) begin
            if (start) begin
                if (score <= 4)       state <= LOW;
                else if (score <= 10) state <= MED;
                else                  state <= HIGH;
            end
        end
        else if (ack)                 // LOW, MED or HIGH
            state <= IDLE;
    end

    // 2) Mealy outputs: depend on state AND inputs (start, score, ack)
    assign low_led  = (state == IDLE && start && score <= 4)
                   || (state == LOW  && !ack);
    assign med_led  = (state == IDLE && start && score >= 5 && score <= 10)
                   || (state == MED  && !ack);
    assign high_led = (state == IDLE && start && score >= 11)
                   || (state == HIGH && !ack);
endmodule
