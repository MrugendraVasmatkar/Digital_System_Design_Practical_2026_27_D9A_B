`timescale 1ns / 1ps

module FIBONACCI(
    input clk,
    input reset,
    input start,
    input ack,
    input [3:0] X,

    output reg F,
    output FIB,
    output NON_FIB
);

  
    parameter S1 = 1'b0;
    parameter S2 = 1'b1;

    reg state, next_state;

    
    reg fib;

    always @(*) begin
        case (X)

            4'b0000,  4'b0001,  4'b0010,  4'b0011,
            4'b0101,  4'b1000,  4'b1101:
                fib = 1'b1;

            default:
                fib = 1'b0;

        endcase
    end

    //mealy
    always @(*) begin

        next_state = state;
        F = 1'b0;

        case (state)

            // S1: IDLE
            S1: begin
                if (start) begin
                    F = fib;
                    next_state = S2;
                end
            end

            // S2: WAIT_ACK
            S2: begin
                F = 1'b0;

                if (ack)
                    next_state = S1;
            end

            default: begin
                next_state = S1;
                F = 1'b0;
            end

        endcase
    end

    // Sequential state register
    always @(posedge clk or posedge reset) begin

        if (reset)
            state <= S1;

        else
            state <= next_state;

    end

    // LED outputs
    assign FIB = F;

    assign NON_FIB = (state == S1) && start && !fib;

endmodule
