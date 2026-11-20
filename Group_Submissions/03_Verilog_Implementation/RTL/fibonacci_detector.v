`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:49:38
// Design Name: 
// Module Name: fibonacci_detector
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

module fibonacci_detector(
    input clk,
    input reset,
    input start,
    input ack,
    input input_valid,
    input [3:0] x,

    output reg fib_led,
    output reg nonfib_led,
    output reg error_led
);

// State declaration
parameter IDLE = 2'b00,
          FIB = 2'b01,
          NON_FIB = 2'b10,
          ERROR = 2'b11;

reg [1:0] state, next_state;
reg F;

// Fibonacci number detection
always @(*) begin
    case(x)
        4'd0, 4'd1, 4'd2, 4'd3,
        4'd5, 4'd8, 4'd13: F = 1'b1;

        default: F = 1'b0;
    endcase
end

// State transition logic
always @(posedge clk or posedge reset) begin
    if(reset)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin

    next_state = state;

    case(state)

        IDLE: begin
            if(start) begin
                if(input_valid == 0)
                    next_state = ERROR;
                else if(F == 1)
                    next_state = FIB;
                else
                    next_state = NON_FIB;
            end
        end

        FIB: begin
            if(ack)
                next_state = IDLE;
        end

        NON_FIB: begin
            if(ack)
                next_state = IDLE;
        end

        ERROR: begin
            if(ack)
                next_state = IDLE;
        end

        default: next_state = ERROR;

    endcase
end

// Output logic (Moore FSM)
always @(*) begin

    fib_led = 0;
    nonfib_led = 0;
    error_led = 0;

    case(state)

        IDLE: begin
            fib_led = 0;
            nonfib_led = 0;
            error_led = 0;
        end

        FIB: begin
            fib_led = 1;
        end

        NON_FIB: begin
            nonfib_led = 1;
        end

        ERROR: begin
            error_led = 1;
        end

    endcase
end

endmodule

    
