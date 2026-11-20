`timescale 1ns / 1ps
module btn_pulse #(parameter DEBOUNCE = 1_000_000) ( // 10 ms at 100 MHz
    input  wire clk,
    input  wire btn,
    output reg  pulse
);
    reg s0 = 0, s1 = 0, stable = 0, stable_d = 0;
    reg [19:0] cnt = 0;
    always @(posedge clk) begin
        s0 <= btn;
        s1 <= s0;
        if (s1 == stable) cnt <= 0;
        else begin
            cnt <= cnt + 1;
            if (cnt == DEBOUNCE - 1) begin
                stable <= s1;
                cnt    <= 0;
            end
        end
        stable_d <= stable;
        pulse    <= stable & ~stable_d;
    end
endmodule