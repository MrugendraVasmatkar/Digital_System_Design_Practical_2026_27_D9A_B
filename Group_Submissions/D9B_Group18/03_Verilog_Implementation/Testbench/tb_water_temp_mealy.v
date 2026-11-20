`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2026 10:10:42
// Design Name: 
// Module Name: tb
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
module tb_water_temp_mealy;

    reg        clk   = 0;
    reg        rst   = 0;
    reg        en    = 1;
    reg        start = 0;
    reg        ack   = 0;
    reg  [2:0] temp  = 3'd0;

    wire       cold_v, neut_v, hot_v;
    wire [1:0] state;
    wire [2:0] temp_reg;

    integer i;
    integer errors = 0;
    reg [2:0] expected_valves;
    reg [1:0] expected_state;

                                                           // 2. Connect Unit Under Test (UUT)
    waterrtl uut (
        .clk           (clk),
        .rst           (rst),
        .en            (en),
        .start         (start),
        .ack           (ack),
        .temp_in       (temp),
        .cold_valve    (cold_v),
        .neutral_valve (neut_v),
        .hot_valve     (hot_v),
        .state_out     (state),
        .temp_reg_out  (temp_reg)
    );

                                                         // 3. Generate 10ns Clock (100 MHz)
    always #5 clk = ~clk;
                                                    // 4. Test Stimulus & Self-Checking
    initial begin
                                                     // Step A: Apply Reset
        rst = 1;
        #10;
        rst = 0;
        #10;
                                                                       // Step B: Test all 8 temperature values (0 to 7)
        for (i = 0; i < 8; i = i + 1) begin
            temp = i[2:0];
                                                                                // Set expected valve and state for current temperature
            if (i <= 2) begin
                expected_valves = 3'b100; // COLD
                expected_state  = 2'b01;
            end else if (i <= 5) begin
                expected_valves = 3'b010; // NEUTRAL
                expected_state  = 2'b10;
            end else begin
                expected_valves = 3'b001; // HOT
                expected_state  = 2'b11;
            end

            start = 1;
            #2;
            if ({cold_v, neut_v, hot_v} !== expected_valves || state !== 2'b00) begin
                $display("FAIL (Immediate Mealy) at Temp=%0d", i);
                errors = errors + 1;
            end else begin
                $display("PASS (Immediate Mealy) at Temp=%0d -> Valves=%b%b%b, State=%b",
                         i, cold_v, neut_v, hot_v, state);
            end

            @(posedge clk);
            #2;
            if (state !== expected_state) begin
                $display("FAIL (State Latch) at Temp=%0d", i);
                errors = errors + 1;
            end

            start = 0;
            temp  = ~temp;
            #10;
            if ({cold_v, neut_v, hot_v} !== expected_valves) begin
                $display("FAIL (Hold State) at Temp=%0d", i);
                errors = errors + 1;
            end

            ack = 1;
            #2;
            if ({cold_v, neut_v, hot_v} !== 3'b000) begin
                $display("FAIL (Immediate ACK Off) at Temp=%0d", i);
                errors = errors + 1;
            end
            @(posedge clk);
            #2;
            ack = 0;
        end

        temp = 3'd7; start = 1;
        @(posedge clk); #2;      // Enter HOT (11)
        rst = 1; #2;             // Assert Reset -> Valves turn off immediately
        @(posedge clk); #2;      // Clock edge -> State returns to IDLE (00)
        if ({cold_v, neut_v, hot_v} !== 3'b000 || state !== 2'b00) begin
            $display("FAIL (Active Reset)");
            errors = errors + 1;
        end
        rst = 0; start = 0;
end

endmodule
