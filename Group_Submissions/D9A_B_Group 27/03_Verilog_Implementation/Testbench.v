`timescale 1ns/1ps
module age_group_detector_tb;
    reg        clk = 0, reset = 0, start = 0, ack = 0;
    reg  [4:0] age = 0;
    wire       child_led, teen_led, adult_led;
    wire [3:0] child_count, teen_count, adult_count;

    age_group_detector dut (.clk(clk), .reset(reset), .start(start), .ack(ack),
        .age(age), .child_led(child_led), .teen_led(teen_led), .adult_led(adult_led),
        .child_count(child_count), .teen_count(teen_count), .adult_count(adult_count));

    always #5 clk = ~clk;

    task check(input [255:0] msg, input [3:0] got, input [3:0] exp);
        begin
            if (got !== exp)
                $display("FAIL: %0s got=%0d exp=%0d (t=%0t)", msg, got, exp, $time);
        end
    endtask

    // Expected LED pattern {adult,teen,child}; 000 means IDLE
    task check_leds(input [255:0] msg, input [2:0] exp);
        begin
            check(msg, {adult_led, teen_led, child_led}, exp);
        end
    endtask

    // cat: 1 CHILD, 2 TEEN, 3 ADULT
    task detect(input [4:0] a, input [1:0] cat);
        reg [2:0] exp_leds;
        begin
            exp_leds = (cat == 2'd1) ? 3'b001 : (cat == 2'd2) ? 3'b010 : 3'b100;
            age = a;
            @(posedge clk); #1;            // input register loads while IDLE
            start = 1;
            @(posedge clk); #1;            // IDLE -> category
            start = 0;
            check_leds("LEDs after start", exp_leds);
            age = ~a;                       // input change must be ignored
            repeat (2) @(posedge clk); #1;
            check_leds("LEDs hold without ACK", exp_leds);
            ack = 1;
            @(posedge clk); #1;            // category -> IDLE
            ack = 0;
            check_leds("LEDs off after ACK", 3'b000);
            $display("age=%0d -> %s  OK", a,
                (cat==1)?"CHILD":(cat==2)?"TEEN":"ADULT");
        end
    endtask

    initial begin
        $dumpfile("age_group_detector.vcd");
        $dumpvars(0, age_group_detector_tb);

        reset = 1; #12; reset = 0; @(posedge clk); #1;
        check_leds("idle after reset", 3'b000);

        detect(5'd0, 2'd1);  detect(5'd5, 2'd1);  detect(5'd12, 2'd1);
        detect(5'd13, 2'd2); detect(5'd16, 2'd2); detect(5'd19, 2'd2);
        detect(5'd20, 2'd3); detect(5'd24, 2'd3); detect(5'd31, 2'd3);

        check("child_count", child_count, 4'd3);
        check("teen_count",  teen_count,  4'd3);
        check("adult_count", adult_count, 4'd3);

        // START together with ACK must not trigger
        age = 5'd7; @(posedge clk); #1;
        start = 1; ack = 1; @(posedge clk); #1;
        check_leds("START&ACK ignored", 3'b000);
        start = 0; ack = 0;

        // RESET clears counters
        detect(5'd10, 2'd1);
        reset = 1; #2;
        check("child_count cleared", child_count, 4'd0);
        check("teen_count cleared",  teen_count,  4'd0);
        check("adult_count cleared", adult_count, 4'd0);
        reset = 0;

        $finish;
    end
endmodule