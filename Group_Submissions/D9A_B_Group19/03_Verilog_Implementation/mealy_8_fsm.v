// 8-State Mealy FSM

module mealy_fsm (
    input clk,
    input reset,
    input [7:0] Y,

    output reg [2:0] state,
    output reg ACK,

    output reg GREEN_LED,
    output reg YELLOW_LED,
    output reg RED_LED
);

parameter IDLE  = 3'b000,
          NOW2  = 3'b001,
          WARN1 = 3'b010,
          WARN2 = 3'b011,
          WARN3 = 3'b100,
          LOCK1 = 3'b101,
          LOCK2 = 3'b110,
          LOCK3 = 3'b111;

reg [2:0] next_state;


// Next State Logic

always @(*) begin

    next_state = state;

    case (state)

        IDLE: begin
            if (Y[1])
                next_state = NOW2;
          
        end

        NOW2: begin
            if (Y[2])
                next_state = WARN1;
        end

        WARN1: begin
            if (Y[3])
                next_state = WARN2;
        end

        WARN2: begin
            if (Y[4])
                next_state = WARN3;
        end

        WARN3: begin
            if (Y[5])
                next_state = LOCK1;
        end

        LOCK1: begin
            if (Y[6])
                next_state = LOCK2;
        end

        LOCK2: begin
            if (Y[7])
                next_state = LOCK3;
        end

        LOCK3: begin
            if (!Y[7])
                next_state = IDLE;
        end

        default: begin
            next_state = IDLE;
        end

    endcase

end


// State Register and ACK Output

always @(posedge clk or posedge reset) begin

    if (reset) begin
        state <= IDLE;
        ACK <= 1'b0;
    end

    else begin
        ACK <= (next_state != state);
        state <= next_state;
    end

end


// LED Control Logic

always @(*) begin

    GREEN_LED = 1'b0;
    YELLOW_LED = 1'b0;
    RED_LED = 1'b0;

    case (state)

        IDLE, NOW2:
            GREEN_LED = 1'b1;

        WARN1, WARN2, WARN3:
            YELLOW_LED = 1'b1;

        LOCK1, LOCK2, LOCK3:
            RED_LED = 1'b1;

        default:
            GREEN_LED = 1'b1;

    endcase

end

endmodule

