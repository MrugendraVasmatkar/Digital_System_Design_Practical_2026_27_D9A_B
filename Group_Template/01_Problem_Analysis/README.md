# 01 – Problem Analysis
Upload the problem statement, requirements, assumptions, input/output definitions, constraints and proposed solution explanation here.

FIBONACCI NUMBER DETECTOR (4-BIT)

Hint 4 (ADD Counters):
Modify the design the design to count the number of Fibonacci and Non-Fibonacci inputs.
Use two counters Fib_Count and NonFib_Count ( N - Bit )
Increment the respective counter whenever the corresponding input is detected. 

The objective is to design, implement, and verify a 4-Bit Fibonacci Number Detector digital system that outputs 1 (F = 1) only when a 4-bit binary input represents a Fibonacci number within the range 0 to 15 (namely {0, 1, 2, 3, 5, 8, 13}), and 0 (F = 0) otherwise. The system integrates a combinational datapath with a Moore Finite State Machine (FSM) controller, indicator LEDs, Logisim simulation, and Verilog testbench verification.  

Requirements

Functional Requirements

Fibonacci Detection Logic: Evaluate a 4-bit unsigned input X (0 to 15) and assert F = 1 if X in {0, 1, 2, 3, 5, 8, 13}, and F = 0 for all other values (4, 6, 7, 9, 10, 11, 12, 14, 15).

Input Sampling & Control: Support control signals START (to load/sample X), ACK (to return from active result states back to IDLE), and RESET.   Moore FSM Operation: Transition across three states—IDLE (00), FIB (01), and NON-FIB (10)—based on control inputs and the detector output F.   Indicator Outputs: Drive FIB LED (F = 1, Green LED ON) for Fibonacci inputs and NON-FIB LED (F = 0, Red LED ON) for non-Fibonacci inputs, with all LEDs off in IDLE.


