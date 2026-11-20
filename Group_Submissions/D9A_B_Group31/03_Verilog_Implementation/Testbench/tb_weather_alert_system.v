`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 07:32:22 PM
// Design Name: 
// Module Name: tb_weather_alert_system
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
module tb_weather_alert_system;

    reg        clk;
    reg        rst;
    reg        start;
    reg        ack;
    reg  [3:0] w;
    wire       idle_led;
    wire       calm_led;
    wire       breezy_led;
    wire       stormy_led;
    wire       error_led;

    weather_alert_system uut (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .ack        (ack),
        .w          (w),
        .idle_led   (idle_led),
        .calm_led   (calm_led),
        .breezy_led (breezy_led),
        .stormy_led (stormy_led),
        .error_led  (error_led)
    );

    always #5 clk = ~clk;

    initial begin
        clk   = 0;
        rst   = 1;
        start = 0;
        ack   = 0;
        w     = 4'd0;
        #10;

        rst = 0;
        #10;

        // Test 1: Value = 2 (<= 2) -> calm_led ON
        w     = 4'd2;
        start = 1;
        #20;
        start = 0;
        #10;

        // Acknowledge -> back to idle_led
        ack = 1;
        #10;
        ack = 0;
        #10;

        // Test 2: Value = 4 (> 2) -> breezy_led ON
        w     = 4'd4;
        start = 1;
        #20;
        start = 0;
        #10;

        ack = 1;
        #10;
        ack = 0;
        #10;

        // Test 3: Value = 6 (> 5) -> stormy_led ON
        w     = 4'd6;
        start = 1;
        #20;
        start = 0;
        #10;

        ack = 1;
        #10;
        ack = 0;
        #10;

        // Test 4: Value = 9 (> 7) -> error_led ON
        w     = 4'd9;
        start = 1;
        #20;
        start = 0;
        #10;

        ack = 1;
        #10;
        ack = 0;
        #20;

        $finish;
    end

endmodule
