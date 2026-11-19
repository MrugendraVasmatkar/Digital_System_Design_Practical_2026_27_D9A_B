`timescale 1ns / 1ps
//==============================================================================
// Self-checking testbench - Gray Code Transition Detector (N-bit, Hint H1)
//   * DUT N=4 (original problem) and DUT N=8 are driven together
//   * Directed test: sheet sequence 0000->0001->0011->0111->0101->1101->1100->1111
//   * Corner cases: no change, multi-bit change, MSB flip, START held, ACK, RST,
//                   ACK priority over START
//   * 300 random samples compared against a behavioural reference model
//==============================================================================
module tb_gray_code_detector;

    reg         clk;
    reg         rst, start, ack;
    reg  [7:0]  data;

    wire        vld4, inv4, idl4, vld8, inv8, idl8;
    wire [1:0]  st4, st8;
    wire [3:0]  cur4, prv4;
    wire [7:0]  cur8, prv8;
    wire        v4, v8;

    gray_code_detector #(.N(4)) dut4 (
        .clk(clk), .rst(rst), .start(start), .ack(ack), .data_in(data[3:0]),
        .valid_led(vld4), .invalid_led(inv4), .idle_led(idl4),
        .state_out(st4), .curr_out(cur4), .prev_out(prv4), .v_out(v4));

    gray_code_detector #(.N(8)) dut8 (
        .clk(clk), .rst(rst), .start(start), .ack(ack), .data_in(data),
        .valid_led(vld8), .invalid_led(inv8), .idle_led(idl8),
        .state_out(st8), .curr_out(cur8), .prev_out(prv8), .v_out(v8));

    // 100 MHz clock
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ---------------- reference model ----------------
    localparam [1:0] S_IDLE = 2'b00, S_VALID = 2'b01, S_INVALID = 2'b10;

    reg [7:0] m_prev4, m_prev8;          // last accepted sample (masked per width)
    reg [1:0] m_state4, m_state8;
    integer   pass_cnt, fail_cnt, n, seed;
    reg [31:0] r;
    reg [7:0]  nd;

    // exactly-one-bit-set test (counts ones)
    function onebit;
        input [7:0] a;
        integer k, cnt;
        begin
            cnt = 0;
            for (k = 0; k < 8; k = k + 1)
                if (a[k]) cnt = cnt + 1;
            onebit = (cnt == 1);
        end
    endfunction

    // ---------------- checker ----------------
    task check;
        input [8*24-1:0] label;
        begin
            if ( (st4 !== m_state4) || (vld4 !== (m_state4 == S_VALID)) ||
                 (inv4 !== (m_state4 == S_INVALID)) || (idl4 !== (m_state4 == S_IDLE)) ||
                 (cur4 !== m_prev4[3:0]) ||
                 (st8 !== m_state8) || (vld8 !== (m_state8 == S_VALID)) ||
                 (inv8 !== (m_state8 == S_INVALID)) || (idl8 !== (m_state8 == S_IDLE)) ||
                 (cur8 !== m_prev8) ) begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] t=%0t %0s | N4: st=%b exp=%b X=%b | N8: st=%b exp=%b X=%b",
                         $time, label, st4, m_state4, cur4, st8, m_state8, cur8);
            end else begin
                pass_cnt = pass_cnt + 1;
            end
        end
    endtask

    // hard-coded expectation (independent of the model) for the 4-bit DUT
    task expect4;
        input [1:0] e;
        begin
            if (st4 !== e) begin
                fail_cnt = fail_cnt + 1;
                $display("[FAIL] t=%0t N4 state=%b, hard-coded expectation=%b", $time, st4, e);
            end else
                pass_cnt = pass_cnt + 1;
        end
    endtask

    // ---------------- stimulus tasks ----------------
    // Apply one sample; START is held 'hold' clock cycles (must still count as ONE sample)
    task do_sample;
        input [7:0] d;
        input [3:0] hold;
        begin
            @(negedge clk);
            data  = d;
            start = 1'b1;
            repeat (hold) @(negedge clk);
            start = 1'b0;
            // reference model update
            m_state4 = onebit((d & 8'h0F) ^ m_prev4) ? S_VALID : S_INVALID;
            m_prev4  = d & 8'h0F;
            m_state8 = onebit(d ^ m_prev8) ? S_VALID : S_INVALID;
            m_prev8  = d;
            @(negedge clk);                        // FSM updated one cycle after the load
            $write("       X=%b  P=%b  D=%b  V=%b  VALID=%b INVALID=%b IDLE=%b (N=4)\n",
                   cur4, prv4, cur4 ^ prv4, v4, vld4, inv4, idl4);
            check("sample");
        end
    endtask

    task do_ack;
        begin
            @(negedge clk);
            ack = 1'b1;
            m_state4 = S_IDLE;
            m_state8 = S_IDLE;
            @(negedge clk);
            check("ack -> IDLE");
            ack = 1'b0;
        end
    endtask

    task do_reset;
        begin
            @(negedge clk);
            rst = 1'b1;
            @(negedge clk);
            @(negedge clk);
            rst = 1'b0;
            m_prev4 = 8'h00; m_prev8 = 8'h00;
            m_state4 = S_IDLE; m_state8 = S_IDLE;
            check("reset");
        end
    endtask

    // ACK and START in the same cycle: ACK wins, sample is NOT loaded
    task do_ack_and_start;
        input [7:0] d;
        begin
            @(negedge clk);
            ack   = 1'b1;
            start = 1'b1;
            data  = d;
            m_state4 = S_IDLE;
            m_state8 = S_IDLE;
            @(negedge clk);
            start = 1'b0;
            ack   = 1'b0;
            @(negedge clk);
            check("ack priority");
        end
    endtask

    // ---------------- main sequence ----------------
    initial begin
        $dumpfile("tb_gray_code_detector.vcd");
        $dumpvars(0, tb_gray_code_detector);

        pass_cnt = 0; fail_cnt = 0; seed = 32'h1234ABCD;
        rst = 1'b1; start = 1'b0; ack = 1'b0; data = 8'h00;
        m_prev4 = 8'h00; m_prev8 = 8'h00;
        m_state4 = S_IDLE; m_state8 = S_IDLE;
        repeat (3) @(negedge clk);
        rst = 1'b0;
        check("power-up reset");

        // ---- Test 1: sheet sequence (4-bit): 0000->0001->0011->0111->0101->1101->1100->1111
        $display("--- Test 1: sheet sequence (expect VALID x6, then INVALID) ---");
        do_sample(8'b0001, 4'd1); expect4(S_VALID);
        do_sample(8'b0011, 4'd1); expect4(S_VALID);
        do_sample(8'b0111, 4'd1); expect4(S_VALID);
        do_sample(8'b0101, 4'd1); expect4(S_VALID);
        do_sample(8'b1101, 4'd1); expect4(S_VALID);
        do_sample(8'b1100, 4'd1); expect4(S_VALID);
        do_sample(8'b1111, 4'd1); expect4(S_INVALID);     // two bits changed
        do_ack;                   expect4(S_IDLE);

        // ---- Test 2: corner cases
        $display("--- Test 2: corner cases ---");
        do_sample(8'b1111, 4'd1); expect4(S_INVALID);     // no change
        do_sample(8'b0111, 4'd1); expect4(S_VALID);       // single bit (non-adjacent Gray ok)
        do_sample(8'b1000, 4'd1); expect4(S_INVALID);     // 4 bits changed
        do_sample(8'b0000, 4'd1); expect4(S_VALID);       // single bit
        do_sample(8'h80,   4'd1);                         // MSB of N=8 flips (N=4 sees 0000 -> INVALID)
        do_sample(8'h81,   4'd1);                         // single bit again
        do_ack;

        // ---- Test 3: START held for several cycles = only ONE sample
        $display("--- Test 3: START held 4 cycles ---");
        do_reset;
        do_sample(8'b0001, 4'd4); expect4(S_VALID);       // if sampled twice 2nd would be INVALID
        do_ack;

        // ---- Test 4: reset clears previous register
        $display("--- Test 4: reset ---");
        do_sample(8'b0011, 4'd1); expect4(S_VALID);
        do_reset;                 expect4(S_IDLE);
        do_sample(8'b0001, 4'd1); expect4(S_VALID);       // compared with P = 0000

        // ---- Test 5: ACK priority over START
        $display("--- Test 5: ACK has priority over START ---");
        do_sample(8'b0011, 4'd1); expect4(S_VALID);
        do_ack_and_start(8'b0000);                        // sample ignored, back to IDLE
        expect4(S_IDLE);
        do_sample(8'b0111, 4'd1); expect4(S_VALID);       // compared with 0011 (not 0000)

        // ---- Test 6: random regression against the reference model
        $display("--- Test 6: 300 random samples ---");
        for (n = 0; n < 300; n = n + 1) begin
            r = $random(seed);
            if (r[2:0] < 3'd4)
                nd = m_prev8 ^ (8'h01 << r[10:8]);        // flip exactly one bit
            else
                nd = r[23:16];                            // arbitrary value
            do_sample(nd, {2'b00, r[27:26]} + 4'd1);
            if (r[31:29] == 3'd0) do_ack;
            if (r[31:28] == 4'hF) do_reset;
        end

        $display("=======================================================");
        $display(" Checks passed: %0d   failed: %0d", pass_cnt, fail_cnt);
        if (fail_cnt == 0) $display(" RESULT: ALL TESTS PASSED");
        else               $display(" RESULT: TEST FAILED");
        $display("=======================================================");
        $finish;
    end

    // watchdog
    initial begin
        #5000000;
        $display("[FAIL] watchdog timeout");
        $finish;
    end

endmodule
