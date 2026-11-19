module game_tb;
    reg clk, reset, start, ack;
    reg [3:0] score;
    wire low_led, med_led, high_led;

    // connect the design
    mealy_simple dut (clk, reset, start, ack, score, low_led, med_led, high_led);

    // clock: flips every 5 ns
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // ---- RESET ----
        reset = 1; start = 0; ack = 0; score = 0;
        #10 reset = 0;

        // ---- TEST 1: score = 2 (expect LOW LED) ----
        score = 2; start = 1; #1;
        $display("score=2  START      : L=%b M=%b H=%b  (expect 1 0 0)", low_led, med_led, high_led);
        #10 start = 0;
        $display("score=2  after clock: L=%b M=%b H=%b  (expect 1 0 0)", low_led, med_led, high_led);
        ack = 1; #1;
        $display("score=2  ACK        : L=%b M=%b H=%b  (expect 0 0 0)", low_led, med_led, high_led);
        #10 ack = 0;

        // ---- TEST 2: score = 7 (expect MEDIUM LED) ----
        score = 7; start = 1; #1;
        $display("score=7  START      : L=%b M=%b H=%b  (expect 0 1 0)", low_led, med_led, high_led);
        #10 start = 0;
        $display("score=7  after clock: L=%b M=%b H=%b  (expect 0 1 0)", low_led, med_led, high_led);
        ack = 1; #1;
        $display("score=7  ACK        : L=%b M=%b H=%b  (expect 0 0 0)", low_led, med_led, high_led);
        #10 ack = 0;

        // ---- TEST 3: score = 13 (expect HIGH LED) ----
        score = 13; start = 1; #1;
        $display("score=13 START      : L=%b M=%b H=%b  (expect 0 0 1)", low_led, med_led, high_led);
        #10 start = 0;
        $display("score=13 after clock: L=%b M=%b H=%b  (expect 0 0 1)", low_led, med_led, high_led);
        ack = 1; #1;
        $display("score=13 ACK        : L=%b M=%b H=%b  (expect 0 0 0)", low_led, med_led, high_led);
        #10 ack = 0;

        $finish;
    end
endmodule
