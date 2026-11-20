`timescale 1ns/1ps

module tb_top_module;

// Inputs
reg A0, A1, A2;
reg clk, reset;

// Outputs
wire [2:0] Q;
wire [7:0] Y;
wire [2:0] state;

wire ACK;
wire GREEN_LED;
wire YELLOW_LED;
wire RED_LED;

// Instantiate Top Module
top_module DUT (
    .A0(A0),
    .A1(A1),
    .A2(A2),
    .clk(clk),
    .reset(reset),
    .Q(Q),
    .Y(Y),
    .state(state),
    .ACK(ACK),
    .GREEN_LED(GREEN_LED),
    .YELLOW_LED(YELLOW_LED),
    .RED_LED(RED_LED)
);


initial clk = 1'b0;
always #5 clk = ~clk;


initial begin

    // Initial values
    A0 = 0;
    A1 = 0;
    A2 = 0;
    reset = 1;

   
    #12;
    reset = 0;

   
    #10;
    {A0,A1,A2} = 3'b001;

    
    #10;
    {A0,A1,A2} = 3'b010;

    #10;
    {A0,A1,A2} = 3'b011;

    #10;
    {A0,A1,A2} = 3'b100;

    #10;
    {A0,A1,A2} = 3'b101;

    #10;
    {A0,A1,A2} = 3'b110;

    #10;
    {A0,A1,A2} = 3'b111;

    #10;
    {A0,A1,A2} = 3'b000;

    
end

endmodule
