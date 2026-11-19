`timescale 1ns/1ps
// Self-checking testbench for gray_code_mealy
module gray_code_mealy_tb;
    reg        clk = 0, reset = 1, start = 0, ack = 0;
    reg  [3:0] x = 4'b0000;
    wire       valid, invalid;
    integer    errors = 0, tests = 0;

    gray_code_mealy dut (.clk(clk), .reset(reset), .start(start), .ack(ack),
                         .x(x), .valid(valid), .invalid(invalid));

    always #5 clk = ~clk;                       // 10 ns period

    // Inputs change on negedge; outputs are checked 1 ns later,
    // BEFORE the next posedge -> proves the Mealy output is immediate.
    task check(input ev, input ei, input [8*28:1] name);
        begin
            #1;
            tests = tests + 1;
            if (valid !== ev || invalid !== ei) begin
                errors = errors + 1;
                $display("FAIL  %0s | x=%b valid=%b invalid=%b (expected %b %b)",
                         name, x, valid, invalid, ev, ei);
            end else
                $display("PASS  %0s | x=%b valid=%b invalid=%b", name, x, valid, invalid);
        end
    endtask

    // apply a new X (state must be ACTIVE) and check immediately
    task step(input [3:0] val, input ev, input ei, input [8*28:1] name);
        begin
            @(negedge clk); start = 0; ack = 0; x = val;
            check(ev, ei, name);
        end
    endtask

    initial begin
        $dumpfile("gray_code_mealy.vcd");
        $dumpvars(0, gray_code_mealy_tb);

        // ---- reset ----
        repeat (2) @(negedge clk);
        reset = 0;

        // ---- IDLE: outputs must stay 0 whatever X does ----
        @(negedge clk); x = 4'b0001; check(0, 0, "IDLE ignores X");

        // ---- START: load first sample 0000 into P ----
        @(negedge clk); start = 1; x = 4'b0000;
        check(0, 0, "START cycle (still IDLE)");

        // ---- sheet sequence: 0000->0001->0011->0111->0101->1101->1100->1111
        step(4'b0001, 1, 0, "0000->0001 one bit");
        step(4'b0011, 1, 0, "0001->0011 one bit");
        step(4'b0111, 1, 0, "0011->0111 one bit");
        step(4'b0101, 1, 0, "0111->0101 one bit");
        step(4'b1101, 1, 0, "0101->1101 one bit");
        step(4'b1100, 1, 0, "1101->1100 one bit");
        step(4'b1111, 0, 1, "1100->1111 two bits");

        // ---- extra invalid cases ----
        step(4'b1111, 0, 1, "1111->1111 zero bits");
        step(4'b0000, 0, 1, "1111->0000 four bits");
        step(4'b0111, 0, 1, "0000->0111 three bits");
        step(4'b0110, 1, 0, "0111->0110 one bit");
        step(4'b1001, 0, 1, "0110->1001 four bits");

        // ---- ACK: outputs drop immediately, FSM returns to IDLE ----
        @(negedge clk); ack = 1; x = 4'b1000;
        check(0, 0, "ACK kills outputs");
        @(negedge clk); ack = 0; x = 4'b0000;
        check(0, 0, "back in IDLE");

        // ---- START again from a new sample ----
        @(negedge clk); start = 1; x = 4'b1010;
        check(0, 0, "2nd START cycle");
        step(4'b1011, 1, 0, "1010->1011 one bit");
        step(4'b0011, 1, 0, "1011->0011 one bit");
        step(4'b1100, 0, 1, "0011->1100 four bits");

        // ---- reset while ACTIVE ----
        @(negedge clk); reset = 1; start = 0; x = 4'b0001;
        @(negedge clk); reset = 0;
        check(0, 0, "reset returns to IDLE");

        // ---- summary ----
        $display("--------------------------------------------");
        if (errors == 0) $display("ALL %0d TESTS PASSED", tests);
        else             $display("%0d of %0d TESTS FAILED", errors, tests);
        $finish;
    end
endmodule