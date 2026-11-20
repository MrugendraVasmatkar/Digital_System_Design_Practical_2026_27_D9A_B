`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 21:38:13
// Design Name: 
// Module Name: Weather_System
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



module Weather_System(
    input wire w1,
    input wire w2,
    input wire w3,

    input wire clk,
    input wire reset,

    output wire s1,
    output wire s2,
    output wire s3,

    output wire [3:0] calm_count,
    output wire [3:0] breezy_count,
    output wire [3:0] storm_count
);

    // Weather Decoder
    FSM_main U1 (
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .s1(s1),
        .s2(s2),
        .s3(s3)
    );

    // Calm Counter
    Counter U2 (
        .clk(clk),
        .reset(reset),
        .en(s1),
        .count(calm_count)
    );

    // Breezy Counter
    Counter U3 (
        .clk(clk),
        .reset(reset),
        .en(s2),
        .count(breezy_count)
    );

    // Storm Counter
    Counter U4 (
        .clk(clk),
        .reset(reset),
        .en(s3),
        .count(storm_count)
    );

endmodule
