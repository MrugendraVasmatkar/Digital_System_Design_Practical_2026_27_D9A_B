`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 13:44:57
// Design Name: 
// Module Name: tb_gaming_xp
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
`timescale 1ns/1ps

module tb_gaming_xp_decoder;

    reg clk;
    reg reset;
    reg start;
    reg ack;
    reg [3:0] xp_in;

    wire led_beg;
    wire led_int;
    wire led_exp;
    wire [3:0] beg_count;
    wire [3:0] int_count;
    wire [3:0] exp_count;

    gaming_xp_decoder uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .xp_in(xp_in),
        .led_beg(led_beg),
        .led_int(led_int),
        .led_exp(led_exp),
        .beg_count(beg_count),
        .int_count(int_count),
        .exp_count(exp_count)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        ack = 0;
        xp_in = 4'd0;

        #20;
        reset = 0;
        #10;

        xp_in = 4'd2;
        start = 1;
        #10;
        start = 0;
        #20;

        if (led_beg !== 1'b1 || beg_count !== 4'd1) begin
            $display("ERROR: XP=2, expected led_beg=1, beg_count=1. Got led_beg=%b, beg_count=%d", led_beg, beg_count);
        end else begin
            $display("SUCCESS: XP=2 passed.");
        end

        ack = 1;
        #10;
        ack = 0;
        #20;

        xp_in = 4'd7;
        start = 1;
        #10;
        start = 0;
        #20;

        if (led_int !== 1'b1 || int_count !== 4'd1) begin
            $display("ERROR: XP=7, expected led_int=1, int_count=1. Got led_int=%b, int_count=%d", led_int, int_count);
        end else begin
            $display("SUCCESS: XP=7 passed.");
        end

        ack = 1;
        #10;
        ack = 0;
        #20;

        xp_in = 4'd14;
        start = 1;
        #10;
        start = 0;
        #20;

        if (led_exp !== 1'b1 || exp_count !== 4'd1) begin
            $display("ERROR: XP=14, expected led_exp=1, exp_count=1. Got led_exp=%b, exp_count=%d", led_exp, exp_count);
        end else begin
            $display("SUCCESS: XP=14 passed.");
        end

        ack = 1;
        #10;
        ack = 0;
        #20;

        xp_in = 4'd1;
        start = 1;
        #10;
        start = 0;
        #20;

        if (led_beg !== 1'b1 || beg_count !== 4'd2) begin
            $display("ERROR: XP=1, expected led_beg=1, beg_count=2. Got led_beg=%b, beg_count=%d", led_beg, beg_count);
        end else begin
            $display("SUCCESS: XP=1 passed.");
        end

        ack = 1;
        #10;
        ack = 0;
        #20;

        $display("FINAL COUNTS - Beginner: %d, Intermediate: %d, Expert: %d", beg_count, int_count, exp_count);
        $finish;
    end

endmodule
