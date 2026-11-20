`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2026 02:34:24 PM
// Design Name: 
// Module Name: testbench
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


module testbench;

    reg clk;
    reg reset;
    reg start;
    reg ack;
    reg [2:0] attempt_switch;

    wire green_led;
    wire yellow_led;
    wire red_led;
    wire critical_led;

    password_monitor_top DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .attempt_switch(attempt_switch),
        .green_led(green_led),
        .yellow_led(yellow_led),
        .red_led(red_led),
        .critical_led(critical_led)
    );

    // 100 MHz clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // Initial values
        reset = 1;
        start = 0;
        ack = 0;
        attempt_switch = 3'b000;

        #20;
        reset = 0;

        // Attempt 0: NOW - Green LED
        #10;
        attempt_switch = 3'b000;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 1: NOW - Green LED
        #10;
        attempt_switch = 3'b001;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 2: WARN - Yellow LED
        #10;
        attempt_switch = 3'b010;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 3: WARN - Yellow LED
        #10;
        attempt_switch = 3'b011;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 4: LOCK - Red LED
        #10;
        attempt_switch = 3'b100;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 5: LOCK - Red LED
        #10;
        attempt_switch = 3'b101;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 6: CRITICAL - Fourth LED
        #10;
        attempt_switch = 3'b110;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Attempt 7: CRITICAL - Fourth LED
        #10;
        attempt_switch = 3'b111;
        start = 1;
        #10;
        start = 0;
        #20;
        ack = 1;
        #10;
        ack = 0;

        // Final reset test
        #10;
        reset = 1;
        #20;
        reset = 0;

    end

endmodule
