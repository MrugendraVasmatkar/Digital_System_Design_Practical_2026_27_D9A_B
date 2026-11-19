`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:12:08
// Design Name: 
// Module Name: category_counters
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



module category_counters (
    input wire clk,
    input wire reset,

    input wire cold_enable,
    input wire neutral_enable,
    input wire hot_enable,

    output reg [3:0] Cold_Count,
    output reg [3:0] Neutral_Count,
    output reg [3:0] Hot_Count
);

    always @(posedge clk) begin

        if (reset) begin
            Cold_Count    <= 4'b0000;
            Neutral_Count <= 4'b0000;
            Hot_Count     <= 4'b0000;
        end

        else begin

            if (cold_enable)
                Cold_Count <= Cold_Count + 1'b1;

            if (neutral_enable)
                Neutral_Count <= Neutral_Count + 1'b1;

            if (hot_enable)
                Hot_Count <= Hot_Count + 1'b1;

        end
    end

endmodule

