`timescale 1ns / 1ps
//==============================================================================
// Game Score Categorizer - Moore FSM + H4 Category Counters  (Boolean Board)
//   IDLE(00) -> LOW(01) score 0-4 | MEDIUM(10) score 5-10 | HIGH(11) score 11-15
//==============================================================================

// ---------------------------------------------------------------- core (Logisim)
module game_score_categorizer (
    input  wire       clk,
    input  wire       rst,        // async, active-high
    input  wire       start,
    input  wire       ack,
    input  wire [3:0] score,
    output wire       low_led,
    output wire       med_led,
    output wire       high_led,
    output reg  [3:0] low_count,
    output reg  [3:0] med_count,
    output reg  [3:0] high_count,
    output wire [1:0] state_out
);
    localparam [1:0] S_IDLE = 2'b00, S_LOW = 2'b01, S_MED = 2'b10, S_HIGH = 2'b11;

    reg  [1:0] state, next_state;

    wire is_low  = (score <  4'd5);
    wire is_high = (score >  4'd10);
    wire is_med  = ~is_low & ~is_high;

    wire go = (state == S_IDLE) & start;

    always @(*) begin
        next_state = state;
        case (state)
            S_IDLE:  if (start) next_state = is_low ? S_LOW : (is_high ? S_HIGH : S_MED);
            default: if (ack)   next_state = S_IDLE;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst) state <= S_IDLE;
        else     state <= next_state;
    end

    assign low_led   = (state == S_LOW);
    assign med_led   = (state == S_MED);
    assign high_led  = (state == S_HIGH);
    assign state_out = state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            low_count  <= 4'd0;
            med_count  <= 4'd0;
            high_count <= 4'd0;
        end else begin
            if (go & is_low)  low_count  <= low_count  + 4'd1;
            if (go & is_med)  med_count  <= med_count  + 4'd1;
            if (go & is_high) high_count <= high_count + 4'd1;
        end
    end
endmodule

// ---------------------------------------------------------------- debouncer
module debounce #(parameter integer CYCLES = 2_000_000) (   // 20 ms @ 100 MHz
    input  wire clk,
    input  wire din,
    output reg  dout = 1'b0
);
    reg        s0 = 1'b0, s1 = 1'b0;
    reg [20:0] cnt = 21'd0;
    always @(posedge clk) begin
        s0 <= din;
        s1 <= s0;
        if (s1 == dout) cnt <= 21'd0;
        else if (cnt == CYCLES - 1) begin
            dout <= s1;
            cnt  <= 21'd0;
        end else cnt <= cnt + 21'd1;
    end
endmodule

// ---------------------------------------------------------------- Boolean Board top
// sw[3:0] = score   btn[0] = START   btn[1] = ACK   btn[2] = RESET
// led[0] = LOW   led[1] = MEDIUM   led[2] = HIGH
// 7-seg display 0 (hex digits):  an[3] = state (0 IDLE,1 LOW,2 MED,3 HIGH)
//                                an[2] = LOW count   an[1] = MEDIUM count   an[0] = HIGH count
module top_boolean (
    input  wire       mclk,
    input  wire [3:0] sw,
    input  wire [2:0] btn,
    output wire [2:0] led,
    output wire [3:0] D0_a,       // digit enables, active low
    output wire [7:0] D0_seg      // segments {dp,g,f,e,d,c,b,a}, active low
);
    wire start_db, ack_db, rst_db;
    debounce u_db0 (.clk(mclk), .din(btn[0]), .dout(start_db));
    debounce u_db1 (.clk(mclk), .din(btn[1]), .dout(ack_db));
    debounce u_db2 (.clk(mclk), .din(btn[2]), .dout(rst_db));

    reg [3:0] sw_s0 = 4'd0, sw_s1 = 4'd0;
    reg       start_q = 1'b0, ack_q = 1'b0;
    always @(posedge mclk) begin
        sw_s0   <= sw;
        sw_s1   <= sw_s0;
        start_q <= start_db;
        ack_q   <= ack_db;
    end
    wire start_p = start_db & ~start_q;   // one-clock pulses
    wire ack_p   = ack_db   & ~ack_q;

    wire       low_led, med_led, high_led;
    wire [3:0] low_count, med_count, high_count;
    wire [1:0] state_out;

    game_score_categorizer u_core (
        .clk(mclk), .rst(rst_db), .start(start_p), .ack(ack_p), .score(sw_s1),
        .low_led(low_led), .med_led(med_led), .high_led(high_led),
        .low_count(low_count), .med_count(med_count), .high_count(high_count),
        .state_out(state_out)
    );

    assign led = {high_led, med_led, low_led};

    // ---- 7-segment multiplexing (~190 Hz per digit)
    reg [16:0] refresh = 17'd0;
    always @(posedge mclk) refresh <= refresh + 17'd1;
    wire [1:0] sel = refresh[16:15];

    reg [3:0] digit;
    always @(*) begin
        case (sel)
            2'd0:    digit = high_count;
            2'd1:    digit = med_count;
            2'd2:    digit = low_count;
            default: digit = {2'b00, state_out};
        endcase
    end

    reg [6:0] seg_on;                      // {g,f,e,d,c,b,a}, active high
    always @(*) begin
        case (digit)
            4'h0: seg_on = 7'h3F;  4'h1: seg_on = 7'h06;
            4'h2: seg_on = 7'h5B;  4'h3: seg_on = 7'h4F;
            4'h4: seg_on = 7'h66;  4'h5: seg_on = 7'h6D;
            4'h6: seg_on = 7'h7D;  4'h7: seg_on = 7'h07;
            4'h8: seg_on = 7'h7F;  4'h9: seg_on = 7'h6F;
            4'hA: seg_on = 7'h77;  4'hB: seg_on = 7'h7C;
            4'hC: seg_on = 7'h39;  4'hD: seg_on = 7'h5E;
            4'hE: seg_on = 7'h79;  default: seg_on = 7'h71;
        endcase
    end

    assign D0_a   = ~(4'b0001 << sel);     // one digit on at a time, active low
    assign D0_seg = {1'b1, ~seg_on};       // decimal point off, segments active low
endmodule
