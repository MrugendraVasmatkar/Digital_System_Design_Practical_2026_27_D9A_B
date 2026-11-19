`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 21:40:02
// Design Name: 
// Module Name: Weather_System_tb
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

module Weather_System_tb;

    reg w1, w2, w3;
    reg clk, reset;

    wire s1, s2, s3;

    wire [3:0] calm_count;
    wire [3:0] breezy_count;
    wire [3:0] storm_count;

    Weather_System uut (
        .w1(w1),
        .w2(w2),
        .w3(w3),
        .clk(clk),
        .reset(reset),

        .s1(s1),
        .s2(s2),
        .s3(s3),

        .calm_count(calm_count),
        .breezy_count(breezy_count),
        .storm_count(storm_count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer i;

    initial begin

        reset = 0;
        w1 = 0;
        w2 = 0;
        w3 = 0;

        #20;
        reset = 1;

        $monitor(
            "Time=%0t W1=%b W2=%b W3=%b | S1=%b S2=%b S3=%b | Calm=%d Breezy=%d Storm=%d",
            $time, w1, w2, w3,
            s1, s2, s3,
            calm_count, breezy_count, storm_count
        );

        for (i = 0; i < 8; i = i + 1) begin

            {w3, w2, w1} = i;

            repeat (3)
                @(posedge clk);

            #1;
        end

        #20;
        $finish;

    end

endmodule
