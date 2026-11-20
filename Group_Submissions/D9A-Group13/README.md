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

[Write here]

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

![Block diagram](path/to/block_diagram.png)

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** [Path/link]  
**State table:** Group_Submissions/D9A-Group13/02_FSM_Logisim/State Table.png

## 6. Logisim Implementation
- Logisim version: logisim-win-2.7.1
- Circuit file: [Path to `.circ`]
- Test cases and expected/observed behaviour: [Details]
- Issues and corrections: [Details]
- Screenshot/evidence: [Path/link]

## 7. Verilog HDL Implementation
- Tool/version: [Details]
- Top module and submodules: [Names]
- Architecture/coding decisions: [Details]
- Synthesizability considerations: [Details]
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
