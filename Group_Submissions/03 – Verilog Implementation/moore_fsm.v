`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:11:04
// Design Name: 
// Module Name: moore_fsm
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



module moore_fsm (
    input wire clk,
    input wire reset,
    input wire ack,

    input wire cold,
    input wire neutral,
    input wire hot,

    output reg cold_valve,
    output reg neutral_valve,
    output reg hot_valve,

    output reg [1:0] current_state
);

    // State encoding
    localparam IDLE    = 2'b00;
    localparam COLD    = 2'b01;
    localparam NEUTRAL = 2'b10;
    localparam HOT     = 2'b11;

    // State transition logic
    always @(posedge clk) begin

        if (reset) begin
            current_state <= IDLE;
        end

        else begin

            case (current_state)

                IDLE: begin
                    if (cold)
                        current_state <= COLD;

                    else if (neutral)
                        current_state <= NEUTRAL;

                    else if (hot)
                        current_state <= HOT;
                end

                COLD,
                NEUTRAL,
                HOT: begin
                    if (ack)
                        current_state <= IDLE;
                end

                default:
                    current_state <= IDLE;

            endcase

        end
    end

    // Moore output logic
    always @(*) begin

        cold_valve    = 1'b0;
        neutral_valve = 1'b0;
        hot_valve     = 1'b0;

        case (current_state)

            COLD:
                cold_valve = 1'b1;

            NEUTRAL:
                neutral_valve = 1'b1;

            HOT:
                hot_valve = 1'b1;

            default: begin
                cold_valve    = 1'b0;
                neutral_valve = 1'b0;
                hot_valve     = 1'b0;
            end

        endcase

    end

endmodule
