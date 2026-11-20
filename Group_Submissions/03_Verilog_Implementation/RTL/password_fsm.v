`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 01:57:20 PM
// Design Name: 
// Module Name: password_fsm
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



module password_fsm (
    input wire clk,
    input wire reset,
    input wire start_valid,
    input wire ack,

    input wire now_range,
    input wire warn_range,
    input wire lock_range,
    input wire critical_range,

    output reg [2:0] state,
    output reg green_led,
    output reg yellow_led,
    output reg red_led,
    output reg critical_led
);

    localparam IDLE     = 3'b000;
    localparam NOW      = 3'b001;
    localparam WARN     = 3'b010;
    localparam LOCK     = 3'b011;
    localparam CRITICAL = 3'b100;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;

        else begin
            case (state)

                IDLE: begin
                    if (start_valid) begin
                        if (now_range)
                            state <= NOW;
                        else if (warn_range)
                            state <= WARN;
                        else if (lock_range)
                            state <= LOCK;
                        else if (critical_range)
                            state <= CRITICAL;
                        else
                            state <= IDLE;
                    end
                end

                NOW: begin
                    if (ack)
                        state <= IDLE;
                end

                WARN: begin
                    if (ack)
                        state <= IDLE;
                end

                LOCK: begin
                    if (ack)
                        state <= IDLE;
                end

                CRITICAL: begin
                    if (ack)
                        state <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

    // Moore output logic
    always @(*) begin
        green_led    = 1'b0;
        yellow_led   = 1'b0;
        red_led      = 1'b0;
        critical_led = 1'b0;

        case (state)
            NOW:      green_led    = 1'b1;
            WARN:     yellow_led   = 1'b1;
            LOCK:     red_led      = 1'b1;
            CRITICAL: critical_led = 1'b1;

            default: begin
                green_led    = 1'b0;
                yellow_led   = 1'b0;
                red_led      = 1'b0;
                critical_led = 1'b0;
            end
        endcase
    end

endmodule

