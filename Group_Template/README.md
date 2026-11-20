# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | [Shlok Kesarkar] | [65/D9B] | [shlokkesarkar22-tech] |
| Member 2 | [Diksha Dineshchandra Mishra ] | [34/D9B] | [Diksham-16] |
| Member 3 | [lakshya kiran Sawardekar ] | [51/D9A] | [TheUltimate25] |
| Member 4 | [Parth Raut] | [46/D9A] | [parth-1312] |

**Class:** [D9A/D9B]  
**Group ID:** [D9A/B_Group23]  
**Repository URL:** [(https://github.com/shlokkesarkar22-tech/Digital_System_Design_Practical_2026_27_D9A_B)]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** [9H4/Password Attempt Monitor]
- **Problem summary:** [The Password Attempt Monitor is a digital system designed to monitor and classify password attempts using a 3-bit input. The system uses digital logic circuits and a Moore Finite State Machine (FSM) to categorize password attempts into three levels: No Warning, Warning, and Lockout.
The system accepts a 3-bit input representing the number of password attempts and processes it using a range decoder. Based on the input value, the FSM changes its state and activates the corresponding LED indicator.]
- **Objective:** [Design, simulate, and implement a 3-bit password attempt monitor that classifies attempt counts into three categories, controls indicator LEDs using a Moore FSM, and tracks total occurrences of each category using three independent 4-bit counters (H4)]
- **Inputs and outputs:** [A2 1 bit Most significant bit of the 3-bit input.
                           A1 1 bit Middle bit of the 3-bit input.
                           A0 1 bit Least significant bit of the 3-bit input.
                           START 1 bit Enables the category counter to increment.
                           ACK 1 bit Acknowledgement input reserved for future functionality; currently unused.
                           RESET 1 bit Clears all three category counters when activated.
                           CLK 1 bit Clock signal used to synchronize counter operations
                           NOWOUT 1 bit Indicates that the input belongs to the NOW category (000–001).
                           WARNOUT 1 bit Indicates that the input belongs to the WARN category (010–100).
                           LOCKOUT 1 bit Indicates that the input belongs to the LOCK category (101–111).
                           NOW_COUNT 4 bits Stores the total number of NOW category attempts.
                           WARN_COUNT 4 bits Stores the total number of WARN category attempts.
                           LOCK_COUNT 4 bits Stores the total number of LOCK category attempts.]
- **Constraints and assumptions:** [3-bit input: The system uses three input bits (A2, A1, A0), providing eight possible input combinations.
Category classification: Inputs are divided into three categories:
NOW: 000–001
WARN: 010–100
LOCK: 101–111
Counter width: Each category counter is 4 bits wide and can represent values from 0 to 15.
Clock operation: Counters operate on the rising edge of the clock signal.
Start condition: A counter increments only when START is HIGH and the corresponding category is active.
Reset condition: When RESET is activated, all three counters are cleared to zero.
Single attempt per clock: START should be activated for one clock cycle for each attempt to prevent unwanted multiple counting.
Acknowledgement: ACK is included as an input but is not used in the current implementation.
Counter overflow: Since the counters are 4 bits wide, they return to zero after reaching 15 and receiving another increment.
Category independence: Each category has its own counter, allowing the system to maintain separate attempt totals.]

## 3. Problem Analysis and Proposed Solution
Requirements:-
The Password Attempt Monitor is designed to classify 3-bit input combinations into three categories: NOW, WARN, and LOCK. It also maintains a separate counter for each category.
The main requirements are:
Accept a 3-bit input (A2, A1, A0).
Classify all eight possible input combinations into three categories.
Generate separate output signals for NOW, WARN, and LOCK.
Maintain three independent 4-bit counters.
Increment the corresponding counter when START is activated.
Use a common clock signal to synchronize counter operations.
Provide a RESET input to clear all counters.
Display the total number of attempts in each category.
2. Edge Case:-
The design considers the following edge cases:
Minimum input: Input 000 must be classified as NOW.
Category boundaries: Inputs 001, 010, and 101 must be assigned to their correct categories.
Maximum input: Input 111 must be classified as LOCK.
START is LOW: No counter should increment when START is LOW.
RESET activation: All counters must return to zero when RESET is activated.
Multiple attempts: Repeated attempts in the same category must increment only that category's counter.
Counter overflow: A 4-bit counter returns to zero after reaching 15 and receiving another increment.
Simultaneous category outputs: Only one category output should be HIGH for any valid 3-bit input.
3. Proposed Solution
The proposed solution uses combinational logic and sequential counter circuits.
First, three input bits (A2, A1, A0) are given to a category decoder. The decoder classifies the input into one of three categories:
NOW: 000–001
WARN: 010–100
LOCK: 101–111
Boolean logic gates generate the three category output signals.
Next, three AND gates combine the category outputs with the START signal. Their outputs enable the corresponding counters.
Three independent 4-bit counters are used to maintain the number of attempts in each category. All counters share the same clock and reset signals.
Finally, the counter values are available through three separate 4-bit outputs.
## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.
<img width="1536" height="1024" alt="Password Attempt Monitor Block Diagram" src="https://github.com/user-attachments/assets/9b8ae466-ce02-4351-8a97-65048b7381b8" />



## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** [Path/link]  
**State table:** [Path/link]

## 6. Logisim Implementation
- Logisim version: [V4.1.0]
- Circuit file: [[Path to `.circ`](https://drive.google.com/file/d/1WSg3NNwyJPyqjPxU57mcQFRjLxi01r3_/view?usp=drive_link)]
- Test cases and expected/observed behaviour: 
Input	Expected Behaviour	Observed Behaviour
000, 001	NOW counter increases	Working
010, 011, 100	WARN counter increases	Working
101, 110, 111	LOCK counter increases	Working
START = 0	No counter changes	Working
RESET = 1	All counters become 0	Working
Final Counter Values (after all 8 inputs):
NOW_COUNT = 2 WARN_COUNT = 3 LOCK_COUNT = 3
Result: The circuit works according to the expected classification and counting logic.]

- Issues and corrections: [
Incorrect category classification	Corrected the Boolean logic expressions.
Counters were not incrementing correctly	Checked START and clock connections.
All counters were not resetting	Connected RESET to all three counters.
Verilog simulation errors	Corrected module and testbench connections.
ACK input was not being used	Added acknowledgement logic using LOCKOUT and ACK.]
- Screenshot/evidence: [Path/link]

## 7. Verilog HDL Implementation
- Tool/version: [Xilinx Vivado]
- Top module and submodules: [password_monitor and password_monitor_tb]
- Architecture/coding decisions: [-bit input is used for category classification. Combinational logic identifies NOW, WARN and LOCK.
  Three independent 4-bit counters count each category.START enables counting. RESET clears all counters. All counters use a common clock.]
- Synthesizability considerations: [The main Verilog module uses synthesizable Verilog constructs. Counters use positive-edge clock triggering.
RESET is asynchronous and active-high. Testbench code is only for simulation and is not synthesizable.]
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | [Input = 000, START = 1 ] | [NOW_COUNT = 1 ] | [NOW_COUNT = 1 ] | [Pass] |
| T02 | [Input = 010, START = 1 ] | [ WARN_COUNT = 1] | [WARN_COUNT = 1 ] | [Pass ] |
| T03 | [	Input = 101, START = 1 ] | [LOCK_COUNT = 1 ] | [	LOCK_COUNT = 1 ] | [ Pass] |

Tool/version: [Xilinx Vivado]  
Number passed/failed: [Passed: 8
Failed: 0]  
Waveform/log path: [Path]

## 9. FPGA Hardware Implementation
- FPGA board/device: [Details]
- Tool/version: [Details]
- Clock/constraints: [Details]
- Synthesis/implementation summary: [Details]
- Programming and hardware test result: [Details]
- Evidence path: `04_FPGA_Hardware/`

Explain differences between simulation and hardware results, if any.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| [ ] | [ ] | [ ] | [ ] |

Future improvements: [Details]

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Group leader | [Logisim Design,Github updatetion] | [Completed Logisim Design/ Github Updated] |
| Member 2 | [Logisim Design] | [Logisim Completed] |
| Member 3 | [Verilog Code Implementation ] | [Verilog Implementation Completed ] |
| Member 4 | [Verilog Code Implementation ] | [ Verilog Implementation Completed] |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
Summarise requirements met, correctness of simulation/hardware results, measured results, limitations and conclusion.

[Write here]

## 14. Team Reflection
What did the team learn? What would you improve?

[Write here]

## 15. Final Submission Checklist
- [ ] Team details and problem analysis complete.
- [ ] Architecture/block diagram included.
- [ ] FSM diagram/table or justified alternative included.
- [ ] Logisim source and simulation evidence uploaded.
- [ ] Verilog RTL and testbench uploaded.
- [ ] Simulation results and test cases documented.
- [ ] FPGA implementation and hardware evidence uploaded.
- [ ] Results, challenges and conclusion documented.
- [ ] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.
