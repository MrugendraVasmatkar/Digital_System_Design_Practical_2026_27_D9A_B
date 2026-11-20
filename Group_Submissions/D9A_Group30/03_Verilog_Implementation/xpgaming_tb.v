`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:05:32
// Design Name: 
// Module Name: xpgaming_tb
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


module xpgaming_tb();
   reg        clk, rst, start, ack;
    reg  [3:0] xp;
    wire       green, yellow, red;
    reg  [2:0] exp_led;                  // expected {red, yellow, green}
    integer    i, errors;

    xp_mealy dut (clk, rst, start, ack, xp, green, yellow, red);

    // 1) Clock: period 10 ns
    initial clk = 0;
    always #5 clk = ~clk;

    // 2) Checker: compares LEDs with the expected value
    task check(input [2:0] e);
        if ({red, yellow, green} !== e) begin
            errors = errors + 1;
            $display("FAIL: XP=%0d  got RYG=%b  expected=%b", xp, {red,yellow,green}, e);
        end
    endtask

    // 3) Test sequence
    initial begin
        errors = 0; xp = 0; start = 0; ack = 0;
        rst = 1; #12 rst = 0;                    // RESET -> IDLE
        check(3'b000);                           // LEDs off after reset

        for (i = 0; i < 16; i = i + 1) begin
            exp_led = (i <= 3) ? 3'b001 :        // Beginner     -> green
                      (i <= 10) ? 3'b010 :       // Intermediate -> yellow
                                  3'b100;        // Expert       -> red

            @(negedge clk); xp = i; start = 1;   // give XP and START
            #1 check(exp_led);                   // Mealy: LED on BEFORE the clock edge

            @(negedge clk); start = 0;           // clock edge has passed
            #1 check(exp_led);                   // LED is held

            ack = 1;
            #1 check(3'b000);                    // ACK: LED off immediately

            @(negedge clk); ack = 0;             // back in IDLE
            #1 check(3'b000);
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end
endmodule
