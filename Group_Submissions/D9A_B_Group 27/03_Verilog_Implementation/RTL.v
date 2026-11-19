// Age Group Detector - Moore FSM + Child/Teen/Adult counters (H4)
// Written to mirror the Logisim circuit gate-for-gate.
// Internal state encoding: 00 IDLE, 01 CHILD, 10 TEEN, 11 ADULT
// Ranges: CHILD 0-12, TEEN 13-19, ADULT 20-31
module age_group_detector (
    input        clk,
    input        reset,        // RESET (asynchronous, also gated into next-state logic)
    input        start,        // START
    input        ack,          // ACK
    input  [4:0] age,          // A4..A0
    output       child_led,
    output       teen_led,
    output       adult_led,
    output [3:0] child_count,
    output [3:0] teen_count,
    output [3:0] adult_count
);
    // ---------------- 5-bit input register (loads while IDLE) ----------------
    reg [4:0] in_reg;           // IN_A4..IN_A0
    reg       s1, s0;           // state flip-flops S1, S0
    wire      idle = ~s1 & ~s0; // AND with inverted inputs (green enable wire)

    always @(posedge clk or posedge reset) begin
        if (reset)     in_reg <= 5'b0;
        else if (idle) in_reg <= age;
    end

    // ---------------- Range decoder (combinational) ----------------
    wire or_a3_a2  = in_reg[3] | in_reg[2];
    wire and_a3_a2 = in_reg[3] & in_reg[2];
    wire or_a1_a0  = in_reg[1] | in_reg[0];

    wire adult_det = in_reg[4] & or_a3_a2;                  // 20-31
    wire ge13      = and_a3_a2 & or_a1_a0;                  // 13-15 (with A4=0)
    wire child_det = ~in_reg[4] & ~ge13;                    // 0-12
    wire teen_det  = ~(adult_det | child_det);              // 13-19

    // ---------------- Next-state logic ----------------
    wire go = idle & (start & ~ack);                        // leave IDLE

    wire s1_d = ((go & ~child_det) | (s1 & ~ack)) & ~reset; // TEEN/ADULT -> S1=1
    wire s0_d = ((go & ~teen_det ) | (s0 & ~ack)) & ~reset; // CHILD/ADULT -> S0=1

    always @(posedge clk or posedge reset) begin
        if (reset) begin s1 <= 1'b0; s0 <= 1'b0; end
        else       begin s1 <= s1_d; s0 <= s0_d; end
    end

    // ---------------- Moore outputs ----------------
    assign child_led =  s0 & ~s1;
    assign teen_led  =  s1 & ~s0;
    assign adult_led =  s1 &  s0;

    // ---------------- Category counters (clocked by each LED) ----------------
    reg [3:0] child_cnt, teen_cnt, adult_cnt;

    always @(posedge child_led or posedge reset)
        if (reset) child_cnt <= 4'd0; else child_cnt <= child_cnt + 4'd1;
    always @(posedge teen_led or posedge reset)
        if (reset) teen_cnt  <= 4'd0; else teen_cnt  <= teen_cnt  + 4'd1;
    always @(posedge adult_led or posedge reset)
        if (reset) adult_cnt <= 4'd0; else adult_cnt <= adult_cnt + 4'd1;

    assign child_count = child_cnt;
    assign teen_count  = teen_cnt;
    assign adult_count = adult_cnt;
endmodule