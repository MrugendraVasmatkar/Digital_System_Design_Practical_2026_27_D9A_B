

module top_module (

    input A0, A1, A2,
    input clk,
    input reset,

    output [2:0] Q,
    output [7:0] Y,
    output [2:0] state,

    output ACK,
    output GREEN_LED,
    output YELLOW_LED,
    output RED_LED

);


input_register REG1 (
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .clk(clk),
    .reset(reset),
    .Q(Q)
);

decoder_3to8 DEC1 (
    .Q(Q),
    .Y(Y)
);

mealy_fsm FSM1 (
    .clk(clk),
    .reset(reset),
    .Y(Y),
    .state(state),
    .ACK(ACK),
    .GREEN_LED(GREEN_LED),
    .YELLOW_LED(YELLOW_LED),
    .RED_LED(RED_LED)
);

endmodule

