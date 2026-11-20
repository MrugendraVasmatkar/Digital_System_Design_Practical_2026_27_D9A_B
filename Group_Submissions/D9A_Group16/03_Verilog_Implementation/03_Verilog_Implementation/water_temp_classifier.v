`timescale 1ns / 1ps
// Mirrors Water_Temp.circ: comparators -> state decoder -> next-state logic -> 3 D flip-flops
module water_temp_classifier (
    input  wire       clk,
    input  wire       reset,      // synchronous, active-high
    input  wire       start,
    input  wire       ack,
    input  wire [2:0] temp,
    output wire       vc_valve,
    output wire       cold_valve,
    output wire       neutral_valve,
    output wire       hot_valve,
    output wire [2:0] state_out
);
    // ---------- 1) Temperature classifier ----------
    wire c1 = (temp < 3'd4);          // Comparator 1: Temp < 4
    wire c2 = (temp > 3'd5);          // Comparator 2: Temp > 5
    wire c3 = (temp < 3'd2);          // Comparator 3: Temp < 2
    wire cls_neutral = ~(c1 | c2);    // NOR gate
    wire cls_hot     = c2;
    wire cls_vc      = c1 & c3;       // AND
    wire cls_cold    = c1 & ~c3;      // AND with NOT

    // ---------- 2) Control inputs ----------
    wire nack   = ~ack;
    wire nreset = ~reset;

    // ---------- 5) State register: 3 D flip-flops ----------
    reg q2 = 1'b0, q1 = 1'b0, q0 = 1'b0;
    wire nq2 = ~q2, nq1 = ~q1, nq0 = ~q0;

    // ---------- 3) State decoder (IDLE=000 VC=001 COLD=010 NEUTRAL=011 HOT=100) ----------
    wire idle_state    = nq2 & nq1 & nq0;
    wire vc_state      = nq2 & nq1 & q0;
    wire cold_state    = nq2 & q1  & nq0;
    wire neutral_state = nq2 & q1  & q0;
    wire hot_state     = q2  & nq1 & nq0;

    // ---------- 4) Next-state logic ----------
    wire is_h = idle_state & start & cls_hot;
    wire is_c = idle_state & start & cls_cold;
    wire is_n = idle_state & start & cls_neutral;
    wire is_v = idle_state & start & cls_vc;

    wire hold_h = hot_state     & nack;
    wire hold_c = cold_state    & nack;
    wire hold_n = neutral_state & nack;
    wire hold_v = vc_state      & nack;

    wire raw_d2 = is_h | hold_h;
    wire raw_d1 = is_c | is_n | hold_c | hold_n;
    wire raw_d0 = is_v | is_n | hold_v | hold_n;

    wire d2 = nreset & raw_d2;
    wire d1 = nreset & raw_d1;
    wire d0 = nreset & raw_d0;

    always @(posedge clk) begin
        q2 <= d2;
        q1 <= d1;
        q0 <= d0;
    end

    // ---------- 6) Moore outputs (state only) ----------
    assign vc_valve      = vc_state;
    assign cold_valve    = cold_state;
    assign neutral_valve = neutral_state;
    assign hot_valve     = hot_state;
    assign state_out     = {q2, q1, q0};
endmodule