`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:13:06
// Design Name: 
// Module Name: xplevel
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


module xp_mealy (
    input        clk, rst, start, ack,
    input  [3:0] xp,
    output reg   green, yellow, red    
);
    parameter IDLE = 2'b00,
     BEG = 2'b01, 
     INT = 2'b10, 
     EXP = 2'b11;
    reg [1:0] state, next;

   
    always @(posedge clk or posedge rst)
        if (rst) state <= IDLE;
        else     state <= next;

   
    always @(*) begin
        next = state;                   
        green = 0; yellow = 0; red = 0; 

        case (state)
            IDLE: if (start) 
            begin      
                      if      (xp <= 3)
                        begin next = BEG; green  = 1;
                         end
                      else if (xp <= 10)
                       begin next = INT; yellow = 1;
                        end
                      else              
                       begin next = EXP; red    = 1;
                        end
                  end
            BEG:  if (ack) next = IDLE;
             else green  = 1;
            INT:  if (ack) next = IDLE;
             else yellow = 1;
            EXP:  if (ack) next = IDLE;
             else red    = 1;
        endcase
    end
endmodule