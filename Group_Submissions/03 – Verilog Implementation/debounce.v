`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:06:30
// Design Name: 
// Module Name: debounce
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




`timescale 1ns / 1ps

module debounce #(
    parameter CLK_FREQ_HZ = 100_000_000,
    parameter DEBOUNCE_MS = 20
)(
    input wire clk,
    input wire reset,
    input wire button_in,
    output reg button_pulse
);

    // Calculate debounce counter limit
    localparam integer COUNT_MAX =
        (CLK_FREQ_HZ / 1000) * DEBOUNCE_MS;

    localparam integer COUNT_WIDTH =
        (COUNT_MAX <= 1) ? 1 : $clog2(COUNT_MAX + 1);

    // Two-stage synchronizer
    reg sync_ff1;
    reg sync_ff2;

    // Last accepted button state
    reg stable_state;

    // Debounce counter
    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk) begin

        if (reset) begin
            sync_ff1     <= 1'b0;
            sync_ff2     <= 1'b0;
            stable_state <= 1'b0;
            count        <= 0;
            button_pulse <= 1'b0;
        end

        else begin

            // Synchronize asynchronous button input
            sync_ff1 <= button_in;
            sync_ff2 <= sync_ff1;

            // Default output: no pulse
            button_pulse <= 1'b0;

            // Check whether button state has changed
            if (sync_ff2 != stable_state) begin

                if (count >= COUNT_MAX - 1) begin

                    // Accept the new stable state
                    stable_state <= sync_ff2;
                    count <= 0;

                    // Generate pulse only for a press
                    if (sync_ff2 == 1'b1)
                        button_pulse <= 1'b1;

                end

                else begin
                    count <= count + 1'b1;
                end

            end

            else begin
                count <= 0;
            end

        end

    end

endmodule
