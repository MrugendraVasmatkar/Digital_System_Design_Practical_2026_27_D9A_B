# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Tanav Patil | 50 | code-voyager17 |
| Member 2 | Chinmay Keskar | [Roll no.] | keskarchinmay7-hub |
| Member 3 | Vedant Patil | 42 | vedantpatil1705 |
| Member 4 | Aditya Yadav | 61 | 2025adityadyadav-byte |

**Class:** D9A/D9B  
**Group ID:** D9B-Group08  
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 
- **Problem summary:** [In your own words]
- **Objective:** [What must the system achieve?]
- **Inputs and outputs:** [List signals, widths and meaning]
- **Constraints and assumptions:** [List and justify]

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
- Logisim version: Logisim-evolution v4.1.0
- Circuit file: https://drive.google.com/drive/u/4/folders/11ZAlYLtZIfZqkP7gjBKkoZjrsTbID2Iz (.circ file available in drive folder)
- Test cases and expected/observed behaviour: [Details]
- Issues and corrections: [Details]
- Screenshot/evidence: https://drive.google.com/drive/u/4/folders/11ZAlYLtZIfZqkP7gjBKkoZjrsTbID2Iz

## 7. Verilog HDL Implementation
- Tool/version: AMD Xilinx Vivado 2022.2
- Top module and submodules:  Top module :- module forbidden_zone_rejector_h4 (Design)
                                            module tb_forbidden_zone_rejector_h4 (Simulation)
                              Submodules :- module start_pulse_gen, module fz_detector_y, module h4_counters
                              
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
