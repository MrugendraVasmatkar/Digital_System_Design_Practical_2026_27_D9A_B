`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:37:44
// Design Name: 
// Module Name: tb_gaming_xp_decoder
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


module tb_gaming_xp_decoder;

    reg        clk = 0, reset = 1, start = 0, ack = 0;
    reg  [3:0] xp_in = 0;
    wire       led_b, led_i, led_e, led_m;
    wire [3:0] leds = {led_m, led_e, led_i, led_b}; // Combine all 4 LEDs

    reg  [3:0] exp; // Expected LED pattern
    integer    i;

    // Connect Testbench to Design
    gaming_xp_decoder uut (
        clk, reset, start, ack, xp_in,
        led_b, led_i, led_e, led_m
    );

    // Generate 10ns Clock
    always #5 clk = ~clk;

    initial begin
        #10 reset = 0; // Release reset

        for (i = 0; i < 16; i = i + 1) begin
            xp_in = i;  #10; // Load XP into input register
            start = 1;  #10; // Press START to decode
            start = 0;

            // Expected LED: {Master, Expert, Intermediate, Beginner}
            exp = (i <= 3) ? 4'b0001 :
                  (i <= 7) ? 4'b0010 :
                  (i <= 11)? 4'b0100 : 4'b1000;

            $display("XP=%2d | LEDs=%b | %s", i, leds, (leds === exp) ? "PASS" : "FAIL");

            ack = 1;    #10; // Press ACK to return to IDLE
            ack = 0;
        end

        $finish;
    end

endmodule
