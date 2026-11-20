# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | SHEKHAR EPILI|  12 | Tarnished008 |
| Member 2 |SRUSHTI fHANSE | 13 | SRFhanse |
| Member 3 | TANVI KAGINKAR | 21 | tanvikaginkar |
| Member 4 | LAQSH KOUL| 27 | 2025koullaqsh |

**Class:** D9A/D9B 
**Group ID:** [e.g. D9A_Group01]  
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 1H4 – Add Category Counters to Water Temperature Classifier
- **Problem summary:** The Water Temperature Classifier is a 3-bit digital system that classifies temperature inputs into three categories: Cold (0–2), Neutral (3–5) and Hot (6–7) using a Moore Finite State Machine (FSM).The existing system controls three corresponding valve outputs based on the detected temperature category. However, it does not maintain a record of how many times each category is detected.
The H4 modification adds three independent 4-bit counters: Cold_Count, Neutral_Count, and Hot_Count. Each counter increments on every active clock edge while the FSM remains in its corresponding category state. This modification allows the system to maintain and display the total count for each temperature category.
- **Objective:** The system must:
1. Accept a 3-bit binary temperature input.
2. Classify the temperature into Cold, Neutral, or Hot categories.
3. Control the corresponding valve output using a Moore FSM.
4. Maintain three independent 4-bit counters for Cold, Neutral and Hot categories.
5. Increment the respective counter on every rising clock edge while the FSM is in the corresponding category state.
6. Keep the other two counters unchanged when a particular category is active.
7. Reset all three counters to zero when RESET is activated.
8. Display the current count values of all three counters.
- **Inputs and outputs:**
- Inputs
| Signals | Width | Meaning |
|---|---|---|
| T2,T1,T0 | 1 bit each | Temperature input |
| START | 1 bit | Starts classification |
| ACK | 1 bit | Acknowledgement |
| CLK | 1 bit | Clock Signal |
| RESET | 1 bit | Synchronous active-high reset |
- Outputs
| Signals | Width | Meaning |
|---|---|---|
| Cold_Valve | 1 bit | Cold valve control |
| Neutral_Valve | 1 bit | Neutral valve control |
| Hot_Valve | 1 bit | Hot valve control |
| Cold_Count | 4 bits | Cold Counter |
| Neutral_Count | 4 bits | Neutral Counter |
| Hot_Count | 4 bits | Hot Counter |
- **Constraints and assumptions:**
1. Temperature Input Range: The temperature input is a 3-bit binary value, so only values from 0 to 7 are considered valid.
2. Temperature Classification: The input is classified into three fixed ranges:
COLD: 0–2
NEUTRAL: 3–5
HOT: 6–7
3. FSM Model: The original system uses a Moore FSM with four states: IDLE (00), COLD (01), NEUTRAL (10), and HOT (11).
4. Clock Operation: All counters operate using the same rising-edge clock signal.
5. Counter Width: Each counter is 4 bits wide and can represent values from 0 to 15.
6. Independent Counting: Each counter increments only when its corresponding FSM category state is active. The other counters retain their previous values.
7. Reset Operation: RESET is synchronous and active-high. When activated, the FSM and all three counters return to their initial states or values as applicable.
8. Acknowledgement: ACK is used to return the FSM from a category state to IDLE.
9. Counter Overflow: Since each counter is 4 bits wide, it wraps around to zero after reaching 15 and receiving another increment, assuming standard binary counter operation.
10. Simulation Environment: The design is implemented and verified using Logisim Evolution with different temperature inputs and control signals applied to check the FSM operation and counter outputs.

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
# Group Submissions

Each group adds its own folder here, copied from `Group_Template/`. Example: `D9A_Group01/`. Submit only your own group's folder in the final Pull Request.
