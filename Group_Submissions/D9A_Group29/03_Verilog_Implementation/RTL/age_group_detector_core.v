module age_range_decoder (
    input  wire [5:0] age_in,
    output wire       child_detect,
    output wire       teen_detect,
    output wire       adult_detect,
    output wire       no_match
);

    assign child_detect = (age_in <= 6'd12);
    assign teen_detect  = (age_in >= 6'd13) && (age_in <= 6'd19);
    assign adult_detect = (age_in >= 6'd20) && (age_in <= 6'd31);
    assign no_match     = ~(child_detect | teen_detect | adult_detect);

endmodule

module age_group_fsm (
    input  wire       clk,
    input  wire       reset,
    input  wire       start,
    input  wire       ack,
    input  wire [5:0] age_in,
    input  wire       child_detect,
    input  wire       teen_detect,
    input  wire       adult_detect,
    input  wire       no_match,
    output reg  [3:0] led,
    output reg  [2:0] state_debug,
    output reg  [5:0] age_latched
);

    localparam IDLE  = 3'b000;
    localparam CHILD = 3'b001;
    localparam TEEN  = 3'b010;
    localparam ADULT = 3'b011;
    localparam ERROR = 3'b100;

    always @(posedge clk) begin
        if (reset) begin
            state_debug <= IDLE;
            age_latched <= 6'd0;
        end else begin
            case (state_debug)
                IDLE: begin
                    if (start) begin
                        age_latched <= age_in;
                        if (no_match)
                            state_debug <= ERROR;
                        else if (child_detect)
                            state_debug <= CHILD;
                        else if (teen_detect)
                            state_debug <= TEEN;
                        else if (adult_detect)
                            state_debug <= ADULT;
                        else
                            state_debug <= ERROR;
                    end
                end

                CHILD, TEEN, ADULT, ERROR: begin
                    if (ack)
                        state_debug <= IDLE;
                end

                default: state_debug <= IDLE;
            endcase
        end
    end

    always @(*) begin
        case (state_debug)
            CHILD:   led = 4'b0001;
            TEEN:    led = 4'b0010;
            ADULT:   led = 4'b0100;
            ERROR:   led = 4'b1000;
            default: led = 4'b0000;
        endcase
    end

endmodule

module age_group_detector_core (
    input  wire       clk,
    input  wire [5:0] sw,
    input  wire [2:0] btn,
    output wire [3:0] led
);

    reg [1:0] reset_sync = 2'b00;
    reg [1:0] start_sync = 2'b00;
    reg [1:0] ack_sync   = 2'b00;
    reg       start_prev = 1'b0;
    reg       ack_prev   = 1'b0;
    reg [5:0] age_meta   = 6'd0;
    reg [5:0] age_sync   = 6'd0;

    wire start_pulse;
    wire ack_pulse;
    wire child_detect;
    wire teen_detect;
    wire adult_detect;
    wire no_match;
    wire [2:0] state_debug;
    wire [5:0] age_latched;

    assign start_pulse = start_sync[1] & ~start_prev;
    assign ack_pulse   = ack_sync[1] & ~ack_prev;

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], btn[0]};
        start_sync <= {start_sync[0], btn[1]};
        ack_sync   <= {ack_sync[0], btn[2]};

        start_prev <= start_sync[1];
        ack_prev   <= ack_sync[1];

        age_meta <= sw;
        age_sync <= age_meta;
    end

    age_range_decoder decoder (
        .age_in(age_sync),
        .child_detect(child_detect),
        .teen_detect(teen_detect),
        .adult_detect(adult_detect),
        .no_match(no_match)
    );

    age_group_fsm fsm (
        .clk(clk),
        .reset(reset_sync[1]),
        .start(start_pulse),
        .ack(ack_pulse),
        .age_in(age_sync),
        .child_detect(child_detect),
        .teen_detect(teen_detect),
        .adult_detect(adult_detect),
        .no_match(no_match),
        .led(led),
        .state_debug(state_debug),
        .age_latched(age_latched)
    );

endmodule
