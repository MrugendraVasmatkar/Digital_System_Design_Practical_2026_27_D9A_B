`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 13:43:18
// Design Name: 
// Module Name: gaming_xp
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
    input clk,
    input reset,
    input start,
    input ack,
    input [3:0] xp_in,
    output reg led_beg,
    output reg led_int,
    output reg led_exp,
    output reg [3:0] beg_count,
    output reg [3:0] int_count,
    output reg [3:0] exp_count
);

    localparam IDLE = 2'b00;
    localparam BEG  = 2'b01;
    localparam INT  = 2'b10;
    localparam EXP  = 2'b11;

    reg [3:0] xp_reg;
    reg [1:0] state;
    reg [1:0] next_state;

    wire is_beg;
    wire is_int;
    wire is_exp;

    always @(posedge clk) begin
        if (reset)
            xp_reg <= 4'd0;
        else if (start && (state == IDLE))
            xp_reg <= xp_in;
    end

    assign is_beg = (xp_reg <= 4'd3);
    assign is_int = (xp_reg >= 4'd4) && (xp_reg <= 4'd10);
    assign is_exp = (xp_reg >= 4'd11);

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start) begin
                    if (xp_in <= 4'd3) 
                        next_state = BEG;
                    else if (xp_in >= 4'd4 && xp_in <= 4'd10) 
                        next_state = INT;
                    else 
                        next_state = EXP;
                end
            end
            BEG: begin
                if (ack) 
                    next_state = IDLE;
            end
            INT: begin
                if (ack) 
                    next_state = IDLE;
            end
            EXP: begin
                if (ack) 
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(posedge clk) begin
        if (reset) begin
            beg_count <= 4'd0;
            int_count <= 4'd0;
            exp_count <= 4'd0;
        end else if (start && (state == IDLE)) begin
            if (xp_in <= 4'd3)
                beg_count <= beg_count + 4'b1;
            else if (xp_in >= 4'd4 && xp_in <= 4'd10)
                int_count <= int_count + 4'b1;
            else
                exp_count <= exp_count + 4'b1;
        end
    end

    always @(*) begin
        led_beg = 1'b0;
        led_int = 1'b0;
        led_exp = 1'b0;
        case (state)
            BEG: led_beg = 1'b1;
            INT: led_int = 1'b1;
            EXP: led_exp = 1'b1;
            default: ;
        endcase
    end

endmodule
