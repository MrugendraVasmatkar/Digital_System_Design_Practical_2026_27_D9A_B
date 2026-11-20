`timescale 1ns / 1ps
//==============================================================================
// Gaming XP Level Decoder (H3) - Moore FSM
// Direct translation of Gaming_XP_Decoder_H3_simple.circ (Logisim)
//
//   XP range   Level          State  Code
//   0  - 3     BEGINNER       BEG    001
//   4  - 10    INTERMEDIATE   INT    010
//   11 - 15    EXPERT         EXP    011
//   16 - 31    ERROR          ERR    100
//   (idle)     none           IDLE   000   (101-111 unused -> go to IDLE)
//
// Operation:
//   * In IDLE the 5-bit XP is sampled into XP_REG every clock.
//   * START (while IDLE) loads the state that matches the registered XP.
//   * The state is held until ACK, then returns to IDLE.
//   * RESET (synchronous, active high) forces IDLE and has top priority.
//
// NOTE: because XP_REG is a register, the level is decided from the XP value
//       sampled on the PREVIOUS clock edge. Keep XP stable for one clock
//       before raising START (same behaviour as the Logisim circuit).
//==============================================================================
module gaming_xp_decoder (
    input  wire       clk,
    input  wire       reset,             // synchronous, active-high
    input  wire       start,
    input  wire       ack,
    input  wire [4:0] xp,
    output wire       led_beginner,      // S_BEG
    output wire       led_intermediate,  // S_INT
    output wire       led_expert,        // S_EXP
    output wire       led_error          // S_ERR
);

    // ---------------- State encoding (block E) ----------------
    localparam [2:0] ST_IDLE = 3'b000,
                     ST_BEG  = 3'b001,
                     ST_INT  = 3'b010,
                     ST_EXP  = 3'b011,
                     ST_ERR  = 3'b100;

    reg  [2:0] state  = ST_IDLE;   // E) STATE register (power-up value = 000)
    reg  [4:0] xp_reg = 5'd0;      // B) XP_REG        (power-up value = 0)

    //--------------------------------------------------------------------------
    // F) State decoder (3-to-8 decoder; outputs 5..7 are unused)
    //--------------------------------------------------------------------------
    wire s_idle = (state == ST_IDLE);
    wire s_beg  = (state == ST_BEG);
    wire s_int  = (state == ST_INT);
    wire s_exp  = (state == ST_EXP);
    wire s_err  = (state == ST_ERR);

    // Moore outputs: depend only on the current state
    assign led_beginner     = s_beg;
    assign led_intermediate = s_int;
    assign led_expert       = s_exp;
    assign led_error        = s_err;

    //--------------------------------------------------------------------------
    // B) Input register: loads XP only while in IDLE (enable = S_IDLE)
    //--------------------------------------------------------------------------
    always @(posedge clk) begin
        if (s_idle)
            xp_reg <= xp;
    end

    //--------------------------------------------------------------------------
    // C) Range decoder: three unsigned comparators + gates
    //--------------------------------------------------------------------------
    wire beg  = (xp_reg <  5'd4);     // 0..3
    wire gt10 = (xp_reg >  5'd10);    // 11..31
    wire err  = (xp_reg >  5'd15);    // 16..31

    wire lvl_beg = beg;
    wire lvl_int = ~(beg | gt10);     // 4..10   (NOR)
    wire lvl_exp = gt10 & ~err;       // 11..15
    wire lvl_err = err;               // 16..31

    // CODE = new state for the level (splitter: bit0, bit1, bit2)
    wire [2:0] code = { lvl_err,                 // bit2
                        lvl_int | lvl_exp,       // bit1
                        lvl_beg | lvl_exp };     // bit0

    //--------------------------------------------------------------------------
    // D) Next-state logic: keep / load new level / reset (3 multiplexers)
    //--------------------------------------------------------------------------
    wire active = s_beg | s_int | s_exp | s_err;  // any "level" state
    wire keep   = active & ~ack;                  // stay until ACK
    wire go     = s_idle & start;                 // leave IDLE

    wire [2:0] mux_keep  = keep  ? state : 3'b000;      // KEEP : stay, else 000
    wire [2:0] mux_go    = go    ? code  : mux_keep;    // GO   : load CODE
    wire [2:0] next_state = reset ? 3'b000 : mux_go;    // RESET: 000

    //--------------------------------------------------------------------------
    // E) State register (rising edge, always enabled)
    //--------------------------------------------------------------------------
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule