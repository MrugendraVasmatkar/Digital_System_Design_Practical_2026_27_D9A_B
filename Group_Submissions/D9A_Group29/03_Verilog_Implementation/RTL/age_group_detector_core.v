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
    output wire [3:0] led,
    output reg  [3:0] D0_AN,
    output reg  [7:0] D0_SEG,
    output reg  [3:0] D1_AN,
    output reg  [7:0] D1_SEG
);

    localparam IDLE  = 3'b000;
    localparam CHILD = 3'b001;
    localparam TEEN  = 3'b010;
    localparam ADULT = 3'b011;
    localparam ERROR = 3'b100;

    reg [1:0] reset_sync = 2'b00;
    reg [1:0] start_sync = 2'b00;
    reg [1:0] ack_sync   = 2'b00;
    reg       start_prev = 1'b0;
    reg       ack_prev   = 1'b0;
    reg [5:0] age_meta   = 6'd0;
    reg [5:0] age_sync   = 6'd0;
    reg [15:0] refresh_counter = 16'd0;

    wire start_pulse;
    wire ack_pulse;
    wire child_detect;
    wire teen_detect;
    wire adult_detect;
    wire no_match;
    wire [2:0] state_debug;
    wire [5:0] age_latched;
    wire [5:0] display_age;
    wire [3:0] age_tens;
    wire [3:0] age_ones;
    wire [1:0] scan_digit;
    wire [1:0] display_position;

    assign start_pulse = start_sync[1] & ~start_prev;
    assign ack_pulse   = ack_sync[1] & ~ack_prev;
    assign scan_digit  = refresh_counter[15:14];
    assign display_position = 2'd3 - scan_digit;

    assign display_age = (state_debug == IDLE) ? age_sync : age_latched;
    assign age_tens = display_age / 6'd10;
    assign age_ones = display_age % 6'd10;

    always @(posedge clk) begin
        reset_sync <= {reset_sync[0], btn[0]};
        start_sync <= {start_sync[0], btn[1]};
        ack_sync   <= {ack_sync[0], btn[2]};

        start_prev <= start_sync[1];
        ack_prev   <= ack_sync[1];

        age_meta <= sw;
        age_sync <= age_meta;

        refresh_counter <= refresh_counter + 1'b1;
        if (reset_sync[1])
            refresh_counter <= 16'd0;
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

    function [7:0] digit_to_segments;
        input [3:0] digit;
        begin
            case (digit)
                4'd0: digit_to_segments = 8'hC0;
                4'd1: digit_to_segments = 8'hF9;
                4'd2: digit_to_segments = 8'hA4;
                4'd3: digit_to_segments = 8'hB0;
                4'd4: digit_to_segments = 8'h99;
                4'd5: digit_to_segments = 8'h92;
                4'd6: digit_to_segments = 8'h82;
                4'd7: digit_to_segments = 8'hF8;
                4'd8: digit_to_segments = 8'h80;
                4'd9: digit_to_segments = 8'h90;
                default: digit_to_segments = 8'hFF;
            endcase
        end
    endfunction

    function [7:0] state_to_segments;
        input [2:0] state;
        input [1:0] position;
        begin
            case (state)
                IDLE: begin
                    case (position)
                        2'd0: state_to_segments = 8'hF9;
                        2'd1: state_to_segments = 8'hA1;
                        2'd2: state_to_segments = 8'hC7;
                        2'd3: state_to_segments = 8'h86;
                        default: state_to_segments = 8'hFF;
                    endcase
                end
                CHILD: begin
                    case (position)
                        2'd0: state_to_segments = 8'hC6;
                        2'd1: state_to_segments = 8'h89;
                        2'd2: state_to_segments = 8'hC7;
                        2'd3: state_to_segments = 8'hA1;
                        default: state_to_segments = 8'hFF;
                    endcase
                end
                TEEN: begin
                    case (position)
                        2'd0: state_to_segments = 8'h87;
                        2'd1: state_to_segments = 8'h86;
                        2'd2: state_to_segments = 8'h86;
                        2'd3: state_to_segments = 8'hAB;
                        default: state_to_segments = 8'hFF;
                    endcase
                end
                ADULT: begin
                    case (position)
                        2'd0: state_to_segments = 8'h88;
                        2'd1: state_to_segments = 8'hA1;
                        2'd2: state_to_segments = 8'hC1;
                        2'd3: state_to_segments = 8'hC7;
                        default: state_to_segments = 8'hFF;
                    endcase
                end
                ERROR: begin
                    case (position)
                        2'd0: state_to_segments = 8'h86;
                        2'd1: state_to_segments = 8'hAF;
                        2'd2: state_to_segments = 8'hAF;
                        2'd3: state_to_segments = 8'hFF;
                        default: state_to_segments = 8'hFF;
                    endcase
                end
                default: state_to_segments = 8'hFF;
            endcase
        end
    endfunction

    always @(*) begin
        D0_AN  = 4'b1111;
        D1_AN  = 4'b1111;
        D0_SEG = 8'hFF;
        D1_SEG = 8'hFF;

        case (scan_digit)
            2'd0: begin
                D0_AN = 4'b1110;
                D1_AN = 4'b1110;
            end
            2'd1: begin
                D0_AN = 4'b1101;
                D1_AN = 4'b1101;
            end
            2'd2: begin
                D0_AN = 4'b1011;
                D1_AN = 4'b1011;
            end
            2'd3: begin
                D0_AN = 4'b0111;
                D1_AN = 4'b0111;
            end
            default: begin
                D0_AN = 4'b1111;
                D1_AN = 4'b1111;
            end
        endcase

        case (display_position)
            2'd0, 2'd1: D0_SEG = digit_to_segments(4'd0);
            2'd2:       D0_SEG = digit_to_segments(age_tens);
            2'd3:       D0_SEG = digit_to_segments(age_ones);
            default:    D0_SEG = 8'hFF;
        endcase

        D1_SEG = state_to_segments(state_debug, display_position);
    end

endmodule
