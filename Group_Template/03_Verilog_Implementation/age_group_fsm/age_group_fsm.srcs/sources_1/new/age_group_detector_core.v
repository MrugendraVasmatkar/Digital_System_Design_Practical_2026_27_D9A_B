module age_group_fsm (
    input wire clk,
    input wire reset,
    input wire start,
    input wire ack,
    input wire [5:0] age_in,
    output reg [3:0] led,
    output reg [2:0] state_debug,
    output reg [5:0] age_latched
);

    localparam IDLE  = 3'b000;
    localparam CHILD = 3'b001;
    localparam TEEN  = 3'b010;
    localparam ADULT = 3'b011;
    localparam ERROR = 3'b100;

    reg [2:0] next_state;

    always @(*) begin
        next_state = state_debug;

        case (state_debug)
            IDLE: begin
                if (start) begin
                    if (age_in > 6'd31)
                        next_state = ERROR;
                    else if (age_in <= 6'd12)
                        next_state = CHILD;
                    else if (age_in <= 6'd19)
                        next_state = TEEN;
                    else
                        next_state = ADULT;
                end
            end

            CHILD, TEEN, ADULT, ERROR: begin
                if (ack)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state_debug <= IDLE;
            age_latched <= 6'd0;
        end else begin
            state_debug <= next_state;

            if ((state_debug == IDLE) && start)
                age_latched <= age_in;
        end
    end

    always @(*) begin
        led = 4'b0000;

        case (state_debug)
            CHILD: led = 4'b0001;
            TEEN:  led = 4'b0010;
            ADULT: led = 4'b0100;
            ERROR: led = 4'b1000;
            default: led = 4'b0000;
        endcase
    end

endmodule

module age_group_detector_core (
    input wire clk,
    input wire [5:0] sw,
    input wire [2:0] btn,
    output wire [3:0] led
);

    reg [1:0] reset_sync;
    reg [1:0] start_sync;
    reg [1:0] ack_sync;
    reg start_prev;
    reg ack_prev;
    reg [5:0] age_meta;
    reg [5:0] age_sync;

    wire reset_signal;
    wire start_pulse;
    wire ack_pulse;
    wire [2:0] state_debug;
    wire [5:0] age_latched;

    assign reset_signal = reset_sync[1];
    assign start_pulse = start_sync[1] & ~start_prev;
    assign ack_pulse = ack_sync[1] & ~ack_prev;

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], btn[0]};
        start_sync <= {start_sync[0], btn[1]};
        ack_sync <= {ack_sync[0], btn[2]};

        start_prev <= start_sync[1];
        ack_prev <= ack_sync[1];

        age_meta <= sw;
        age_sync <= age_meta;
    end

    age_group_fsm detector (
        .clk(clk),
        .reset(reset_signal),
        .start(start_pulse),
        .ack(ack_pulse),
        .age_in(age_sync),
        .led(led),
        .state_debug(state_debug),
        .age_latched(age_latched)
    );

endmodule
