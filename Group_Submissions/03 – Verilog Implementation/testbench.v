`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 15:24:41
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



`timescale 1ns / 1ps

module testbench;

// Clock and board inputs
    reg clk;
    reg [15:0] SW;
    reg [3:0] BTN;

// Board outputs
    wire [15:0] LED;

wire [3:0] D0_AN;
    wire [7:0] D0_SEG;

wire [3:0] D1_AN;
    wire [7:0] D1_SEG;

// Expected counter values
    integer test_number;

// Instantiate complete system
    // Reduced debounce count for faster simulation
    top_module #(
        .CLK_FREQ_HZ(100_000),
        .DEBOUNCE_MS(1)
    ) DUT (
        .clk(clk),
        .SW(SW),
        .BTN(BTN),
        .LED(LED),
        .D0_AN(D0_AN),
        .D0_SEG(D0_SEG),
        .D1_AN(D1_AN),
        .D1_SEG(D1_SEG)
    );

// 100 MHz clock (10 ns period)
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

// ------------------------------------------------
    // TASK 1: PRESS AND RELEASE A BUTTON
    // ------------------------------------------------

task press_button;
        input integer button_number;

        begin

@(negedge clk);
            BTN[button_number] = 1'b1;

// Wait for debounce to accept press
            repeat (120) @(negedge clk);

            BTN[button_number] = 1'b0;

// Wait for debounce to accept release
            repeat (120) @(negedge clk);

end
    endtask

// ------------------------------------------------
    // TASK 2: CHECK COUNTERS AND FSM
    // ------------------------------------------------

task check_counters;
        input [3:0] expected_cold;
        input [3:0] expected_neutral;
        input [3:0] expected_hot;

        begin

            #20;

if (DUT.Cold_Count !== expected_cold) begin
                $display("ERROR: Cold counter incorrect");
                $display("Expected: %d Actual: %d",
                    expected_cold, DUT.Cold_Count);
                $fatal;
            end

if (DUT.Neutral_Count !== expected_neutral) begin
                $display("ERROR: Neutral counter incorrect");
                $display("Expected: %d Actual: %d",
                    expected_neutral, DUT.Neutral_Count);
                $fatal;
            end

if (DUT.Hot_Count !== expected_hot) begin
                $display("ERROR: Hot counter incorrect");
                $display("Expected: %d Actual: %d",
                    expected_hot, DUT.Hot_Count);
                $fatal;
            end

$display("COUNTERS: Cold=%d Neutral=%d Hot=%d",
                DUT.Cold_Count,
                DUT.Neutral_Count,
                DUT.Hot_Count);

end
    endtask

// ------------------------------------------------
    // TASK 3: CLASSIFY A TEMPERATURE
    // ------------------------------------------------

    task classify_temperature;

input [2:0] temperature;
        input [1:0] expected_state;

input [3:0] expected_cold;
        input [3:0] expected_neutral;
        input [3:0] expected_hot;

        begin

            test_number = test_number + 1;

$display("------------------------------------");
            $display("TEST %0d", test_number);
            $display("Temperature input = %b", temperature);

// Set temperature switches
            SW[2:0] = temperature;

// Press START
            press_button(0);

// Check FSM state
            if (DUT.current_state !== expected_state) begin

$display("ERROR: FSM state incorrect");
                $display("Expected state = %b",
                    expected_state);
                $display("Actual state = %b",
                    DUT.current_state);

                $fatal;

            end

// Check valve LEDs
            case (expected_state)

