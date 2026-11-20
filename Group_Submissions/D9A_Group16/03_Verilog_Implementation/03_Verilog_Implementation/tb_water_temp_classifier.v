`timescale 1ns / 1ps
module tb_water_temp_classifier;
    reg clk = 0, reset = 0, start = 0, ack = 0;
    reg [2:0] temp = 0;
    wire vc, cold, neut, hot;
    wire [2:0] st;
    integer pass = 0, fail = 0, i;

    water_temp_classifier dut (
        .clk(clk), .reset(reset), .start(start), .ack(ack), .temp(temp),
        .vc_valve(vc), .cold_valve(cold), .neutral_valve(neut),
        .hot_valve(hot), .state_out(st)
    );

    always #5 clk = ~clk;   // 100 MHz

    // ---- helper tasks ----
    task check(input [3:0] exp_valves, input [2:0] exp_state, input [255:0] msg);
        begin
            if ({hot, neut, cold, vc} === exp_valves && st === exp_state) begin
                pass = pass + 1;
                $display("[PASS] t=%0t %0s | valves(H N C VC)=%b state=%b", $time, msg, {hot,neut,cold,vc}, st);
            end else begin
                fail = fail + 1;
                $display("[FAIL] t=%0t %0s | got valves=%b state=%b, expected valves=%b state=%b",
                          $time, msg, {hot,neut,cold,vc}, st, exp_valves, exp_state);
            end
        end
    endtask

    task pulse_start; begin start = 1; @(posedge clk); #1 start = 0; end endtask
    task pulse_ack;   begin ack   = 1; @(posedge clk); #1 ack   = 0; end endtask
    task do_reset;    begin reset = 1; @(posedge clk); #1 reset = 0; end endtask

    // apply one temperature, check valve, then ACK and check IDLE
    task run_case(input [2:0] t, input [3:0] exp_valves, input [2:0] exp_state);
        begin
            temp = t;
            repeat (2) @(posedge clk);
            #1;
            pulse_start;
            #1 check(exp_valves, exp_state, "after START");
            temp = ~t;                       // change switches: output must HOLD
            repeat (2) @(posedge clk); #1;
            check(exp_valves, exp_state, "holds after temp change");
            pulse_ack;
            #1 check(4'b0000, 3'b000, "after ACK -> IDLE");
        end
    endtask

    initial begin
        $display("===== Water Temperature Classifier TB =====");
        do_reset;
        #1 check(4'b0000, 3'b000, "after RESET");

        // all 8 temperature values (valves = {HOT, NEUTRAL, COLD, VC})
        run_case(3'd0, 4'b0001, 3'b001);
        run_case(3'd1, 4'b0001, 3'b001);
        run_case(3'd2, 4'b0010, 3'b010);
        run_case(3'd3, 4'b0010, 3'b010);
        run_case(3'd4, 4'b0100, 3'b011);
        run_case(3'd5, 4'b0100, 3'b011);
        run_case(3'd6, 4'b1000, 3'b100);
        run_case(3'd7, 4'b1000, 3'b100);

        // ACK in IDLE must do nothing
        pulse_ack; #1 check(4'b0000, 3'b000, "ACK in IDLE ignored");

        // RESET from inside a category state
        temp = 3'd6; repeat (2) @(posedge clk); #1;
        pulse_start; #1 check(4'b1000, 3'b100, "HOT entered");
        do_reset;    #1 check(4'b0000, 3'b000, "RESET from HOT -> IDLE");

        // START ignored while not in IDLE
        temp = 3'd3; repeat (2) @(posedge clk); #1;
        pulse_start; #1 check(4'b0010, 3'b010, "COLD entered");
        temp = 3'd7; repeat (2) @(posedge clk); #1;
        pulse_start; #1 check(4'b0010, 3'b010, "START ignored in COLD");
        pulse_ack;

        $display("===== SUMMARY: %0d PASSED, %0d FAILED =====", pass, fail);
        if (fail == 0) $display("*** TEST PASSED ***");
        else           $display("*** TEST FAILED ***");
        $finish;
    end
endmodule