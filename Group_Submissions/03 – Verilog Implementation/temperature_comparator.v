`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:09:56
// Design Name: 
// Module Name: temperature_comparator
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



module temperature_comparator (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [2:0] temperature,

    output reg cold,
    output reg neutral,
    output reg hot
);

    always @(posedge clk) begin

        if (reset) begin
            cold    <= 1'b0;
            neutral <= 1'b0;
            hot     <= 1'b0;
        end

        else if (start) begin

            // Clear all previous category outputs
            cold    <= 1'b0;
            neutral <= 1'b0;
            hot     <= 1'b0;

            // Temperature classification
            case (temperature)

                3'b000,
                3'b001,
                3'b010:
                    cold <= 1'b1;

                3'b011,
                3'b100,
                3'b101:
                    neutral <= 1'b1;

                3'b110,
                3'b111:
                    hot <= 1'b1;

            endcase
        end

        else begin
            cold    <= 1'b0;
            neutral <= 1'b0;
            hot     <= 1'b0;
        end

    end

endmodule
