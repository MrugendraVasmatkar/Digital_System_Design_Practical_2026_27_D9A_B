# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Ankita karmakar | 22 | ankyaaa18 |
| Member 2 | Chaitanya Jadhav | 19 | chaitanyarj49-ux |
| Member 3 | Manas Narkar | 41 | 2025Man-nar |
| Member 4 | Vidyesh Raut | 47 | 2025vidyeshraut-lang |

**Class:** [D9A/D9B]  
**Group ID:** D9_Group03 
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 6H1 / Forbidden Zone Rejector
- **Problem summary:** The Forbidden Zone Rejector is a digital system designed to identify and reject input values falling within a predefined forbidden range. The system accepts a n-bit binary input (parameterizable) and checks whether its decimal equivalent lies within the forbidden zone which is configurable [L,H].
- **Objective:**
  1. To accept binary input values and detect whether they fall within a specified forbidden range.
  2. To generate an ACCEPT output for values outside the forbidden zone.
  3. To generate a REJECT output for values within the forbidden zone.
  4. To extend the design to support parameterizable input widths and configurable forbidden-zone limits.
  5. To verify the functionality of the circuit through simulation and testbench verification.
- **Inputs and outputs:**
  | Inputs/Output Signal | Width | Description | 
  |---|---|---|
  | X | n | Binary input value to be checked | 
  | L | n | Lower limit of the forbidden zone | 
  | H | n | Higher limit of the forbidden zone. |
  | Y | 1 | Result whether Rejected or accepted |
  
- **Constraints and assumptions:**
  1. The initial implementation uses a 4-bit unsigned binary input, allowing decimal values from 0 to 15.
  2. The default forbidden zone is from 6 to 9, including both boundary values.
  3. The input is considered forbidden when L ≤ X ≤ H.
  4. Values outside the forbidden range are considered acceptable.
  5. The configurable limits must satisfy 0 ≤ L ≤ H ≤ 2^N − 1.

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

[Write here]

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

![Block diagram](path/to/block_diagram.png)

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

**Diagram:** [Path/link]  
**State table:** [Path/link]

## 6. Logisim Implementation
- Logisim version: [Version]
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
