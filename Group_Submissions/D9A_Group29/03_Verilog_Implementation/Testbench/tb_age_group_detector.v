`timescale 1ns / 1ps

module tb_age_group_detector;

    localparam IDLE  = 3'b000;
    localparam CHILD = 3'b001;
    localparam TEEN  = 3'b010;
    localparam ADULT = 3'b011;
    localparam ERROR = 3'b100;

    reg clk;
    reg [5:0] sw;
    reg [2:0] btn;

    wire [3:0] led;
    wire [3:0] D0_AN;
    wire [7:0] D0_SEG;
    wire [3:0] D1_AN;
    wire [7:0] D1_SEG;

    reg [8*5-1:0] state_text;
    integer errors;
    integer i;
    integer d;
    reg [2:0] monitored_state;
    reg [2:0] expected_compare;
    reg [3:0] expected_age_digit;
    reg [3:0] expected_anodes;
    reg [1:0] expected_display_position;
    reg [7:0] expected_age_segments;
    reg [7:0] expected_state_segments;

    age_group_detector_core dut (
        .clk(clk),
        .sw(sw),
        .btn(btn),
        .led(led),
        .D0_AN(D0_AN),
        .D0_SEG(D0_SEG),
        .D1_AN(D1_AN),
        .D1_SEG(D1_SEG)
    );

    always #5 clk = ~clk;

    always @(*) begin
        case (dut.state_debug)
            IDLE:  state_text = "IDLE";
            CHILD: state_text = "CHILD";
            TEEN:  state_text = "TEEN";
            ADULT: state_text = "ADULT";
            ERROR: state_text = "ERROR";
            default: state_text = "UNDEF";
        endcase
    end

    initial monitored_state = 3'bxxx;

    always @(posedge clk) begin
        #1;
        if (dut.state_debug !== monitored_state) begin
            $display("T=%0t AGE=%0d STATE=%0s LED=%b",
                     $time, dut.display_age, state_text, led);
            monitored_state = dut.state_debug;
        end
    end

    function [7:0] ref_digit_to_segments;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: ref_digit_to_segments = 8'hC0;
                4'd1: ref_digit_to_segments = 8'hF9;
                4'd2: ref_digit_to_segments = 8'hA4;
                4'd3: ref_digit_to_segments = 8'hB0;
                4'd4: ref_digit_to_segments = 8'h99;
                4'd5: ref_digit_to_segments = 8'h92;
                4'd6: ref_digit_to_segments = 8'h82;
                4'd7: ref_digit_to_segments = 8'hF8;
                4'd8: ref_digit_to_segments = 8'h80;
                4'd9: ref_digit_to_segments = 8'h90;
                default: ref_digit_to_segments = 8'hFF;
            endcase
        end
    endfunction

    function [7:0] ref_state_to_segments;
        input [2:0] state;
        input [1:0] position;
        begin
            case (state)
                IDLE: begin
                    case (position)
                        2'd0: ref_state_to_segments = 8'hF9;
                        2'd1: ref_state_to_segments = 8'hA1;
                        2'd2: ref_state_to_segments = 8'hC7;
                        2'd3: ref_state_to_segments = 8'h86;
                        default: ref_state_to_segments = 8'hFF;
                    endcase
                end
                CHILD: begin
                    case (position)
                        2'd0: ref_state_to_segments = 8'hC6;
                        2'd1: ref_state_to_segments = 8'h89;
                        2'd2: ref_state_to_segments = 8'hC7;
                        2'd3: ref_state_to_segments = 8'hA1;
                        default: ref_state_to_segments = 8'hFF;
                    endcase
                end
                TEEN: begin
                    case (position)
                        2'd0: ref_state_to_segments = 8'h87;
                        2'd1: ref_state_to_segments = 8'h86;
                        2'd2: ref_state_to_segments = 8'h86;
                        2'd3: ref_state_to_segments = 8'hAB;
                        default: ref_state_to_segments = 8'hFF;
                    endcase
                end
                ADULT: begin
                    case (position)
                        2'd0: ref_state_to_segments = 8'h88;
                        2'd1: ref_state_to_segments = 8'hA1;
                        2'd2: ref_state_to_segments = 8'hC1;
                        2'd3: ref_state_to_segments = 8'hC7;
                        default: ref_state_to_segments = 8'hFF;
                    endcase
                end
                ERROR: begin
                    case (position)
                        2'd0: ref_state_to_segments = 8'h86;
                        2'd1: ref_state_to_segments = 8'hAF;
                        2'd2: ref_state_to_segments = 8'hAF;
                        2'd3: ref_state_to_segments = 8'hFF;
                        default: ref_state_to_segments = 8'hFF;
                    endcase
                end
                default: ref_state_to_segments = 8'hFF;
            endcase
        end
    endfunction

    task check_result;
        input [2:0] expected_state;
        input [3:0] expected_led;
        input [8*28-1:0] test_name;
        begin
            @(negedge clk);
            #1;
            if ((dut.state_debug !== expected_state) || (led !== expected_led)) begin
                $display("FAIL: %0s STATE=%b EXPECTED=%b LED=%b EXPECTED_LED=%b",
                         test_name, dut.state_debug, expected_state, led, expected_led);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s STATE=%0s LED=%b", test_name, state_text, led);
            end
        end
    endtask

    task press_button;
        input integer button_index;
        begin
            @(negedge clk);
            btn[button_index] = 1'b1;
            repeat (4) @(negedge clk);
            btn[button_index] = 1'b0;
            repeat (4) @(negedge clk);
        end
    endtask

    task check_display;
        input [5:0] expected_age;
        input [2:0] expected_state;
        begin
            for (d = 0; d < 4; d = d + 1) begin
                wait (dut.scan_digit == d[1:0]);
                #1;

                expected_display_position = 2'd3 - d[1:0];

                case (d)
                    0: expected_anodes = 4'b1110;
                    1: expected_anodes = 4'b1101;
                    2: expected_anodes = 4'b1011;
                    3: expected_anodes = 4'b0111;
                    default: expected_anodes = 4'b1111;
                endcase

                case (expected_display_position)
                    2'd0, 2'd1: expected_age_digit = 4'd0;
                    2'd2:       expected_age_digit = expected_age / 6'd10;
                    2'd3:       expected_age_digit = expected_age % 6'd10;
                    default:    expected_age_digit = 4'd0;
                endcase

                expected_age_segments = ref_digit_to_segments(expected_age_digit);
                expected_state_segments = ref_state_to_segments(expected_state, expected_display_position);

                if ((D0_AN !== expected_anodes) ||
                    (D1_AN !== expected_anodes) ||
                    (D0_SEG !== expected_age_segments) ||
                    (D1_SEG !== expected_state_segments)) begin
                    $display("FAIL DISPLAY AGE=%0d STATE=%0d DIGIT=%0d D0_AN=%b D0_SEG=%h D1_AN=%b D1_SEG=%h",
                             expected_age, expected_state, d,
                             D0_AN, D0_SEG, D1_AN, D1_SEG);
                    errors = errors + 1;
                end
            end
            $display("PASS DISPLAY AGE=%0d STATE=%0d", expected_age, expected_state);
        end
    endtask

    task test_age;
        input [5:0] value;
        input [2:0] expected_state;
        input [3:0] expected_led;
        input [8*28-1:0] test_name;
        begin
            @(negedge clk);
            sw = value;
            repeat (4) @(negedge clk);
            press_button(1);
            check_result(expected_state, expected_led, test_name);

            if (dut.age_latched !== value) begin
                $display("FAIL AGE LATCH: %0s EXPECTED=%0d ACTUAL=%0d",
                         test_name, value, dut.age_latched);
                errors = errors + 1;
            end else begin
                $display("PASS AGE LATCH: %0s AGE=%0d", test_name, dut.age_latched);
            end

            check_display(value, expected_state);

            press_button(2);
            check_result(IDLE, 4'b0000, "ACK_TO_IDLE");
        end
    endtask

    initial begin
        clk = 1'b0;
        sw = 6'd0;
        btn = 3'b000;
        errors = 0;
        expected_compare = 3'b000;

        press_button(0);
        check_result(IDLE, 4'b0000, "INITIAL_RESET");

        for (i = 0; i < 64; i = i + 1) begin
            @(negedge clk);
            sw = i;
            repeat (4) @(negedge clk);

            if (i <= 12)
                expected_compare = 3'b100;
            else if (i <= 19)
                expected_compare = 3'b010;
            else if (i <= 31)
                expected_compare = 3'b001;
            else
                expected_compare = 3'b000;

            #1;
            if ({dut.child_detect, dut.teen_detect, dut.adult_detect} !== expected_compare) begin
                $display("FAIL DECODER AGE=%0d CMP=%b%b%b EXPECTED=%b",
                         i, dut.child_detect, dut.teen_detect,
                         dut.adult_detect, expected_compare);
                errors = errors + 1;
            end

            if (dut.no_match !== (i >= 32)) begin
                $display("FAIL NO_MATCH AGE=%0d NO_MATCH=%b", i, dut.no_match);
                errors = errors + 1;
            end
        end
        $display("INFO: All 64 six-bit input values checked.");

        test_age(6'd0,  CHILD, 4'b0001, "AGE_0_CHILD");
        test_age(6'd12, CHILD, 4'b0001, "AGE_12_CHILD");
        test_age(6'd13, TEEN,  4'b0010, "AGE_13_TEEN");
        test_age(6'd19, TEEN,  4'b0010, "AGE_19_TEEN");
        test_age(6'd20, ADULT, 4'b0100, "AGE_20_ADULT");
        test_age(6'd31, ADULT, 4'b0100, "AGE_31_ADULT");
        test_age(6'd32, ERROR, 4'b1000, "AGE_32_ERROR");
        test_age(6'd33, ERROR, 4'b1000, "AGE_33_ERROR");
        test_age(6'd63, ERROR, 4'b1000, "AGE_63_ERROR");

        @(negedge clk);
        sw = 6'd40;
        repeat (4) @(negedge clk);
        press_button(1);
        check_result(ERROR, 4'b1000, "ERROR_BEFORE_RESET");
        check_display(6'd40, ERROR);
        press_button(0);
        check_result(IDLE, 4'b0000, "RESET_FROM_ERROR");
        check_display(6'd40, IDLE);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d", errors);

        #20;
        $finish;
    end

endmodule
