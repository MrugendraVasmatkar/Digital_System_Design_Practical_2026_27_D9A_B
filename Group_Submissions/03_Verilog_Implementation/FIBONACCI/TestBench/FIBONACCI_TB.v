`timescale 1ns / 1ps



module FIBONACCI_TB ;

 
    reg clk;
    reg reset;
    reg start;
    reg ack;
    reg [3:0] X;


    wire F;
    wire FIB;
    wire NON_FIB;

    
    FIBONACCI DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .ack(ack),
        .X(X),
        .F(F),
        .FIB(FIB),
        .NON_FIB(NON_FIB)
    );

    
    always #5 clk = ~clk;

    
    initial begin

       
        clk = 0;
        reset = 1;
        start = 0;
        ack = 0;
        X = 4'b0000;

       
        #10;
        reset = 0;

       
        X = 4'b0000;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0001;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0010;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0011;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0100;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0101;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0110;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b0111;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1000;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1001;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1010;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1011;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1100;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1101;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1110;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

       
        X = 4'b1111;
        start = 1;
        #10;
        start = 0;
        ack = 1;
        #10;
        ack = 0;

        #10;
        $finish;

    end

endmodule

