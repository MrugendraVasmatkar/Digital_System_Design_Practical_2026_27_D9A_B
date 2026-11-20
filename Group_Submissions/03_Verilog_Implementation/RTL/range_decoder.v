`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 01:57:20 PM
// Design Name: 
// Module Name: range_decoder
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



module range_decoder (
    input wire [2:0] attempt,
    output wire now_range,
    output wire warn_range,
    output wire lock_range,
    output wire critical_range
);

    assign now_range      = (attempt <= 3'd1);
    assign warn_range     = (attempt >= 3'd2 && attempt <= 3'd3);
    assign lock_range     = (attempt >= 3'd4 && attempt <= 3'd5);
    assign critical_range = (attempt >= 3'd6 && attempt <= 3'd7);

endmodule

