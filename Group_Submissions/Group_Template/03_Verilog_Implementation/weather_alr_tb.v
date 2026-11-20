`timescale 1ns / 1ps

module tb_weather_alert_H4;

    reg        clk;
    reg        reset;
    reg        START;
    reg        ACK;
    reg  [2:0] Wind;

    wire [1:0] state;
    wire [3:0] Calm_Count;
    wire [3:0] Breezy_Count;
    wire [3:0] Storm_Count;
    wire [3:0] Calm_LED;
    wire [3:0] Breezy_LED;
    wire [3:0] Storm_LED;
    wire       Buzzer;

    integer i, k, errors;

    reg [1:0] exp_state;
    reg       exp_buz;
    reg [3:0] exp_calm, exp_breezy, exp_storm;

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

    always #5 clk = ~clk;

    task check;
        begin
            if (state !== exp_state) begin
                $display("FAIL @%0t: state=%b expected=%b", $time, state, exp_state);
                errors = errors + 1;
            end
            if (Buzzer !== exp_buz) begin
                $display("FAIL @%0t: Buzzer=%b expected=%b", $time, Buzzer, exp_buz);
                errors = errors + 1;
            end
            if (Calm_Count !== exp_calm || Breezy_Count !== exp_breezy || Storm_Count !== exp_storm) begin
                $display("FAIL @%0t: C=%0d B=%0d S=%0d expected C=%0d B=%0d S=%0d",
                         $time, Calm_Count, Breezy_Count, Storm_Count,
                         exp_calm, exp_breezy, exp_storm);
                errors = errors + 1;
            end
            if (Calm_LED !== Calm_Count || Breezy_LED !== Breezy_Count || Storm_LED !== Storm_Count) begin
                $display("FAIL @%0t: LED outputs do not match counters", $time);
                errors = errors + 1;
            end
        end
    endtask

    task do_detect;
        input [2:0] w;
        begin
            @(negedge clk);
            Wind  = w;
            START = 1'b1;
            ACK   = 1'b0;
            @(posedge clk);
            #1;
            if (w <= 3'd2) begin
                exp_state = 2'b01; exp_buz = 1'b0; exp_calm = exp_calm + 1'b1;
            end
            else if (w <= 3'd5) begin
                exp_state = 2'b10; exp_buz = 1'b0; exp_breezy = exp_breezy + 1'b1;
            end
            else begin
                exp_state = 2'b11; exp_buz = 1'b1; exp_storm = exp_storm + 1'b1;
            end
            check;
            @(posedge clk);
            #1;
            check;
        end
    endtask

    task do_ack;
        begin
            @(negedge clk);
            START = 1'b0;
            ACK   = 1'b1;
            @(posedge clk);
            #1;
            exp_state = 2'b00;
            exp_buz   = 1'b0;
            check;
            @(negedge clk);
            ACK = 1'b0;
        end
    endtask

    initial begin
        clk = 0; reset = 1; START = 0; ACK = 0; Wind = 0;
        errors = 0;
        exp_state = 2'b00; exp_buz = 1'b0;
        exp_calm = 4'd0; exp_breezy = 4'd0; exp_storm = 4'd0;

        repeat (2) @(negedge clk);
        #1;
        check;
        reset = 0;

        // Test 1: all 8 wind values, two rounds
        for (k = 0; k < 2; k = k + 1) begin
            for (i = 0; i < 8; i = i + 1) begin
                do_detect(i);
                do_ack;
                $display("PASS: round %0d Wind=%0d  C=%0d B=%0d S=%0d",
                         k, i, Calm_Count, Breezy_Count, Storm_Count);
            end
        end

        // Test 2: ACK in IDLE ignored
        @(negedge clk);
        ACK = 1; Wind = 3'd7;
        @(posedge clk);
        #1;
        check;
        @(negedge clk);
        ACK = 0;
        @(posedge clk);
        #1;
        check;

        // Test 3: stays in STORM until ACK
        do_detect(3'd7);
        @(negedge clk);
        START = 0; Wind = 3'd0;
        repeat (3) @(posedge clk);
        #1;
        check;
        do_ack;

        // Test 4: 4-bit wrap-around
        for (i = 0; i < 16; i = i + 1) begin
            do_detect(3'd1);
            do_ack;
        end
        $display("After 16 more CALM events: Calm=%0d", Calm_Count);

        // Test 5: async reset in STORM
        do_detect(3'd6);
        @(negedge clk);
        START = 0;
        reset = 1;
        #1;
        exp_state = 2'b00; exp_buz = 1'b0;
        exp_calm = 4'd0; exp_breezy = 4'd0; exp_storm = 4'd0;
        check;
        if (errors == 0) $display("PASS: RESET operation");
        @(negedge clk);
        reset = 0;

        $display("--------------------------------");
        if (errors == 0)
            $display("ALL H4 TESTS PASSED SUCCESSFULLY");
        else
            $display("TOTAL ERRORS = %0d", errors);
        $display("--------------------------------");
        $finish;
    end

endmodule