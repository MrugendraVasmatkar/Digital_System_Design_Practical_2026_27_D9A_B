
`timescale 1ns / 1ps

module seven_segment (
    input wire clk,
    input wire reset,

    input wire select_cold,
    input wire select_neutral,
    input wire select_hot,

    input wire [3:0] Cold_Count,
    input wire [3:0] Neutral_Count,
    input wire [3:0] Hot_Count,

    input wire [2:0] temperature,

    output reg [3:0] D0_AN,
    output reg [7:0] D0_SEG,

    output wire [3:0] D1_AN,
    output wire [7:0] D1_SEG
);

    // Display value selection
    reg [3:0] display_value;

    always @(*) begin

        if (select_cold)
            display_value = Cold_Count;

        else if (select_neutral)
            display_value = Neutral_Count;

        else if (select_hot)
            display_value = Hot_Count;

        else
            display_value = {1'b0, temperature};

    end

    // Convert binary value into two decimal digits
    reg [3:0] tens;
    reg [3:0] ones;

    always @(*) begin

        if (display_value >= 4'd10) begin
            tens = 4'd1;
            ones = display_value - 4'd10;
        end

        else begin
            tens = 4'd0;
            ones = display_value;
        end

    end

    // Display scanning counter
    reg [16:0] refresh_counter;

    always @(posedge clk) begin

        if (reset)
            refresh_counter <= 0;

        else if (refresh_counter == 17'd99999)
            refresh_counter <= 0;

        else
            refresh_counter <= refresh_counter + 1'b1;

    end

    // Select between two digit positions
    wire digit_select;

    assign digit_select = refresh_counter[16];

    // Active LOW digit and segment outputs
    always @(*) begin

        D0_AN = 4'b1111;
        D0_SEG = 8'b11111111;

        if (digit_select == 1'b0) begin

            D0_AN = 4'b1110;
            D0_SEG = decode_digit(ones);

        end

        else begin

            D0_AN = 4'b1101;
            D0_SEG = decode_digit(tens);

        end

    end

    // Disable second four-digit display bank
    assign D1_AN = 4'b1111;
    assign D1_SEG = 8'b11111111;

    // Seven-segment decoder
    // Bit order: dp, g, f, e, d, c, b, a
    function [7:0] decode_digit;
        input [3:0] value;

        begin

            case (value)

                4'd0: decode_digit = 8'b11000000;
                4'd1: decode_digit = 8'b11111001;
                4'd2: decode_digit = 8'b10100100;
                4'd3: decode_digit = 8'b10110000;
                4'd4: decode_digit = 8'b10011001;
                4'd5: decode_digit = 8'b10010010;
                4'd6: decode_digit = 8'b10000010;
                4'd7: decode_digit = 8'b11111000;
                4'd8: decode_digit = 8'b10000000;
                4'd9: decode_digit = 8'b10010000;

                default: decode_digit = 8'b11111111;

            endcase

        end

    endfunction

endmodule
