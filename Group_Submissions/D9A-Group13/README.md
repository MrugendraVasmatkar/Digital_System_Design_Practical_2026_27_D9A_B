# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Mehul Gautum | 14 | mehulgautum47579-maker |
| Member 2 | Shaila Ranjan | 56 | shailaranjan |
| Member 3 | Jiya Patekar | 67 | jiyapatekar221-maker |
| Member 4 | Ishwari Sonar | 65 | 33ishwarisonar-maker |

**Class:** [D9A]  
**Group ID:** [e.g. D9A_Group13]  
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** GRAY CODE TRANSITION DETECTOR
- **Problem summary:**Through this project, we learned how a Mealy FSM trades output glitch immunity for zero-cycle response speed and a 50% reduction in flip-flop hardware when detecting single-bit Gray code transitions
- **Objective:** Design a sequential circuit that verifies whether consecutive 4-bit inputs follow valid Gray code transitions (where only 1 bit changes at a time).
- **Inputs and outputs:**The 4-Bit Gray Code Transition Detector (Mealy FSM) uses five inputs: a 4-bit data input (X[3:0]) from switches to enter the current code, START (1-bit) to latch the initial reference value and begin monitoring, ACK (1-bit) to stop comparison and return to idle, RESET (1-bit) to clear all registers back to zero, and CLK (1-bit) to synchronize state updates on the rising edge. It produces two immediate indicator outputs: VALID (Green LED), which turns ON (V = 1) as soon as X differs from the previous input P by exactly one bit, and INVALID (Red LED), which turns ON (V = 0) when zero or multiple bits change while the system is active
- **Constraints and assumptions:** The design is constrained to a fixed 4-bit input width (X[3:0]) using positive rising-edge-triggered D flip-flops (5 flip-flops total) and purely combinational logic (XOR, AND, OR) for zero-cycle Mealy output generation. It assumes that all 4 bits of a new input X settle simultaneously before the next rising clock edge (ignoring mechanical switch bounce), that START and ACK are mutually exclusive control pulses, and that valid Gray code transitions require strictly a single-bit change (Hamming distance = 1), treating zero-bit changes (X == P) or multi-bit changes as invalid.

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

In digital systems like rotary encoders and asynchronous data buses, consecutive 4-bit values must follow Gray code rules—changing only one bit at a time—to avoid switching glitches and false readings. The baseline Moore FSM design detects single-bit changes using D = X ^ P, but because Moore outputs depend solely on the current state, it requires three states (IDLE, VALID, INVALID), uses 10 D flip-flops, and introduces a one-clock-cycle delay before signaling an error.

solution is eliminated this delay and reduce hardware overhead, I redesigned the controller as a 2-state Mealy FSM (IDLE and ACTIVE) that routes the combinational One-Bit Change Detector (V_comb) directly into the output LED logic. By removing the separate VALID/INVALID states and the input synchronization register, the circuit cuts sequential memory by 50% (down to 5 D flip-flops) and turns ON the Green (VALID) or Red (INVALID) LED immediately as soon as X[3:0] changes, while keeping both indicators OFF when idle.

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

Group_Submissions/D9A-Group13/02_FSM_Logisim/block_diagram.png

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** Group_Submissions/D9A-Group13/02_FSM_Logisim/block_diagram.png
**State table:** Group_Submissions/D9A-Group13/02_FSM_Logisim/State Table.png

## 6. Logisim Implementation
- Logisim version: logisim-win-2.7.1
- Circuit file: Group_Submissions/D9A-Group13/02_FSM_Logisim/GRAY_CODE_TRANSITION_DETECTOR.circ
- Test cases and expected/observed behaviour: To verify the Mealy Gray Code Transition Detector, I tested it in Logisim using the full sequence 0000 -> 0001 -> 0011 -> 0111 -> 0101 -> 1101 -> 1100 -> 1111 along with RESET, START, and ACK controls. After resetting the circuit and pulsing START with 0000, every valid 1-bit Gray code step (0000 to 0001, 0001 to 0011, up to 1100) turned the Green LED ON immediately as soon as the input switch changed, without waiting for a clock pulse. When two bits were changed together (1100 to 1111) or no bits changed (1111 to 1111), the Red LED turned ON immediately to flag an invalid transition, and asserting ACK cleanly returned the circuit to IDLE with both LEDs turned OFF.
- Issues and corrections: While building and testing the circuit in Logisim, I faced a few small issues and fixed them step by step. First, when I changed two input switches one by one, the Mealy LEDs flickered briefly because the output reacts immediately; I solved this by making sure both switches settle cleanly before the rising clock edge. Second, the Red LED stayed ON even before pressing START because the XOR detector was always running, so I connected the state flip-flop output (ACTIVE) to the LED gates so both LEDs stay OFF during IDLE. Lastly, I got red and orange wire errors when connecting the 4-bit input X to single-bit gates, which I fixed by setting Register P and the XOR gate to 4 bits and adding a 4-bit splitter before the AND/OR gates.
- Screenshot/evidence: Group_Submissions/D9A-Group13/02_FSM_Logisim/logism.pdf

