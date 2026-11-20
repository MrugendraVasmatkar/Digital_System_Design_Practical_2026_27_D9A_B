`timescale 1ns/1ps

// ---------------- Range decoder (combinational) ----------------
module range_decoder (
    input  wire [4:0] score,
    output reg  [2:0] next_cat
);
    localparam [2:0] S_LOW = 3'b001, S_MED = 3'b010, S_HIGH = 3'b011, S_ERR = 3'b100;
    always @(*) begin
        if      (score <= 5'd4)  next_cat = S_LOW;    // 0-4
        else if (score <= 5'd10) next_cat = S_MED;    // 5-10
        else if (score <= 5'd15) next_cat = S_HIGH;   // 11-15
        else                     next_cat = S_ERR;    // 16-31 invalid (H3)
    end
endmodule

// ---------------- Moore FSM ----------------
module game_score_fsm (
    input  wire       clk,
    input  wire       rst,        // synchronous, active-high
    input  wire       start,
    input  wire       ack,
    input  wire [4:0] score_in,
    output reg  [2:0] state,
    output reg  [4:0] score_reg,
    output wire       led_low,
    output wire       led_med,
    output wire       led_high,
    output wire       led_err
);
    localparam [2:0] S_IDLE = 3'b000,
                     S_LOW  = 3'b001,
                     S_MED  = 3'b010,
                     S_HIGH = 3'b011,
                     S_ERR  = 3'b100;

    wire [2:0] cat_state;
    range_decoder u_rd (.score(score_in), .next_cat(cat_state));

    reg [2:0] next_state;
    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE : if (start) next_state = cat_state;
            S_LOW,
            S_MED,
            S_HIGH,
            S_ERR  : if (ack)   next_state = S_IDLE;
            default:            next_state = S_IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            state     <= S_IDLE;
            score_reg <= 5'd0;
        end else begin
            state <= next_state;
            if (state == S_IDLE && start)
                score_reg <= score_in;
        end
    end

    assign led_low  = (state == S_LOW);
    assign led_med  = (state == S_MED);
    assign led_high = (state == S_HIGH);
    assign led_err  = (state == S_ERR);
endmodule

// ---------------- Button conditioner ----------------
module btn_cond #(parameter DEBOUNCE = 20'd1_000_000)  // 10 ms @ 100 MHz
(
    input  wire clk,
    input  wire btn_in,
    output reg  level,
    output wire pulse
);
    reg s0 = 0, s1 = 0, lvl_d = 0;
    reg [19:0] cnt = 0;
    initial level = 1'b0;
    always @(posedge clk) begin
        s0 <= btn_in;  s1 <= s0;
        if (s1 == level) cnt <= 0;
        else if (cnt == DEBOUNCE) begin level <= s1; cnt <= 0; end
        else cnt <= cnt + 1'b1;
        lvl_d <= level;
    end
    assign pulse = level & ~lvl_d;
endmodule

// ---------------- 7-segment driver ----------------
module seg7_driver #(
    parameter SEG_ACTIVE_LOW = 1,
    parameter AN_ACTIVE_LOW  = 1
)(
    input  wire       clk,
    input  wire [2:0] state,
    input  wire [4:0] score,
    output wire [6:0] seg,      // {g,f,e,d,c,b,a}
    output wire       dp,
    output wire [3:0] an
);
    reg [16:0] refresh = 0;
    always @(posedge clk) refresh <= refresh + 1'b1;
    wire [1:0] sel = refresh[16:15];

    reg [1:0] tens;  reg [3:0] ones;
    always @(*) begin
        if      (score >= 5'd30) begin tens = 2'd3; ones = score - 5'd30; end
        else if (score >= 5'd20) begin tens = 2'd2; ones = score - 5'd20; end
        else if (score >= 5'd10) begin tens = 2'd1; ones = score - 5'd10; end
        else                     begin tens = 2'd0; ones = score[3:0];    end
    end

    function [6:0] digit7(input [3:0] d);
        case (d)
            4'd0: digit7 = 7'b0111111;  4'd1: digit7 = 7'b0000110;
            4'd2: digit7 = 7'b1011011;  4'd3: digit7 = 7'b1001111;
            4'd4: digit7 = 7'b1100110;  4'd5: digit7 = 7'b1101101;
            4'd6: digit7 = 7'b1111101;  4'd7: digit7 = 7'b0000111;
            4'd8: digit7 = 7'b1111111;  4'd9: digit7 = 7'b1101111;
            default: digit7 = 7'b0000000;
        endcase
    endfunction

    reg [6:0] cat7;
    always @(*) case (state)
        3'b000: cat7 = 7'b1000000;   // '-' IDLE
        3'b001: cat7 = 7'b0111000;   // 'L'
        3'b010: cat7 = 7'b0110111;   // 'M'
        3'b011: cat7 = 7'b1110110;   // 'H'
        3'b100: cat7 = 7'b1111001;   // 'E'
        default: cat7 = 7'b0000000;
    endcase

    reg [6:0] seg_h;  reg [3:0] an_h;
    wire show_score = (state != 3'b000);
    always @(*) begin
        an_h = 4'b0000; seg_h = 7'b0000000;
        case (sel)
            2'd0: begin an_h = 4'b0001; seg_h = cat7; end
            2'd1: begin an_h = 4'b0000; seg_h = 7'b0000000; end
            2'd2: begin an_h = 4'b0100; seg_h = show_score ? digit7(ones) : 7'b0; end
            2'd3: begin an_h = 4'b1000; seg_h = show_score ? digit7({2'b00,tens}) : 7'b0; end
        endcase
    end
    assign seg = SEG_ACTIVE_LOW ? ~seg_h : seg_h;
    assign an  = AN_ACTIVE_LOW  ? ~an_h  : an_h;
    assign dp  = SEG_ACTIVE_LOW ? 1'b1 : 1'b0;
endmodule

// ---------------- Top level ----------------
module game_score_top (
    input  wire       clk,          // 100 MHz
    input  wire [4:0] sw,           // SW4..SW0 score (SW4 = out of range)
    input  wire       btn_start,    // BTN0
    input  wire       btn_ack,      // BTN1
    input  wire       btn_rst,      // BTN2
    output wire [3:0] led,          // {ERR, HIGH, MED, LOW}
    output wire [6:0] seg,
    output wire       dp,
    output wire [3:0] an
);
    wire start_p, ack_p, rst_lvl;
    wire s_lvl, a_lvl, r_pulse;
    btn_cond c_start (.clk(clk), .btn_in(btn_start), .level(s_lvl),   .pulse(start_p));
    btn_cond c_ack   (.clk(clk), .btn_in(btn_ack),   .level(a_lvl),   .pulse(ack_p));
    btn_cond c_rst   (.clk(clk), .btn_in(btn_rst),   .level(rst_lvl), .pulse(r_pulse));

    wire [2:0] state;  wire [4:0] score_reg;
    wire l_low, l_med, l_high, l_err;

    game_score_fsm u_fsm (
        .clk(clk), .rst(rst_lvl), .start(start_p), .ack(ack_p),
        .score_in(sw), .state(state), .score_reg(score_reg),
        .led_low(l_low), .led_med(l_med), .led_high(l_high), .led_err(l_err));

    assign led = {l_err, l_high, l_med, l_low};

    seg7_driver u_seg (.clk(clk), .state(state), .score(score_reg),
                       .seg(seg), .dp(dp), .an(an));
endmodule