2'b01: begin
                    if (LED[2:0] !== 3'b001)
                        $fatal(1, "Cold valve LED error");
                end

2'b10: begin
                    if (LED[2:0] !== 3'b010)
                        $fatal(1, "Neutral valve LED error");
                end

2'b11: begin
                    if (LED[2:0] !== 3'b100)
                        $fatal(1, "Hot valve LED error");
                end

            endcase

$display("FSM STATE: %b", DUT.current_state);
            $display("LED OUTPUT: %b", LED[2:0]);

// Check counter values
            check_counters(
                expected_cold,
                expected_neutral,
                expected_hot
            );

            $display("RESULT: PASS");

// Press ACK
            press_button(1);

// Check return to IDLE
            if (DUT.current_state !== 2'b00)
                $fatal(1, "FSM failed to return to IDLE");

if (LED[2:0] !== 3'b000)
                $fatal(1, "Valve LEDs failed to turn OFF");

            $display("ACK: FSM returned to IDLE");

end
    endtask

// ------------------------------------------------
    // MAIN TEST SEQUENCE
    // ------------------------------------------------

    initial begin

// Initialize signals
        SW = 16'b0;
        BTN = 4'b0000;
        test_number = 0;

$display("====================================");
        $display(" WATER TEMPERATURE CLASSIFIER");
        $display(" COMPLETE SYSTEM SIMULATION");
        $display("====================================");

// Allow initial clock cycles
        repeat (10) @(negedge clk);

// Press RESET
        $display("RESET TEST");

        press_button(2);

        check_counters(0, 0, 0);

if (DUT.current_state !== 2'b00)
            $fatal(1, "Reset failed");

        $display("RESET TEST: PASS");

// --------------------------------------------
        // COLD TEMPERATURE TESTS
        // --------------------------------------------

classify_temperature(
            3'b000, 2'b01, 1, 0, 0
        );

classify_temperature(
            3'b001, 2'b01, 2, 0, 0
        );

classify_temperature(
            3'b010, 2'b01, 3, 0, 0
        );

// --------------------------------------------
        // NEUTRAL TEMPERATURE TESTS
        // --------------------------------------------

classify_temperature(
            3'b011, 2'b10, 3, 1, 0
        );

classify_temperature(
            3'b100, 2'b10, 3, 2, 0
        );

classify_temperature(
            3'b101, 2'b10, 3, 3, 0
        );

// --------------------------------------------
        // HOT TEMPERATURE TESTS
        // --------------------------------------------

classify_temperature(
            3'b110, 2'b11, 3, 3, 1
        );

classify_temperature(
            3'b111, 2'b11, 3, 3, 2
        );

// --------------------------------------------
        // DISPLAY SELECTION TESTS
        // --------------------------------------------

$display("------------------------------------");
        $display("DISPLAY SELECTION TEST");

// Cold counter selection
        SW[5:3] = 3'b001;
        #20;

if (DUT.DISPLAY.display_value !== 4'd3)
            $fatal(1, "Cold display selection failed");

        $display("Cold display: PASS");

// Neutral counter selection
        SW[5:3] = 3'b010;
        #20;

if (DUT.DISPLAY.display_value !== 4'd3)
            $fatal(1, "Neutral display selection failed");

        $display("Neutral display: PASS");

// Hot counter selection
        SW[5:3] = 3'b100;
        #20;

if (DUT.DISPLAY.display_value !== 4'd2)
            $fatal(1, "Hot display selection failed");

        $display("Hot display: PASS");

// No selection: show temperature
        SW[5:3] = 3'b000;
        #20;

if (DUT.DISPLAY.display_value !== 4'd7)
            $fatal(1, "Temperature display selection failed");

        $display("Temperature display: PASS");

// --------------------------------------------
        // FINAL RESULT
        // --------------------------------------------

$display("====================================");
        $display(" ALL TESTS PASSED SUCCESSFULLY");
        $display("====================================");

$display("FINAL COLD COUNT    = %d",
            DUT.Cold_Count);

$display("FINAL NEUTRAL COUNT = %d",
            DUT.Neutral_Count);

$display("FINAL HOT COUNT     = %d",
            DUT.Hot_Count);

        $display("====================================");

        $finish;

    end

// Simulation timeout protection
    initial begin
        #1000000;
        $fatal(1, "SIMULATION TIMEOUT");
    end

endmodule
