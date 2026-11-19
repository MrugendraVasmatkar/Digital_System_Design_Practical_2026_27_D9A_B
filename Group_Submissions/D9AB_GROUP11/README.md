# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Hardik Patil | 49 | hardikpatil0317-star |
| Member 2 | Kanishka Puthran | 45 | puthrankanishka2323-ai |
| Member 3 | Aran Mishra | 35 | 2025aranmishra-code |
| Member 4 | Harikesh Menon | 33 | 2025harikeshmenon-collab |

**Class:** [D9A/D9B]  
**Group ID:** D9AB_GROUP11  
**Repository URL:** https://github.com/hardikpatil0317-star/DSD-2026-D9AB-GROUP11.git
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** Game Score Categorizer – H3: Add Error State for Invalid Input.
- **Problem summary:** The Game Score Categorizer is a digital system designed to classify an input game score into different categories based on predefined score ranges. The system uses a Moore Finite State Machine (FSM) to identify whether the score belongs to the Low, Medium, High or Error category. An additional Error state is incorporated to detect invalid inputs exceeding the maximum valid score of 15.
- **Objective:** To design and implement a digital system that accepts a binary score, classifies it into the appropriate category and displays the corresponding output using LEDs. The system must also detect invalid scores and activate an Error LED. It should return to the IDLE state upon receiving RESET or ACK.
- **Inputs and outputs:** Inputs:
S[4:0] – 5-bit binary score input.
START – Initiates the score classification process.
ACK – Acknowledges the result and returns the system to IDLE.
RESET – Resets the FSM to its initial IDLE state.
Outputs:
LOW – Indicates a score between 0 and 4.
MEDIUM – Indicates a score between 5 and 10.
HIGH – Indicates a score between 11 and 15.
ERROR – Indicates an invalid score greater than 15.
LED indicators display the corresponding category.
- **Constraints and assumptions:** The score is represented using a 5-bit binary input.
Valid scores range from 0 to 15.
Scores greater than 15 are treated as invalid inputs.
The system uses a Moore FSM for sequential control.
Classification is initiated using the START signal.
ACK returns the system to IDLE after displaying the result.
RESET asynchronously returns the system to the initial IDLE state.
Only one category output is active at a time.

## 3. Problem Analysis and Proposed Solution

The Game Score Categorizer is designed to classify numerical game scores into predefined categories using digital logic and a Moore Finite State Machine (FSM).
The system accepts a binary score as input and uses a range decoder to determine the corresponding category. The classification is divided into four categories:
- **Low:** Scores from 0 to 4.
- **Medium:** Scores from 5 to 10.
- **High:** Scores from 11 to 15.
- **Error:** Scores greater than 15, which are considered invalid.
The proposed design consists of an input register, range decoder, Moore FSM controller and output logic. When the START signal is activated, the input score is processed and classified. The FSM transitions to the appropriate category state, activating the corresponding LED indicator. The system remains in the detected category state until an ACK signal is received, returning it to the IDLE state. RESET can also be used to return the system to its initial state.
**Edge Cases:**
- A score of 0 must be correctly classified as LOW.
- Scores at the category boundaries (4, 5, 10 and 11) must be classified correctly.
- A score of 15 must be classified as HIGH.
- Scores greater than 15 must activate the ERROR state and Error LED.
- RESET must return the system to IDLE.
- ACK must clear the current category indication and return the system to IDLE.
**Proposed Solution:**
A Moore FSM is implemented with five states: IDLE, LOW, MEDIUM, HIGH and ERROR. The input score is evaluated using combinational range-decoding logic, and the FSM controls the corresponding output indicators. Since the outputs depend only on the current state, the design provides predictable sequential behaviour.
**Distinctive Features:**
- Four-category score classification.
- Additional ERROR state for invalid score detection.
- Moore FSM-based sequential control.
- LED-based visual indication of the detected category.
- START, ACK and RESET controls for managing system operation.
**Feasibility:**
The design is feasible using basic digital components such as registers, comparators, combinational logic gates and flip-flops. It can be implemented and tested in Logisim and described using Verilog HDL. The modular architecture also makes the system suitable for FPGA implementation and further enhancements.

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
