`timescale 1ns / 1ps
//==============================================================
// Gaming XP Level Decoder - H5 (previous level + change LED set)
// Top module: xp_h5_top
//==============================================================

//---------------- Button / switch conditioner -----------------
module btn_cond #(parameter DB = 20'd500_000) (   // ~5 ms at 100 MHz
    input      clk,
    input      raw,
    output reg level = 1'b0,   // debounced level
    output     pulse           // one clock on rising edge
);
    reg s1 = 1'b0, s2 = 1'b0, lv_d = 1'b0;
    reg [19:0] cnt = 20'd0;
    always @(posedge clk) begin
        s1 <= raw;
        s2 <= s1;
        if (s2 == level) cnt <= 20'd0;
        else if (cnt == DB) begin level <= s2; cnt <= 20'd0; end
        else cnt <= cnt + 20'd1;
        lv_d <= level;
    end
    assign pulse = level & ~lv_d;
endmodule

//---------------- Core design (your H5 logic) -----------------
module xp_decoder_h5 (
    input        clk,
    input        reset,       // synchronous, active-high
    input        start,       // one-clock pulse
    input        ack,         // one-clock pulse
    input  [3:0] xp,          // already synchronized
    output [2:0] main_led,    // {EXPERT, INTERMEDIATE, BEGINNER} (Moore)
    output       change,      // clock for the second LED set
    output reg [2:0] led2 = 3'b000  // second set: old level, lit only on change
);
    localparam IDLE = 2'b00, BEG = 2'b01, INT = 2'b10, EXP = 2'b11;

    reg [1:0] state = IDLE;
    reg [1:0] next_state;
    reg [1:0] cur_level = 2'b00, last_level = 2'b00;
    reg       cur_valid = 1'b0, last_valid = 1'b0;
    reg       clr_q = 1'b0, pend = 1'b0, change_q = 1'b0;

    wire [1:0] new_level = (xp <= 4'd3)  ? BEG :
                           (xp <= 4'd10) ? INT : EXP;
    wire sample = (state == IDLE) && start;

    // Next-state logic (Moore)
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:          if (start) next_state = new_level;
            BEG, INT, EXP: if (ack)   next_state = IDLE;
        endcase
    end

    // State register, level history, change pulse
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE; cur_level <= 2'b00; last_level <= 2'b00;
            cur_valid <= 1'b0; last_valid <= 1'b0;
            clr_q <= 1'b0; pend <= 1'b0; change_q <= 1'b0;
        end else begin
            state    <= next_state;
            clr_q    <= sample;     // clear old glow
            pend     <= clr_q;
            change_q <= pend && last_valid && (cur_level != last_level);
            if (sample) begin
                last_level <= cur_level;
                last_valid <= cur_valid;
                cur_level  <= new_level;
                cur_valid  <= 1'b1;
            end
        end
    end

    assign change = change_q;

    // Second LED set: clocked by `change`, cleared when next input arrives
    wire clr_all = clr_q | reset;
    always @(posedge change or posedge clr_all) begin
        if (clr_all) led2 <= 3'b000;
        else         led2 <= {last_level == EXP, last_level == INT, last_level == BEG};
    end

    assign main_led = {state == EXP, state == INT, state == BEG};
endmodule

//---------------- Top level for the FPGA board ----------------
module xp_h5_top #(parameter DB = 20'd500_000) (
    input        clk,         // board clock (100 MHz)
    input        rst_btn,
    input        start_btn,
    input        ack_btn,
    input  [3:0] xp_sw,
    output [2:0] main_led,    // Beginner / Intermediate / Expert (LED1-3)
    output [2:0] led2         // old level on change (LED4-6)
);
    wire rst_lvl, start_p, ack_p, unused_a, unused_b, unused_c;

    btn_cond #(.DB(DB)) u_rst   (.clk(clk), .raw(rst_btn),   .level(rst_lvl),  .pulse(unused_a));
    btn_cond #(.DB(DB)) u_start (.clk(clk), .raw(start_btn), .level(unused_b), .pulse(start_p));
    btn_cond #(.DB(DB)) u_ack   (.clk(clk), .raw(ack_btn),   .level(unused_c), .pulse(ack_p));

    reg [3:0] xp_s1 = 4'd0, xp_s2 = 4'd0;
    always @(posedge clk) begin xp_s1 <= xp_sw; xp_s2 <= xp_s1; end

    wire change_unused;
    xp_decoder_h5 u_core (
        .clk(clk), .reset(rst_lvl), .start(start_p), .ack(ack_p),
        .xp(xp_s2), .main_led(main_led), .change(change_unused), .led2(led2)
    );
endmodule