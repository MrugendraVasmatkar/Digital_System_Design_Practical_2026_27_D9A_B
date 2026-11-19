# 01 – Problem Analysis
Upload the problem statement, requirements, assumptions, input/output definitions, constraints and proposed solution explanation here.

FIBONACCI NUMBER DETECTOR (4-BIT)

Hint 4 (ADD Counters):
Modify the design the design to count the number of Fibonacci and Non-Fibonacci inputs.
Use two counters Fib_Count and NonFib_Count ( N - Bit )
Increment the respective counter whenever the corresponding input is detected. 

PROBLEM STATEMENT
Design a 4-bit Fibonacci Number Detector circuit that outputs 1 (F = 1) only when the 4-bit unsigned binary input (0–15) is a Fibonacci number {0, 1, 2, 3, 5, 8, 13}, and 0 otherwise, controlled via a Moore FSM and verified in Logisim and Verilog.

REQUIREMENTS
- Accept a 4-bit input X[3:0] representing unsigned integers from 0 to 15.
- Detect Fibonacci numbers in the 0–15 range: {0, 1, 2, 3, 5, 8, 13}.
- Implement a Moore FSM with states IDLE (00), FIB (01), and NON-FIB (10) with synchronous, active-high RESET and START/ACK control signals.
- Drive indicator outputs: FIB LED (F = 1, Green) and NON-FIB LED (F = 0, Red), with all LEDs off in IDLE.
- Simulate in Logisim across all 16 input combinations and verify via a self-checking Verilog testbench with pass/fail messages.

ASSUMPTIONS
- Input X[3:0] is treated as an unsigned 4-bit binary number (0 to 15).
- Control signals (RESET, START, ACK) are synchronous and active-high.
- In a Moore machine, outputs depend strictly on the current FSM state rather than directly on the input.
- A single optional modification hint (H1–H5) may be applied if extending the base specification.

INPUT / OUTPUT DEFINITIONS
Inputs:
- X[3:0] (4-bit): Unsigned binary number input (0–15).
- START (1-bit): Loads/samples X[3:0] and triggers evaluation from IDLE.
- ACK (1-bit): Acknowledges result and returns FSM to IDLE.
- RESET (1-bit): Synchronous active-high reset returning FSM to IDLE.

Outputs:
- F (1-bit): Fibonacci indicator (1 if X is Fibonacci in FIB state, else 0).
- FIB LED (1-bit): Active when in FIB state (F = 1).
- NON-FIB LED (1-bit): Active when in NON-FIB state (F = 0).

CONSTRAINTS
- Input range is restricted to 4-bit values (0–15) in the base design.
- State encoding uses 2-bit Moore states: IDLE = 00 (F=0), FIB = 01 (F=1), NON-FIB = 10 (F=0).
- Verification must cover all 16 input values, all FSM states, reset, and START/ACK sequences using a self-checking Verilog testbench.

PROPOSED SOLUTION EXPLANATION
The system splits into a datapath and a Moore FSM controller. A 4-bit input register captures X[3:0] on START, and a combinational Fibonacci comparator checks whether X belongs to {0, 1, 2, 3, 5, 8, 13}, asserting internal signal F. The Moore FSM transitions from IDLE (00) upon START to FIB (01) if F = 1 or NON-FIB (10) if F = 0, returning to IDLE on ACK or RESET, while state-decoded output logic drives the FIB and NON-FIB LEDs.


