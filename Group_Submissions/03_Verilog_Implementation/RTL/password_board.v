`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 03:27:45 PM
// Design Name: 
// Module Name: password_board
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



module password_board (
    input wire clk,
    input wire [2:0] sw,
    input wire [2:0] btn,
    output wire [3:0] led
);

    password_monitor_top U1 (
        .clk(clk),
        .reset(btn[0]),
        .start(btn[1]),
        .ack(btn[2]),
        .attempt_switch(sw),
        .green_led(led[0]),
        .yellow_led(led[1]),
        .red_led(led[2]),
        .critical_led(led[3])
    );

endmodule

