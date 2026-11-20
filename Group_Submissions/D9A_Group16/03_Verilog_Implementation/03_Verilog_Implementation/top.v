`timescale 1ns / 1ps
module top (
    input  wire       clk,        // 100 MHz
    input  wire [2:0] sw,         // Temp[2:0]
    input  wire [2:0] btn,        // btn[0]=START, btn[1]=ACK, btn[2]=RESET
    output wire [6:0] led         // [3:0]=valves, [6:4]=state
);
    wire start_p, ack_p, reset_p;
    wire vc, cold, neut, hot;
    wire [2:0] st;

    btn_pulse u_start (.clk(clk), .btn(btn[0]), .pulse(start_p));
    btn_pulse u_ack   (.clk(clk), .btn(btn[1]), .pulse(ack_p));
    btn_pulse u_reset (.clk(clk), .btn(btn[2]), .pulse(reset_p));

    water_temp_classifier u_core (
        .clk(clk), .reset(reset_p), .start(start_p), .ack(ack_p),
        .temp(sw),
        .vc_valve(vc), .cold_valve(cold),
        .neutral_valve(neut), .hot_valve(hot),
        .state_out(st)
    );

    assign led[0] = vc;      // Very Cold valve
    assign led[1] = cold;    // Cold valve
    assign led[2] = neut;    // Neutral valve
    assign led[3] = hot;     // Hot valve
    assign led[6:4] = st;    // current state, for the viva
endmodule