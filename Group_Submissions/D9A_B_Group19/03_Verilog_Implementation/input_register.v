`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 20:49:31
// Design Name: 
// Module Name: reg_ini
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


module reg_ini(
    input A0,
    input A1,
    input A2,
    input clk,
    output reg [2:0] Q
    );
    always@ (posedge clk)
    begin
    Q[0] = A0;
    Q[1] = A1;
    Q[2] = A2;
    end
endmodule
