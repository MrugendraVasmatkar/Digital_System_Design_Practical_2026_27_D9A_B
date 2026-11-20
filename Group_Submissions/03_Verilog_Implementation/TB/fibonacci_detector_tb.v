`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.11.2026 14:51:15
// Design Name: 
// Module Name: fibonacci_detector_tb
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

module fibonacci_detector_tb;

reg clk, reset, start, ack, input_valid;
reg [3:0] x;
integer i;                      // <-- added

wire fib_led, nonfib_led, error_led;

fibonacci_detector uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .ack(ack),
    .input_valid(input_valid),
    .x(x),
    .fib_led(fib_led),
    .nonfib_led(nonfib_led),
    .error_led(error_led)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    // Initial values
    reset = 1;
    start = 0;
    ack = 0;
    input_valid = 0;
    x = 0;

    #10 reset = 0;

    // Test invalid input
    #10 start = 1;
    #10 start = 0;

    #10 ack = 1;
    #10 ack = 0;

    // Test all 16 input combinations
    input_valid = 1;

    for(i = 0; i < 16; i = i + 1) begin     // <-- changed
        x = i;                              // <-- added

        #10 start = 1;
        #10 start = 0;

        #10 ack = 1;
        #10 ack = 0;

    end

    // Test RESET
    #10 reset = 1;
    #10 reset = 0;

    #20 $finish;

end

endmodule