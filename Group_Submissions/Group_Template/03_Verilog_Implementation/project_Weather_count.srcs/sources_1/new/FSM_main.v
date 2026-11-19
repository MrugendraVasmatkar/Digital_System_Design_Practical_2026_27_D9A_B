`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 20:34:55
// Design Name: 
// Module Name: FSM_main
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

module FSM_main (
    input   w1,
    input   w2,
    input   w3,

    output wire s1,  // Calm
    output wire s2,  // Breezy
    output wire s3   // Storm
);

  
    assign s1 = ~w3 & (~w2 | ~w1);


    assign s2 = (w3 & ~w2) | (~w3 & w1);


    assign s3 = w3 & w2;

endmodule