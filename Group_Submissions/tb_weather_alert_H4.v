`timescale 1us / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:59:52
// Design Name: 
// Module Name: tb_weather_alert_H4
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

module tb_weather_alert_H4;

    reg clk;
    reg reset;
    reg START;
    reg ACK;
    reg [2:0] Wind;

    wire [1:0] state;

    wire [3:0] Calm_Count;
    wire [3:0] Breezy_Count;
    wire [3:0] Storm_Count;

    wire [3:0] Calm_LED;
    wire [3:0] Breezy_LED;
    wire [3:0] Storm_LED;

    wire Buzzer;

    integer i;
    integer errors;

    integer exp_calm;
    integer exp_breezy;
    integer exp_storm;

    // DUT instantiation
    weather_alert_H4 uut (

        .clk(clk),
        .reset(reset),
        .START(START),
        .ACK(ACK),
        .Wind(Wind),

        .state(state),

        .Calm_Count(Calm_Count),
        .Breezy_Count(Breezy_Count),
        .Storm_Count(Storm_Count),

        .Calm_LED(Calm_LED),
        .Breezy_LED(Breezy_LED),
        .Storm_LED(Storm_LED),

        .Buzzer(Buzzer)
    );

    // Clock generation
    always #5 clk = ~clk;


    initial begin

        // Initial values
        clk = 0;
        reset = 1;
        START = 0;
        ACK = 0;
        Wind = 0;

        errors = 0;

        exp_calm = 0;
        exp_breezy = 0;
        exp_storm = 0;

        // Apply reset
        repeat(2) @(negedge clk);
        reset = 0;

        // Test all 8 wind combinations
        for (i = 0; i < 8; i = i + 1) begin

            // Apply wind input and START
            @(negedge clk);
            Wind = i;
            START = 1;

            // Wait for FSM and counter update
            @(posedge clk);
            #1;

            // Update expected counters
            if (i <= 2)
                exp_calm = exp_calm + 1;

            else if (i <= 5)
                exp_breezy = exp_breezy + 1;

            else
                exp_storm = exp_storm + 1;


            // Check state
            if (i <= 2) begin

                if (state !== 2'b01) begin
                    $display("FAIL: CALM state, Wind=%0d", i);
                    errors = errors + 1;
                end

            end

            else if (i <= 5) begin

                if (state !== 2'b10) begin
                    $display("FAIL: BREEZY state, Wind=%0d", i);
                    errors = errors + 1;
                end

            end

            else begin

                if (state !== 2'b11) begin
                    $display("FAIL: STORM state, Wind=%0d", i);
                    errors = errors + 1;
                end

            end


            // Check counters
            if (Calm_Count !== exp_calm ||
                Breezy_Count !== exp_breezy ||
                Storm_Count !== exp_storm) begin

                $display("FAIL: Counter mismatch at Wind=%0d", i);

                $display("Expected: C=%0d B=%0d S=%0d",
                         exp_calm, exp_breezy, exp_storm);

                $display("Actual: C=%0d B=%0d S=%0d",
                         Calm_Count, Breezy_Count, Storm_Count);

                errors = errors + 1;

            end

            else begin

                $display("PASS: Wind=%0d", i);

                $display("CALM LED   = %b", Calm_LED);
                $display("BREEZY LED = %b", Breezy_LED);
                $display("STORM LED  = %b", Storm_LED);

            end


            // Check buzzer
            if (i >= 6) begin

                if (Buzzer !== 1) begin
                    $display("FAIL: Storm buzzer");
                    errors = errors + 1;
                end

            end

            else begin

                if (Buzzer !== 0) begin
                    $display("FAIL: Buzzer should be OFF");
                    errors = errors + 1;
                end

            end


            // Apply ACK
            @(negedge clk);
            START = 0;
            ACK = 1;

            @(posedge clk);
            #1;

            // Check return to IDLE
            if (state !== 2'b00) begin
                $display("FAIL: ACK did not return to IDLE");
                errors = errors + 1;
            end

            // Check counter retention
            if (Calm_Count !== exp_calm ||
                Breezy_Count !== exp_breezy ||
                Storm_Count !== exp_storm) begin

                $display("FAIL: Counter changed after ACK");
                errors = errors + 1;

            end

            @(negedge clk);
            ACK = 0;

        end


        // Display final counter values
        $display("--------------------------------");
        $display("FINAL COUNTER VALUES");

        $display("CALM   = %b (%0d)",
                 Calm_Count, Calm_Count);

        $display("BREEZY = %b (%0d)",
                 Breezy_Count, Breezy_Count);

        $display("STORM  = %b (%0d)",
                 Storm_Count, Storm_Count);

        $display("--------------------------------");


        // Test RESET
        @(negedge clk);
        reset = 1;

        #1;

        if (state !== 2'b00 ||
            Calm_Count !== 4'b0000 ||
            Breezy_Count !== 4'b0000 ||
            Storm_Count !== 4'b0000) begin

            $display("FAIL: RESET operation");
            errors = errors + 1;

        end

        else begin
            $display("PASS: RESET operation");
        end


        // Final result
        if (errors == 0)
            $display("ALL H4 TESTS PASSED SUCCESSFULLY");

        else
            $display("TOTAL ERRORS = %0d", errors);

        $finish;

    end

endmodule
