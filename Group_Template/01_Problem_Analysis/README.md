# 01 – Problem Analysis

Upload the problem statement, requirements, assumptions, input/output definitions, constraints and proposed solution explanation here.
1. Problem Statement
The Password Attempt Monitor is a digital system designed to classify password attempt values into three categories: NOW, WARN, and LOCK. It accepts a 3-bit binary input and identifies the corresponding category using combinational logic gates.
The system maintains three independent counters to record the number of attempts in each category. This helps monitor and display the distribution of attempts through digital outputs.

2.Requirements:-The project requires the following components:
Three input switches (A2, A1, A0) to provide 3-bit binary input.
One START input to enable counting.
One RESET input to clear all counters.
One CLK input to synchronize counter operations.
Combinational logic gates for category classification.
Three independent 4-bit counters.
Output indicators for NOW, WARN, and LOCK.
Verilog HDL for hardware description.
Vivado software for simulation and verification.
Logisim Evolution for circuit implementation
3. Assumptions
The system accepts a 3-bit binary input.
Each input combination belongs to exactly one category.
NOW represents input values from 0 to 1.
WARN represents input values from 2 to 4.
LOCK represents input values from 5 to 7.
Only one category is active for a given input.
A counter increments when START is enabled and the corresponding category is selected.
All three counters share a common clock and reset.
RESET clears all three counters.
Each START pulse is intended to count one attempt.






