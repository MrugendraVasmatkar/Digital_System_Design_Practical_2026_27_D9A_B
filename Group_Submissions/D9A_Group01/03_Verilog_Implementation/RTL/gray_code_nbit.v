`timescale 1ns / 1ps

module gray_code_nbit #(
    parameter N = 4
)(
    input  wire         clk,
    input  wire         rst,
    input  wire         start,
    input  wire         ack,
    input  wire [N-1:0] x,
    output wire         valid_led,
    output wire         invalid_led
);
    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] VALID   = 2'b01;
    localparam [1:0] INVALID = 2'b10;

    reg [N-1:0] p;          // Previous input register P[cite: 1]
    reg [1:0]   state;      // Moore FSM state[cite: 1]

    // D = X ^ P[cite: 1]
    wire [N-1:0] d = x ^ p;

    // General one-bit change detector[cite: 1]:
    // At least one bit changed (|d) AND no two bits changed simultaneously (~|(d & (d - 1'b1)))
    wire at_least_one = |d;
    wire at_most_one  = ~|(d & (d - {{(N-1){1'b0}}, 1'b1}));
    wire v            = at_least_one & at_most_one;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            p     <= {N{1'b0}};
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        p     <= x;
                        state <= v ? VALID : INVALID;
                    end
                end
                VALID, INVALID: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Moore outputs based on state[cite: 1]
    assign valid_led   = (state == VALID);
    assign invalid_led = (state == INVALID);
endmodule
