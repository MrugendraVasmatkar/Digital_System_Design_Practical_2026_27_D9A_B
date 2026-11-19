# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Parth Nemade | 42 | parthn17 |
| Member 2 | Arnav Dhole | 09 | arnavdhole3-sudo |
| Member 3 | Aryan Mansukh | 32 |aryanmansukh69-a11y |
| Member 4 | Mugdha Parab | 38 | mugdhap0407 |

**Class:** D9A/D9B  
**Group ID:** D9B_Group18  
**Repository URL:** https://github.com/parthn17/DSD_2026_D9A_B_Group18.git 
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** Water Temperature Classifier
- **Problem summary:** The Water Temperature Classifier Modification H2 designs and verifies a digital controller that classifies a 3-bit temperature input (0–7) and immediately activates the corresponding water valve.
- **Objective:** The system must classify a 3-bit temperature input into three categories—Cold, Neutral, or Hot—and immediately activate the corresponding water valve
- **Inputs and outputs:** Inputs : Temp[2:0], Start, Acknowledgement, Reset
                          Outputs : Cold Valve, Neutral Valve, Hot Valve
- **Constraints and assumptions:** ## Constraints and Assumptions

### 1. Constraints

1. **Input Constraint:** The system accepts a 3-bit binary temperature input (T2, T1, T0), representing values from 0 to 7.

2. **Temperature Classification Constraint:** The input temperature must be classified into three categories:
   - COLD: 0–2
   - NEUTRAL: 3–5
   - HOT: 6–7

3. **Input Register Constraint:** A 3-bit register is used to store the temperature input before classification. The register operates using a clock signal.

4. **Clock Constraint:** The system uses a clock signal to synchronize the register and FSM state transitions.

5. **START Constraint:** The START input initiates the temperature classification process.

6. **ACK Constraint:** The ACK input acknowledges the classification result and returns the FSM to its IDLE state.

7. **RESET Constraint:** The RESET input initializes the FSM to the IDLE state and turns OFF all valve outputs.

8. **FSM Constraint:** The system uses a Finite State Machine based on the Mealy model for controlling the temperature classification and valve outputs.

9. **Output Constraint:** The system has three valve indicators:
   - COLD valve: Activated for temperature values 0–2.
   - NEUTRAL valve: Activated for temperature values 3–5.
   - HOT valve: Activated for temperature values 6–7.

10. **Mealy Output Constraint:** The valve outputs depend on the current FSM state and temperature input, allowing immediate output generation without waiting for an additional state transition.

### 2. Assumptions

1. **Digital Temperature Input:** The 3-bit input is assumed to represent a digitally encoded temperature level rather than an actual temperature in degrees Celsius.

2. **Valid Input Range:** All eight combinations from 000 to 111 are considered valid inputs.

3. **Fixed Classification Ranges:** The temperature classification ranges are predefined and remain unchanged during system operation.

4. **Stable Input:** The temperature input is assumed to remain stable during the register capture and classification process.

5. **Initial State:** The FSM is assumed to start in the IDLE state after RESET is activated.

6. **Mutually Exclusive Outputs:** Only one valve output is expected to be ON at a time, depending on the detected temperature category.

7. **Acknowledgement:** The ACK signal is assumed to return the FSM to IDLE, allowing a new classification cycle.

8. **Clock Operation:** The clock is assumed to provide valid pulses for synchronizing the register and FSM operations.

9. **Ideal Operation:** The digital circuit is assumed to operate without hardware faults, electrical noise or unexpected signal fluctuations.

### 3. Justification

These constraints and assumptions define the operating conditions of the Water Temperature Classifier. The 3-bit input allows eight temperature levels to be represented and classified into three predefined categories. The Mealy FSM provides immediate valve output generation based on the current state and input conditions. The START, ACK and RESET signals provide controlled operation, while the three valve indicators clearly display the classification result. The design can be implemented and verified using Logisim Evolution and Verilog HDL.

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
- Logisim version: Logisim v2.7.2
- Circuit file: Group_Submissions/D9B_Group18/02_FSM_Logisim/Water_Temperature_H2.circ
- Test cases and expected/observed behaviour: [Details]
- Issues and corrections: [Details]
- Screenshot/evidence: Group_Submissions/D9B_Group18/02_FSM_Logisim/logisim_sim_ss.jpeg

## 7. Verilog HDL Implementation
- Tool/version: Vivado 2018.3
- Top module and submodules: [Names]
- Architecture/coding decisions: [Details]
- Synthesizability considerations: [Details]
- RTL: `Group_Submissions/D9B_Group18/03_Verilog_Implementation/RTL`
- Testbench: `Group_Submissions/D9B_Group18/03_Verilog_Implementation/Testbench`

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
