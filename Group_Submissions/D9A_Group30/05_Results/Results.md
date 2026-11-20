--[Test cases]--

XP (Dec) | XP[3:0] | Control Signals (rst, start, ack) | Expected Level & LEDs (green, yellow, red / exp_led[2:0]) | Observed Output | Status

XXXX | Any value | All OFF (All 0) | All LEDs OFF | green=0, yellow=0, red=0 |PASS
 
0 | 0000 / 0 | 0, 1, 1 | BEGINNER(green) | Green ON | green=1 | PASS

1 | 0001 / 1 | 0, 1, 1 | BEGINNER(green) | Green ON | green=1 | PASS

2 | 0010 / 2 | 0, 1, 1 | BEGINNER(green) | Green ON | green=1 | PASS

3 | 0011 / 3 | 0, 1, 1 | BEGINNER(green) | Green ON | green=1 | PASS

4 | 0100 / 4 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

5 | 0101 / 5 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

6 | 0110 / 6 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

7 | 0111 / 7 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

8 | 1000 / 8 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

9 | 1001 / 9 | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

10 | 1010 /a | 0, 1, 1 | INTERMEDIATE(yellow) | Yellow ON | yellow = 1 | PASS

11 | 1011 / b | 0, 1, 1 | EXPERT(red) | red ON | red =1 | PASS

12 | 1100 / c | 0, 1, 1 | EXPERT(red) | red ON | red =1 | PASS

13 | 1100 / d | 0, 1, 1 | EXPERT(red) | red ON | red =1 | PASS

14 | 1110 / e | 0, 1, 1 | EXPERT(red) | red ON | red =1 | PASS

15 | 1111 / f | 0, 1, 1 | EXPERT(red) | red ON | red =1 | PASS


-- [Control signal working] --

1. The whole circuit doesn't start until start = 1. 
2. The "rst" is the reset button which resets the FSM.
3. The "ack" is the acknowledgement button. The FSM won't give output until "start" and "ack" are 1.

-- [Correctness and Accuracy] -- 
1. All 16 input combinations (0000 to 1111) and control transitions (rst, start, ack) produced exact matches between expected specifications and observed simulation outputs across both Logisim and Verilog HDL.

2.  The self-checking Verilog testbench iterated through all 16 XP values (i = 0 to 15), confirming errors[31:0] = 00000000 throughout the entire simulation run (0 ns to 480 ns).

3. Boolean & Mealy Architecture Verification: 
Range decoder equations accurately partition the 4-bit input space:
    Beginner (0 <= XP <= 3): NOT(X3) AND NOT(X2)
    Expert (11 <= XP <= 15): X3 AND (X2 OR X1) = (X3 AND X2) OR (X3 AND X1)
    Intermediate (4 <= XP <= 10): NOT(Beginner) AND NOT(Expert)

Implementing the H2 Mealy FSM modification reduced state storage to a single active-status flip-flop (Q), gating the combinational range outputs with Q (Output = Range_Match AND Q) so outputs respond immediately to XP[3:0] changes while active and drop immediately to 0 upon rst or ack.

-- [Limitations] --
1. Fixed 4-Bit Input Width: The decoder supports integer XP values strictly within 0 to 15 (4-bit unsigned). Values exceeding 15 wrap around due to 4-bit truncation rather than triggering an overflow or error flag.

2. No Persistent Score History or Occurrence Tracking: The current implementation classifies real-time XP levels without storing prior levels.

-- [Conclusion] --

The 4-bit Gaming XP Level Decoder with the Mealy FSM modification was successfully designed, simulated, and verified in both Logisim and Verilog HDL. Testing across all 16 input combinations (0–15) and control sequences (rst, start, ack) achieved 100% accuracy with zero errors, confirming reliable real-time tier classification (Beginner, Intermediate, and Expert) and immediate output responsiveness.





