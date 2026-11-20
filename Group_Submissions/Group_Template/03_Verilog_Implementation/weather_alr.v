`timescale 1ns / 1ps

module weather_alert_H4 (
    input  wire       clk,
    input  wire       reset,
    input  wire       START,
    input  wire       ACK,
    input  wire [2:0] Wind,

    output reg  [1:0] state,

    output reg  [3:0] Calm_Count,
    output reg  [3:0] Breezy_Count,
    output reg  [3:0] Storm_Count,

    output wire [3:0] Calm_LED,
    output wire [3:0] Breezy_LED,
    output wire [3:0] Storm_LED,

    output reg        Buzzer
);

    parameter IDLE   = 2'b00,
              CALM   = 2'b01,
              BREEZY = 2'b10,
              STORM  = 2'b11;

    assign Calm_LED   = Calm_Count;
    assign Breezy_LED = Breezy_Count;
    assign Storm_LED  = Storm_Count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state        <= IDLE;
            Calm_Count   <= 4'b0000;
            Breezy_Count <= 4'b0000;
            Storm_Count  <= 4'b0000;
        end
        else begin
            case (state)
                IDLE: begin
                    if (START) begin
                        if (Wind <= 3'd2) begin
                            state      <= CALM;
                            Calm_Count <= Calm_Count + 1'b1;
                        end
                        else if (Wind <= 3'd5) begin
                            state        <= BREEZY;
                            Breezy_Count <= Breezy_Count + 1'b1;
                        end
                        else begin
                            state       <= STORM;
                            Storm_Count <= Storm_Count + 1'b1;
                        end
                    end
                end

                CALM:   begin if (ACK) state <= IDLE; end
                BREEZY: begin if (ACK) state <= IDLE; end
                STORM:  begin if (ACK) state <= IDLE; end

                default: state <= IDLE;
            endcase
        end
    end

    // Moore output
    always @(*) begin
        Buzzer = 1'b0;
        if (state == STORM)
            Buzzer = 1'b1;
    end

endmodule