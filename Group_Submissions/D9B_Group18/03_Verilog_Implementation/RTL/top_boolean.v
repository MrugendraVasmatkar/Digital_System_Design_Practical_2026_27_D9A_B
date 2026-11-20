`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 20:31:03
// Design Name: 
// Module Name: top_boolean
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_boolean (
    input  wire       clk,         // 100 MHz
    input  wire [4:0] sw,          // sw[2:0]=Temp, sw[3]=START, sw[4]=ACK
    input  wire       btn_reset,   // BTN0 = RESET
    output wire [4:0] led          // led[0]=COLD, [1]=NEUTRAL, [2]=HOT, [4:3]=state
);
    // 2-FF synchronizers for the asynchronous switches/button
    reg [4:0] sw_s1 = 5'd0, sw_s2 = 5'd0;
    reg       rst_s1 = 1'b0, rst_s2 = 1'b0;
    always @(posedge clk) begin
        sw_s1  <= sw;         sw_s2  <= sw_s1;
        rst_s1 <= btn_reset;  rst_s2 <= rst_s1;
    end

    wire cold_v, neut_v, hot_v;
    wire [1:0] st;
    wire [2:0] treg;

    water_temp_mealy u_fsm (
        .clk(clk), .rst(rst_s2), .en(1'b1),
        .start(sw_s2[3]), .ack(sw_s2[4]), .temp_in(sw_s2[2:0]),
        .cold_valve(cold_v), .neutral_valve(neut_v), .hot_valve(hot_v),
        .state_out(st), .temp_reg_out(treg)
    );

    assign led[0]   = cold_v;
    assign led[1]   = neut_v;
    assign led[2]   = hot_v;
    assign led[4:3] = st;
endmodule