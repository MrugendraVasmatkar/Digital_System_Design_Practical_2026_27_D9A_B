`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:35:38
// Design Name: 
// Module Name: gaming_xp_decoder
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


module gaming_xp_decoder (
    input  wire       clk, reset, start, ack,
    input  wire [3:0] xp_in,
    output wire       led_beginner, led_intermediate, led_expert, led_master
);

    // 5-State Encoding (000 to 100)
    localparam IDLE = 3'd0, BEG = 3'd1, INT = 3'd2, EXP = 3'd3, MAS = 3'd4;

    reg [3:0] xp_reg;
    reg [2:0] state;

    // Range Decoder 1 & 2 (Combinational Comparators)
    wire is_beg  = (xp_reg <= 4'd3);
    wire is_int  = (xp_reg >= 4'd4 && xp_reg <= 4'd7);
    wire greater = (xp_reg >  4'd7);
    wire is_exp  = greater && (xp_reg <= 4'd11);
    wire is_mas  = greater && (xp_reg >  4'd11);

    // Input Register + Moore FSM Controller
    always @(posedge clk) begin
        if (reset) begin
            state  <= IDLE;
            xp_reg <= 4'd0;
        end else begin
            case (state)
                IDLE: begin
                    xp_reg <= xp_in; // Capture XP switches
                    if (start) begin
                        if      (is_beg) state <= BEG;
                        else if (is_int) state <= INT;
                        else if (is_exp) state <= EXP;
                        else if (is_mas) state <= MAS;
                    end
                end
                default: if (ack) state <= IDLE; // Return to IDLE on ACK
            endcase
        end
    end

    // Moore Outputs (Each LED turns ON only in its own state)
    assign led_beginner     = (state == BEG);
    assign led_intermediate = (state == INT);
    assign led_expert       = (state == EXP);
    assign led_master       = (state == MAS);

endmodule