## 7. Verilog HDL Implementation
- Tool/version: Vivado 2018.3
- Top module and submodules: RTL TB Simulation
- Architecture/coding decisions: For the Verilog and Logisim design, I kept the architecture simple by splitting the sequential clock registers from the combinational Mealy output logic so the LEDs respond immediately without latches. I encoded only two states (IDLE = 0 and ACTIVE = 1) using one flip-flop to cut the total flip-flop count in half, and wrote the 1-bit change detector with basic assign statements (XOR, AND, OR) so the code directly matches my Logisim gate schematic.
- Synthesizability considerations: To make sure the Verilog code can be synthesized cleanly onto real hardware like an FPGA, I avoided non-synthesizable delays (#) in the main module and separated the clocked registers from the combinational logic using standard always @(posedge clk) and always @(*) blocks. I also assigned default values (next_state = state; and V = 1'b0;) at the top of the combinational block and covered all case branches so the synthesis tool does not infer unwanted latches. Finally, I built the 1-bit change detector using basic bitwise XOR, AND, and OR operators instead of loops or division, ensuring it maps directly to standard logic gates with minimal hardware delay.
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | [ ] | [ ] | [ ] | [ ] |
| T02 | [ ] | [ ] | [ ] | [ ] |
| T03 | [ ] | [ ] | [ ] | [ ] |

Tool/version: [Details]  
Number passed/failed: [Details]  
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
| Group leader | [ ] | [ ] |
| Member 2 | [ ] | [ ] |
| Member 3 | [ ] | [ ] |
| Member 4 | [ ] | [ ] |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
Summarise requirements met, correctness of simulation/hardware results, measured results, limitations and conclusion.

The 4-Bit Gray Code Transition Detector was successfully redesigned and verified in both Logisim and Verilog using a 2-state Mealy FSM (IDLE and ACTIVE), achieving immediate, zero-cycle output detection whenever consecutive 4-bit inputs differ by exactly one bit (V = 1, Green LED ON) and flagging 0-bit or multi-bit changes (V = 0, Red LED ON). Compared to the original 3-state Moore implementation, the Mealy modification reduced the sequential hardware from 10 D flip-flops down to 5 D flip-flops (a 50% memory reduction) and eliminated the one-clock-cycle output latency, demonstrating a faster, more area-efficient hardware architecture for real-time Gray code error detection in rotary encoders and digital communication buses.

## 14. Team Reflection
What did the team learn? What would you improve?

To eliminate this delay and reduce hardware overhead, I redesigned the controller as a 2-state Mealy FSM (IDLE and ACTIVE) that routes the combinational One-Bit Change Detector (V_comb) directly into the output LED logic. By removing the separate VALID and INVALID states along with the extra 4-bit input synchronization register, the circuit cuts sequential memory by 50% (from 10 D flip-flops down to 5). As a result, the Green (VALID) or Red (INVALID) LED responds immediately as soon as the 4-bit input X[3:0] changes, while both indicators stay safely turned OFF whenever the system is in the IDLE state.

## 15. Final Submission Checklist
- [complete] Team details and problem analysis complete.
- [complete ] Architecture/block diagram included.
- [complete ] FSM diagram/table or justified alternative included.
- [complete ] Logisim source and simulation evidence uploaded.
- [complete ] Verilog RTL and testbench uploaded.
- [complete] Simulation results and test cases documented.
- [ ] FPGA implementation and hardware evidence uploaded.
- [ ] Results, challenges and conclusion documented.
- [complete ] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [ ] Final Pull Request created and URL recorded.
