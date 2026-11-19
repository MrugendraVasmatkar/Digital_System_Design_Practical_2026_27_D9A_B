`timescale 1ns / 1ps
//==============================================================================
// Gray Code Transition Detector - N-bit version (Hint H1), Moore FSM
//
// Datapath (per block diagram):
//   Input register X  <- data_in on a START pulse
//   Previous register P <- old X on the same START pulse
//   One-bit change detector: D = X xor P
//                            V = (sum D_i) & ~(sum_{i<j} D_i D_j)
//                              = "exactly one bit of D is 1"
// Controller: Moore FSM, state encoding  00 IDLE, 01 VALID, 10 INVALID
//   IDLE    : both LEDs off
//   VALID   : VALID LED on   (exactly one bit changed)
//   INVALID : INVALID LED on (zero bits or more than one bit changed)
//
// START : rising edge loads a new sample (level input is fine, held = 1 sample)
// ACK   : returns FSM to IDLE (has priority over START)
// RST   : synchronous, active-high; clears X, P and the FSM (X = P = 0)
//==============================================================================
module gray_code_detector #(
    parameter N = 4                      // input width, N >= 4 (e.g. 4, 5, 8)
)(
    input  wire           clk,
    input  wire           rst,           // synchronous, active-high
    input  wire           start,         // load sample
    input  wire           ack,           // return to IDLE
    input  wire [N-1:0]   data_in,       // switches X[N-1:0]

    output wire           valid_led,     // 1 -> valid Gray transition
    output wire           invalid_led,   // 1 -> zero or >1 bit changed
    output wire           idle_led,      // 1 -> IDLE (extra indicator)
    output wire [1:0]     state_out,     // 00 IDLE, 01 VALID, 10 INVALID
    output wire [N-1:0]   curr_out,      // input register X
    output wire [N-1:0]   prev_out,      // previous register P
    output wire           v_out          // one-bit-change detector output
);

    // ---------------- state encoding ----------------
    localparam [1:0] IDLE    = 2'b00;
    localparam [1:0] VALID   = 2'b01;
    localparam [1:0] INVALID = 2'b10;

    // ---------------- registers ----------------
    reg [N-1:0] x_reg;                   // current sample
    reg [N-1:0] p_reg;                   // previous sample
    reg         start_d;                 // START delayed (edge detect)
    reg         eval;                    // one cycle after a sample was loaded
    reg [1:0]   state, next_state;

    initial begin
        x_reg   = {N{1'b0}};
        p_reg   = {N{1'b0}};
        start_d = 1'b0;
        eval    = 1'b0;
        state   = IDLE;
    end

    // ---------------- one-bit change detector (general N, from H1) ----------------
    // V = (D0+D1+...+D(N-1)) & ~( sum over all pairs i<j of Di*Dj )
    function one_bit_change;
        input [N-1:0] dv;
        integer i, j;
        reg any_bit, two_bits;
        begin
            any_bit  = 1'b0;
            two_bits = 1'b0;
            for (i = 0; i < N; i = i + 1) begin
                any_bit = any_bit | dv[i];
                for (j = i + 1; j < N; j = j + 1)
                    two_bits = two_bits | (dv[i] & dv[j]);
            end
            one_bit_change = any_bit & ~two_bits;
        end
    endfunction

    wire [N-1:0] diff = x_reg ^ p_reg;   // D = X xor P
    wire         v    = one_bit_change(diff);

    // ---------------- datapath registers ----------------
    wire start_pulse = start & ~start_d;         // rising edge of START
    wire load        = start_pulse & ~ack;       // ACK has priority

    always @(posedge clk) begin
        if (rst) begin
            x_reg   <= {N{1'b0}};
            p_reg   <= {N{1'b0}};
            start_d <= 1'b0;
            eval    <= 1'b0;
        end else begin
            start_d <= start;
            eval    <= load;                     // evaluate next cycle
            if (load) begin
                p_reg <= x_reg;                  // P <- old X
                x_reg <= data_in;                // X <- new switches
            end
        end
    end

    // ---------------- Moore FSM: state register ----------------
    always @(posedge clk) begin
        if (rst) state <= IDLE;
        else     state <= next_state;
    end

    // ---------------- Moore FSM: next-state logic ----------------
    always @(*) begin
        next_state = state;
        if (ack)
            next_state = IDLE;
        else if (eval)
            next_state = v ? VALID : INVALID;
    end

    // ---------------- Moore FSM: output logic (depends on state only) ----------------
    assign valid_led   = (state == VALID);
    assign invalid_led = (state == INVALID);
    assign idle_led    = ~(valid_led | invalid_led);

    assign state_out = state;
    assign curr_out  = x_reg;
    assign prev_out  = p_reg;
    assign v_out     = v;

endmodule
