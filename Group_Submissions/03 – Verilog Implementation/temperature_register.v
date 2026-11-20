`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:08:25
// Design Name: 
// Module Name: temperature_register
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



module temperature_register (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] temperature_input,

    output reg [2:0] temperature_stored
);

    always @(posedge clk) begin

        if (reset) begin
            temperature_stored <= 3'b000;
        end

        else if (start) begin
            temperature_stored <= temperature_input;
        end

    end

endmodule

