`timescale 1ns / 1ps

module tb_age_group_detector;

    localparam IDLE  = 3'b000;
    localparam CHILD = 3'b001;
    localparam TEEN  = 3'b010;
    localparam ADULT = 3'b011;
    localparam ERROR = 3'b100;

    reg clk;
    reg reset;
    reg start;
    reg ack;
    reg [4:0] age_in;
    reg force_no_match;

    wire child_from_decoder;
    wire teen_from_decoder;
    wire adult_from_decoder;
    wire child_to_fsm;
    wire teen_to_fsm;
    wire adult_to_fsm;
    wire [3:0] led_status;
    wire no_match_debug;
    wire [2:0] state_debug;
    wire [4:0] age_latched;

    reg [8*5-1:0] state_text;
    integer errors;
    integer i;

    assign child_to_fsm = force_no_match ? 1'b0 : child_from_decoder;
    assign teen_to_fsm  = force_no_match ? 1'b0 : teen_from_decoder;
    assign adult_to_fsm = force_no_match ? 1'b0 : adult_from_decoder;

    age_range_decoder decoder (
        .age_in(age_in),
        .child_detect(child_from_decoder),
        .teen_detect(teen_from_decoder),
        .adult_detect(adult_from_decoder)
    );

    age_group_fsm dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .age_in(age_in),
        .child_detect(child_to_fsm),
        .teen_detect(teen_to_fsm),
        .adult_detect(adult_to_fsm),
        .led(led_status),
        .no_match_debug(no_match_debug),
        .state_debug(state_debug),
        .age_latched(age_latched)
    );

    always #5 clk = ~clk;

    always @(*) begin
        case (state_debug)
            IDLE:  state_text = "IDLE";
            CHILD: state_text = "CHILD";
            TEEN:  state_text = "TEEN";
            ADULT: state_text = "ADULT";
            ERROR: state_text = "ERROR";
            default: state_text = "UNDEF";
        endcase
    end

    always @(posedge clk) begin
        #1;
        $display("T=%0t AGE=%0d CMP[C,T,A]=%b%b%b FSM[C,T,A]=%b%b%b STATE=%0s LED=%b",
                 $time, age_in,
                 child_from_decoder, teen_from_decoder, adult_from_decoder,
                 child_to_fsm, teen_to_fsm, adult_to_fsm,
                 state_text, led_status);
    end

    task check_result;
        input [2:0] expected_state;
        input [3:0] expected_led;
        input [8*24-1:0] test_name;
        begin
            #1;
            if ((state_debug !== expected_state) || (led_status !== expected_led)) begin
                $display("FAIL: %0s STATE=%b EXPECTED=%b LED=%b EXPECTED_LED=%b",
                         test_name, state_debug, expected_state, led_status, expected_led);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s STATE=%0s LED=%b", test_name, state_text, led_status);
            end
        end
    endtask

    task pulse_start;
        begin
            @(negedge clk);
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;
        end
    endtask

    task pulse_ack;
        begin
            @(negedge clk);
            ack = 1'b1;
            @(negedge clk);
            ack = 1'b0;
        end
    endtask

    task check_decoder;
        input [4:0] value;
        input expected_child;
        input expected_teen;
        input expected_adult;
        input [8*24-1:0] test_name;
        begin
            age_in = value;
            force_no_match = 1'b0;
            #1;
            if ((child_from_decoder !== expected_child) ||
                (teen_from_decoder !== expected_teen) ||
                (adult_from_decoder !== expected_adult)) begin
                $display("FAIL DECODER: %0s AGE=%0d CMP=%b%b%b",
                         test_name, value, child_from_decoder,
                         teen_from_decoder, adult_from_decoder);
                errors = errors + 1;
            end else begin
                $display("PASS DECODER: %0s AGE=%0d CMP=%b%b%b",
                         test_name, value, child_from_decoder,
                         teen_from_decoder, adult_from_decoder);
            end
        end
    endtask

    task test_valid_age;
        input [4:0] value;
        input [2:0] expected_state;
        input [3:0] expected_led;
        input [8*24-1:0] test_name;
        begin
            age_in = value;
            force_no_match = 1'b0;
            #1;
            pulse_start;
            check_result(expected_state, expected_led, test_name);

            if (age_latched !== value) begin
                $display("FAIL AGE LATCH: EXPECTED=%0d ACTUAL=%0d", value, age_latched);
                errors = errors + 1;
            end

            pulse_ack;
            check_result(IDLE, 4'b0000, "ACK_TO_IDLE");
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        start = 1'b0;
        ack = 1'b0;
        age_in = 5'd0;
        force_no_match = 1'b0;
        errors = 0;

        @(negedge clk);
        reset = 1'b1;
        @(negedge clk);
        reset = 1'b0;
        check_result(IDLE, 4'b0000, "INITIAL_RESET");

        check_decoder(5'd0,  1'b1, 1'b0, 1'b0, "CHILD_MIN");
        check_decoder(5'd12, 1'b1, 1'b0, 1'b0, "CHILD_MAX");
        check_decoder(5'd13, 1'b0, 1'b1, 1'b0, "TEEN_MIN");
        check_decoder(5'd19, 1'b0, 1'b1, 1'b0, "TEEN_MAX");
        check_decoder(5'd20, 1'b0, 1'b0, 1'b1, "ADULT_MIN");
        check_decoder(5'd31, 1'b0, 1'b0, 1'b1, "ADULT_MAX");

        for (i = 0; i < 32; i = i + 1) begin
            age_in = i;
            force_no_match = 1'b0;
            #1;
            if (!((child_from_decoder && !teen_from_decoder && !adult_from_decoder) ||
                  (!child_from_decoder && teen_from_decoder && !adult_from_decoder) ||
                  (!child_from_decoder && !teen_from_decoder && adult_from_decoder))) begin
                $display("FAIL ONE-HOT DECODER: AGE=%0d CMP=%b%b%b",
                         i, child_from_decoder, teen_from_decoder, adult_from_decoder);
                errors = errors + 1;
            end
        end
        $display("INFO: Decoder sweep checked all 32 possible 5-bit ages.");

        test_valid_age(5'd0,  CHILD, 4'b0001, "AGE_0_CHILD");
        test_valid_age(5'd12, CHILD, 4'b0001, "AGE_12_CHILD");
        test_valid_age(5'd13, TEEN,  4'b0010, "AGE_13_TEEN");
        test_valid_age(5'd19, TEEN,  4'b0010, "AGE_19_TEEN");
        test_valid_age(5'd20, ADULT, 4'b0100, "AGE_20_ADULT");
        test_valid_age(5'd31, ADULT, 4'b0100, "AGE_31_ADULT");

        age_in = 5'd10;
        force_no_match = 1'b1;
        #1;
        if (({child_to_fsm, teen_to_fsm, adult_to_fsm} !== 3'b000) ||
            (no_match_debug !== 1'b1)) begin
            $display("FAIL: Comparator no-match input was not 000.");
            errors = errors + 1;
        end
        pulse_start;
        check_result(ERROR, 4'b1000, "ALL_COMPARATORS_ZERO");
        pulse_ack;
        check_result(IDLE, 4'b0000, "ACK_FROM_ERROR");

        force_no_match = 1'b0;
        age_in = 5'd31;
        force_no_match = 1'b1;
        pulse_start;
        check_result(ERROR, 4'b1000, "ERROR_SECOND_TEST");
        @(negedge clk);
        reset = 1'b1;
        @(negedge clk);
        reset = 1'b0;
        check_result(IDLE, 4'b0000, "RESET_FROM_ERROR");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d", errors);

        #10;
        $finish;
    end

endmodule
