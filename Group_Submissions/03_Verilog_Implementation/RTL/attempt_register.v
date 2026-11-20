`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 01:57:20 PM
// Design Name: 
// Module Name: attempt_register
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



module attempt_register (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [2:0] attempt_in,
    output reg [2:0] attempt_out
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            attempt_out <= 3'b000;
        else if (load)
            attempt_out <= attempt_in;
    end

endmodule

