// Top-level wrapper for the Boolean board (Spartan-7)
// Port names match the board's master constraint file (clk, sw, btn, led).
//
//   sw[4:0]   -> age (A0..A4)
//   btn[0]    -> START
//   btn[1]    -> ACK
//   btn[2]    -> RESET
//   led[0]    -> CHILD LED
//   led[1]    -> TEEN  LED
//   led[2]    -> ADULT LED
//   led[3]    -> unused (off)
//   led[7:4]  -> Child_Count[3:0]
//   led[11:8] -> Teen_Count[3:0]
//   led[15:12]-> Adult_Count[3:0]
module age_group_detector_top (
    input         clk,        // 100 MHz on-board clock
    input  [4:0]  sw,         // slide switches SW0..SW4
    input  [2:0]  btn,        // push buttons BTN0..BTN2
    output [15:0] led         // on-board LEDs LD0..LD15
);
    wire       child_led, teen_led, adult_led;
    wire [3:0] child_count, teen_count, adult_count;

    age_group_detector u_core (
        .clk         (clk),
        .reset       (btn[2]),
        .start       (btn[0]),
        .ack         (btn[1]),
        .age         (sw[4:0]),
        .child_led   (child_led),
        .teen_led    (teen_led),
        .adult_led   (adult_led),
        .child_count (child_count),
        .teen_count  (teen_count),
        .adult_count (adult_count)
    );

    assign led[0]     = child_led;
    assign led[1]     = teen_led;
    assign led[2]     = adult_led;
    assign led[3]     = 1'b0;
    assign led[7:4]   = child_count;
    assign led[11:8]  = teen_count;
    assign led[15:12] = adult_count;
endmodule
