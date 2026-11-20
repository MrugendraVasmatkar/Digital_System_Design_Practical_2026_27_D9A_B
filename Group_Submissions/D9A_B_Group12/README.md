# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | [Abhishek Potekar] | [Roll no.53 D9B] | [2025abhishekpotekar-sudo] |
| Member 2 | [Malishka Naik] | [Roll no.38 D9B] | [2025malishanaik-alt] |
| Member 3 | [Bhupesh Patil] | [Roll no.40 D9A] | [Bhupesh-tech143] |
| Member 4 | [Vedant Soni] | [Roll no.54 D9A] | [vedantpsoni-glitch] |

**Class:** [D9A/D9B]  
**Group ID:** Group 12
**Repository URL:** [Fork URL]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 1/ Water Temperature Classifier
- **Problem summary:** Initially input temperature ranges from 0-7, which were divided into ranges(cold,neutral,hot) using comparator. The problem statement is to add one more state named invlaid state and when this invalid state occured an led should turn on. Also a reset switch which will take the present state to idle.
- **Objective:** 
- **Inputs and outputs:** To add one more state we needed to increase the range of temperature (i.e;8) which required a 4bit input. Therefore one more input pin is added. For invalid state the output should turn on led. Therefore whenever the temperature detected is more than 8 and state is invalid output of led is one. Other outputs than this will be similar to the original given circuit.
- **Constraints and assumptions:** [List and justify]

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

[Write here]

## 4. Architecture
The 4-bit water temperature classifier takes a 4-bit temperature input (T3–T0) and checks its value using range comparators. Based on the input, it classifies the water temperature into four categories: Cold (0–2), Neutral (3–5), Hot (6–7), and Invalid (8–15). The control logic and Moore FSM manage the system using START, ACK, RESET, and CLK signals. The state memory stores the current condition and activates the corresponding output valve. Finally, the system displays the status through COLD\_VALVE, NEUTRAL\_VALVE, HOT\_VALVE, or INVALID.

![Block diagram]Group_Submissions/D9A_B_Group12/02_FSM_Logisim/Block diagram.jpeg

## 5. FSM Design
The FSM first stays in the IDLE state and waits for the START signal. When we give a 4-bit input, it checks the value: 0–2 means COLD, 3–5 means NEUTRAL, 6–7 means HOT, and 8–15 means INVALID. Based on the value, it moves to the respective state and activates the corresponding output. After giving ACK or RESET, it returns to IDLE, ready for the next input..

**Diagram:** G  
**State table:** Group_Submissions/D9A_B_Group12/02_FSM_Logisim/FSM.jpg

## 6. Logisim Implementation
- Logisim version: 
- Circuit file: Group_Submissions/D9A_B_Group12/02_FSM_Logisim/Circuit_water_temp.crc.circ
- Test cases and expected/observed behaviour: In our Logisim circuit, we first enter a 4-bit temperature input and press RESET to initialize the system. Then, we give a clock pulse so the circuit can process the input and classify the temperature. Based on the input value, the corresponding output (COLD, NEUTRAL, HOT, or INVALID) is activated. We repeat the same process of RESET and CLOCK for every new input to get the correct output.
- Screenshot/evidence: [Path/link]

## 7. Verilog HDL Implementation
- Tool/version: Xlinx Vivado
- Top module and submodules: [Water_temp_fsm]
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
| Group leader | [FSM Design, Github updation , Verilog RTL] | [Group_Submissions/D9A_B_Group12/02_FSM_Logisim/FSM.jpg,  ] |
| Member 2 | [Logisim circuit, PPT, Logisim simulation  ] |[ Group_Submissions/D9A_B_Group12/02_FSM_Logisim/Circuit_water_temp.crc.circ] |
| Member 3 | [Logisim circuit, Block Diagram, ] | [Group_Submissions/D9A_B_Group12/02_FSM_Logisim/Block diagram.jpeg ] |
| Member 4 | [FSM Design, Verilog coding, Testbench simulation ] | [Group_Submissions/D9A_B_Group12/05_Results/Simulation wavefrom of testbench.png ] |

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
