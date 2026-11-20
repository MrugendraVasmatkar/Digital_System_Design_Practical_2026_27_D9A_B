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
    reg [8*5-1:0] state_text;
    integer errors;
    integer i;
    reg [2:0] expected_compare;

    age_group_detector_core dut (
        .clk(clk),
        .sw(sw),
        .btn(btn),
        .led(led)
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

    always @(posedge clk) begin
        #1;
        $display("T=%0t AGE_SW=%0d AGE_SYNC=%0d AGE_LATCHED=%0d CMP[C,T,A]=%b%b%b NO_MATCH=%b STATE=%0s LED[ERR,AD,TE,CH]=%b",
                 $time, sw, dut.age_sync, dut.age_latched,
                 dut.child_detect, dut.teen_detect, dut.adult_detect,
                 dut.no_match, state_text, led);
    end

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

        // Initialize the FSM through the physical reset input.
        press_button(0);
        check_result(IDLE, 4'b0000, "INITIAL_RESET");

        // Check decoder outputs for every possible six-bit input.
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

        // Test every category boundary and both ends of the invalid range.
        test_age(6'd0,  CHILD, 4'b0001, "AGE_0_CHILD");
        test_age(6'd12, CHILD, 4'b0001, "AGE_12_CHILD");
        test_age(6'd13, TEEN,  4'b0010, "AGE_13_TEEN");
        test_age(6'd19, TEEN,  4'b0010, "AGE_19_TEEN");
        test_age(6'd20, ADULT, 4'b0100, "AGE_20_ADULT");
        test_age(6'd31, ADULT, 4'b0100, "AGE_31_ADULT");
        test_age(6'd32, ERROR, 4'b1000, "AGE_32_ERROR");
        test_age(6'd33, ERROR, 4'b1000, "AGE_33_ERROR");
        test_age(6'd63, ERROR, 4'b1000, "AGE_63_ERROR");

        // Verify RESET can clear an active ERROR state.
        @(negedge clk);
        sw = 6'd40;
        repeat (4) @(negedge clk);
        press_button(1);
        check_result(ERROR, 4'b1000, "ERROR_BEFORE_RESET");
        press_button(0);
        check_result(IDLE, 4'b0000, "RESET_FROM_ERROR");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d", errors);

        #20;
        $finish;
    end

endmodule
