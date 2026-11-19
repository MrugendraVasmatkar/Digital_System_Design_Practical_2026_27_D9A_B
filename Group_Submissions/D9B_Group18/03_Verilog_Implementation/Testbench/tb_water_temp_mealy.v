`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 20:33:13
// Design Name: 
// Module Name: tb_water_temp_mealy
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
    reg clk = 0, rst = 0, en = 1, start = 0, ack = 0;
    reg [2:0] temp = 0;
    wire cold_v, neut_v, hot_v;
    wire [1:0] st;
    wire [2:0] treg;
    integer errors = 0, checks = 0, i;

    water_temp_mealy dut (.clk(clk), .rst(rst), .en(en), .start(start), .ack(ack),
        .temp_in(temp), .cold_valve(cold_v), .neutral_valve(neut_v),
        .hot_valve(hot_v), .state_out(st), .temp_reg_out(treg));

    always #5 clk = ~clk;

    task check(input [2:0] exp_valves, input [1:0] exp_state, input [255:0] msg);
        begin
            checks = checks + 1;
            if ({cold_v, neut_v, hot_v} !== exp_valves || st !== exp_state) begin
                errors = errors + 1;
                $display("FAIL [%0s] t=%0t temp=%0d start=%b ack=%b rst=%b | got valves=%b%b%b state=%b | exp valves=%b state=%b",
                    msg, $time, temp, start, ack, rst, cold_v, neut_v, hot_v, st, exp_valves, exp_state);
            end else
                $display("PASS [%0s] temp=%0d valves(C,N,H)=%b%b%b state=%b",
                    msg, temp, cold_v, neut_v, hot_v, st);
        end
    endtask

    reg [2:0] exp_v;
    reg [1:0] exp_s;

    initial begin
        // A. Reset
        rst = 1; @(posedge clk); #1; rst = 0; #2;
        check(3'b000, 2'b00, "after reset");

        // B. All 8 temperatures: START -> hold -> ACK
        for (i = 0; i < 8; i = i + 1) begin
            temp = i[2:0];
            if (i < 3)      begin exp_v = 3'b100; exp_s = 2'b01; end
            else if (i > 5) begin exp_v = 3'b001; exp_s = 2'b11; end
            else            begin exp_v = 3'b010; exp_s = 2'b10; end

            start = 0; ack = 0; #2;
            check(3'b000, 2'b00, "idle no start");

            start = 1; #2;                                   // Mealy: before clock edge
            check(exp_v, 2'b00, "mealy immediate");

            @(posedge clk); #1;
            check(exp_v, exp_s, "state entered");

            start = 0; temp = ~temp; #2;                     // held register keeps category
            check(exp_v, exp_s, "hold state (held temp)");

            ack = 1; #2;                                     // Mealy: ACK drops valve at once
            check(3'b000, exp_s, "ack immediate off");

            @(posedge clk); #1;
            check(3'b000, 2'b00, "back to IDLE");
            ack = 0;
        end

        // C. ACK has priority over START in IDLE
        temp = 3'd0; start = 1; ack = 1; #2;
        check(3'b000, 2'b00, "ack blocks start");
        @(posedge clk); #1;
        check(3'b000, 2'b00, "ack blocks start, still IDLE");
        start = 0; ack = 0; #2;

        // D. RESET has priority over START in IDLE
        temp = 3'd0; start = 1; rst = 1; #2;
        check(3'b000, 2'b00, "reset blocks start");
        @(posedge clk); #1;
        check(3'b000, 2'b00, "reset blocks start, IDLE");
        start = 0; rst = 0; #2;

        // E. RESET from an active state (valve off immediately, IDLE at the edge)
        temp = 3'd7; start = 1; #2; @(posedge clk); #1;
        check(3'b001, 2'b11, "enter HOT");
        rst = 1; #2;
        check(3'b000, 2'b11, "reset kills valve immediately");
        @(posedge clk); #1;
        check(3'b000, 2'b00, "reset -> IDLE");
        rst = 0; start = 0; #2;
        check(3'b000, 2'b00, "idle after reset");

        // F. START=1 while active re-samples live temperature
        temp = 3'd0; start = 1; #2; @(posedge clk); #1;
        check(3'b100, 2'b01, "enter COLD");
        temp = 3'd7; #2;
        check(3'b001, 2'b01, "START=1 live temp valve");
        @(posedge clk); #1;
        check(3'b001, 2'b11, "state follows live temp");
        start = 0; ack = 1; #2;
        check(3'b000, 2'b11, "ack immediate off");
        @(posedge clk); #1;
        check(3'b000, 2'b00, "back to IDLE");
        ack = 0; #2;

        $display("=====================================");
        if (errors == 0) $display("ALL TESTS PASSED (%0d checks)", checks);
        else             $display("TESTS FAILED: %0d errors in %0d checks", errors, checks);
        $display("=====================================");
        $finish;
    end
endmodule