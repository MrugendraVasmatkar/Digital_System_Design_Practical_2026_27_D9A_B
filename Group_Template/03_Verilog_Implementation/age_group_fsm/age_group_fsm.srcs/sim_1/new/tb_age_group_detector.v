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
    reg [5:0] age_in;

    wire [3:0] led_status;
    wire [2:0] state_debug;
    wire [5:0] age_latched;

    reg [8*5-1:0] state_text;
    integer errors;

    age_group_fsm dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .age_in(age_in),
        .led(led_status),
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
        $display("T=%0t AGE_IN=%0d AGE_LATCHED=%0d STATE=%0s LED[ERR,AD,TE,CH]=%b",
                 $time, age_in, age_latched, state_text, led_status);
    end

    task check_result;
        input [2:0] expected_state;
        input [3:0] expected_leds;
        input [8*24-1:0] test_name;
        begin
            #1;
            if ((state_debug !== expected_state) || (led_status !== expected_leds)) begin
                $display("FAIL: %0s expected_state=%b actual_state=%b expected_leds=%b actual_leds=%b",
                         test_name, expected_state, state_debug, expected_leds, led_status);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s state=%0s leds=%b", test_name, state_text, led_status);
            end
        end
    endtask

    task check_latched_age;
        input [5:0] expected_age;
        begin
            #1;
            if (age_latched !== expected_age) begin
                $display("FAIL: age_latched expected=%0d actual=%0d", expected_age, age_latched);
                errors = errors + 1;
            end
        end
    endtask

    task press_start;
        begin
            @(negedge clk);
            start = 1'b1;
            @(negedge clk);
            start = 1'b0;
        end
    endtask

    task press_ack;
        begin
            @(negedge clk);
            ack = 1'b1;
            @(negedge clk);
            ack = 1'b0;
        end
    endtask

    task run_case;
        input [5:0] test_age;
        input [2:0] expected_state;
        input [3:0] expected_leds;
        input [8*20-1:0] test_name;
        begin
            age_in = test_age;
            press_start;
            check_result(expected_state, expected_leds, test_name);
            check_latched_age(test_age);
            press_ack;
            check_result(IDLE, 4'b0000, "ACK_TO_IDLE");
        end
    endtask

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        start = 1'b0;
        ack = 1'b0;
        age_in = 6'd0;
        errors = 0;

        @(negedge clk);
        reset = 1'b1;
        @(negedge clk);
        reset = 1'b0;
        check_result(IDLE, 4'b0000, "INITIAL_RESET");

        run_case(6'd0,  CHILD, 4'b0001, "AGE_0");
        run_case(6'd12, CHILD, 4'b0001, "AGE_12");
        run_case(6'd13, TEEN,  4'b0010, "AGE_13");
        run_case(6'd19, TEEN,  4'b0010, "AGE_19");
        run_case(6'd20, ADULT, 4'b0100, "AGE_20");
        run_case(6'd31, ADULT, 4'b0100, "AGE_31");
        run_case(6'd32, ERROR, 4'b1000, "AGE_32");

        age_in = 6'd63;
        press_start;
        check_result(ERROR, 4'b1000, "AGE_63");
        check_latched_age(6'd63);

        @(negedge clk);
        reset = 1'b1;
        @(negedge clk);
        reset = 1'b0;
        check_result(IDLE, 4'b0000, "RESET_FROM_ERROR");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        #10;
        $finish;
    end

endmodule
