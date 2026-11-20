`timescale 1ns / 1ps
// Forbidden Zone Rejector (4-bit) - structural Verilog, same blocks as the Logisim circuit
// Y = 0 for X = 6..9, Y = 1 otherwise. RESET is synchronous, active-high.

// D flip-flop (positive edge)
module dff (
    output reg q,
    input      d,
    input      clk
);
    initial q = 1'b0;
    always @(posedge clk)
        q <= d;
endmodule

// 2-to-1 multiplexer, 1 bit: y = s ? b : a
module mux2 (
    output y,
    input  a,
    input  b,
    input  s
);
    wire ns, t0, t1;
    not g0 (ns, s);
    and g1 (t0, a, ns);
    and g2 (t1, b, s);
    or  g3 (y, t0, t1);
endmodule

// 4-bit 2-to-1 multiplexer: sel = 0 -> X, sel = 1 -> 0000
module mux2_4bit (
    output [3:0] y,
    input  [3:0] a,
    input  [3:0] b,
    input        s
);
    mux2 m3 (.y(y[3]), .a(a[3]), .b(b[3]), .s(s));
    mux2 m2 (.y(y[2]), .a(a[2]), .b(b[2]), .s(s));
    mux2 m1 (.y(y[1]), .a(a[1]), .b(b[1]), .s(s));
    mux2 m0 (.y(y[0]), .a(a[0]), .b(b[0]), .s(s));
endmodule

// one register bit with enable: q+ = en ? d : q
module reg_bit_en (
    output q,
    input  d,
    input  en,
    input  clk
);
    wire nxt;
    mux2 m  (.y(nxt), .a(q), .b(d), .s(en));
    dff  ff (.q(q), .d(nxt), .clk(clk));
endmodule

// 4-bit register with enable
module register4 (
    output [3:0] q,
    input  [3:0] d,
    input        en,
    input        clk
);
    reg_bit_en r3 (.q(q[3]), .d(d[3]), .en(en), .clk(clk));
    reg_bit_en r2 (.q(q[2]), .d(d[2]), .en(en), .clk(clk));
    reg_bit_en r1 (.q(q[1]), .d(d[1]), .en(en), .clk(clk));
    reg_bit_en r0 (.q(q[0]), .d(d[0]), .en(en), .clk(clk));
endmodule

// Forbidden zone detector: FZ = Q3'.Q2.Q1 + Q3.Q2'.Q1'
module fz_detector (
    output       fz,
    input  [3:0] q
);
    wire nq3, nq2, nq1, t1, t2;
    not g1 (nq3, q[3]);
    not g2 (nq2, q[2]);
    not g3 (nq1, q[1]);
    and g4 (t1, nq3, q[2], q[1]);
    and g5 (t2, q[3], nq2, nq1);
    or  g6 (fz, t1, t2);
endmodule

// Moore FSM: IDLE = 00, REJECT = 01, S0+ = RESET'.ACK'.FZ
module fsm_controller (
    output s1,
    output s0,
    output accept,
    output reject,
    output y,
    input  fz,
    input  ack,
    input  rst,
    input  clk
);
    wire nack, nrst, ds0;
    supply0 gnd;
    not g1 (nack, ack);
    not g2 (nrst, rst);
    and g3 (ds0, fz, nack, nrst);
    dff ff_s1 (.q(s1), .d(gnd), .clk(clk));
    dff ff_s0 (.q(s0), .d(ds0), .clk(clk));
    not g4 (accept, s0);
    buf g5 (reject, s0);
    buf g6 (y, accept);
endmodule

// Top module
module rejector (
    input        clk,
    input        rst,
    input        start,
    input        ack,
    input  [3:0] x,
    output       y,
    output       accept_led,
    output       reject_led,
    output       fz,
    output [1:0] state,
    output [3:0] xreg
);
    wire clr, en;
    wire [3:0] mux_out;
    supply0 [3:0] zero4;

    or g_clr (clr, rst, ack);
    or g_en  (en, start, clr);

    mux2_4bit u_mux (.y(mux_out), .a(x), .b(zero4), .s(clr));
    register4 u_reg (.q(xreg), .d(mux_out), .en(en), .clk(clk));
    fz_detector u_fz (.fz(fz), .q(xreg));
    fsm_controller u_fsm (.s1(state[1]), .s0(state[0]), .accept(accept_led), .reject(reject_led),
                          .y(y), .fz(fz), .ack(ack), .rst(rst), .clk(clk));
endmodule
