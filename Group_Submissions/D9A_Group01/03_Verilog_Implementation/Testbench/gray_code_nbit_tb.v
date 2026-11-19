`timescale 1ns / 1ps

module gray_code_nbit_tb;
    parameter N4 = 4;
    parameter N5 = 5;

    reg           clk = 0;
    reg           rst = 1;
    reg           start = 0;
    reg           ack = 0;

    reg  [N4-1:0] x4 = 0;
    wire          valid_4, invalid_4;

    reg  [N5-1:0] x5 = 0;
    wire          valid_5, invalid_5;

    integer pass_cnt = 0;
    integer fail_cnt = 0;

    // Instantiate 4-bit DUT
    gray_code_nbit #(.N(N4)) dut4 (
        .clk(clk),
        .rst(rst),
        .start(start),
        .ack(ack),
        .x(x4),
        .valid_led(valid_4),
        .invalid_led(invalid_4)
    );

    // Instantiate 5-bit DUT (H1 verification)
    gray_code_nbit #(.N(N5)) dut5 (
        .clk(clk),
        .rst(rst),
        .start(start),
        .ack(ack),
        .x(x5),
        .valid_led(valid_5),
        .invalid_led(invalid_5)
    );

    // 10ns clock period (100 MHz)
    always #5 clk = ~clk;

    task run_step_4bit;
        input [N4-1:0] in_val;
        input          exp_valid;
        begin
            @(negedge clk);
            x4    = in_val;
            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;

            if ((valid_4 === exp_valid) && (invalid_4 === ~exp_valid)) begin
                $display("PASS [N=4]: x=%b -> valid=%b, invalid=%b", in_val, valid_4, invalid_4);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("FAIL [N=4]: x=%b -> got valid=%b, invalid=%b (expected valid=%b)",
                         in_val, valid_4, invalid_4, exp_valid);
                fail_cnt = fail_cnt + 1;
            end

            // Acknowledge to return FSM to IDLE
            @(negedge clk);
            ack = 1'b1;
            @(posedge clk);
            #1;
            ack = 1'b0;
        end
    endtask

    task run_step_5bit;
        input [N5-1:0] in_val;
        input          exp_valid;
        begin
            @(negedge clk);
            x5    = in_val;
            start = 1'b1;
            @(posedge clk);
            #1;
            start = 1'b0;

            if ((valid_5 === exp_valid) && (invalid_5 === ~exp_valid)) begin
                $display("PASS [N=5]: x=%b -> valid=%b, invalid=%b", in_val, valid_5, invalid_5);
                pass_cnt = pass_cnt + 1;
            end else begin
                $display("FAIL [N=5]: x=%b -> got valid=%b, invalid=%b (expected valid=%b)",
                         in_val, valid_5, invalid_5, exp_valid);
                fail_cnt = fail_cnt + 1;
            end

            // Acknowledge to return FSM to IDLE
            @(negedge clk);
            ack = 1'b1;
            @(posedge clk);
            #1;
            ack = 1'b0;
        end
    endtask

    initial begin
        // Release synchronous reset
        @(negedge clk);
        rst = 1'b0;

        // N = 4 test sequence from problem statement[cite: 1]
        run_step_4bit(4'b0001, 1'b1); // 0000 -> 0001 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b0011, 1'b1); // 0001 -> 0011 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b0111, 1'b1); // 0011 -> 0111 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b0101, 1'b1); // 0111 -> 0101 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b1101, 1'b1); // 0101 -> 1101 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b1100, 1'b1); // 1101 -> 1100 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b1111, 1'b1); // 1100 -> 1111 (1-bit change -> valid)[cite: 1]
        run_step_4bit(4'b1111, 1'b0); // 1111 -> 1111 (0-bit change -> invalid)[cite: 1]
        run_step_4bit(4'b1001, 1'b0); // 1111 -> 1001 (2-bit change -> invalid)

        // N = 5 test sequence (H1 verification)[cite: 1]
        run_step_5bit(5'b00010, 1'b1); // 00000 -> 00010 (1-bit change -> valid)
        run_step_5bit(5'b10010, 1'b1); // 00010 -> 10010 (1-bit change -> valid)
        run_step_5bit(5'b10111, 1'b0); // 10010 -> 10111 (2-bit change -> invalid)

        $display("Summary: %0d PASSED, %0d FAILED", pass_cnt, fail_cnt);
        $finish;
    end
endmodule
