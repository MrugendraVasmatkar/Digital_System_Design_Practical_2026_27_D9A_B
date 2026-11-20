# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Aarish Das | 7 | [aarishds-bit] |
| Member 2 | Aryan Bhumkar | 4 | AryanBhumkar |
| Member 3 | Kanishk Vikram Singh | 58 | Kanishk-Vikram-Singh141 |
| Member 4 | Sahil Balani | 70 | d2026sahilbalani-design |

**Class:** [D9A/D9B]  
**Group ID:** [e.g. D9A_Group27]  
**Repository URL:** [https://github.com/aarishds-bit/Digital_System]  
**Final Pull Request URL:** (https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/34)]

## 2. Assigned Problem Statement
- **Number/title:** [Age group detector 2H4 – Add Category Counters]
- **Problem summary:** [The project involves designing an Age Group Detector that accepts a person's age as a digital input and classifies it into one of three categories: Child, Teen or Adult.The system uses a Finite State Machine (FSM) to control the classification process. A 2-bit counter-based method is incorporated after the FSM and before the LED output stage to implement the category-counting and output-control logic.]
- **Objective:** The objective of the project is to design and implement an Age Group Detector that classifies a person's age into three categories: Child (0–12 years), Teen (13–19 years), and Adult (20–31 years). The system accepts a 5-bit binary age input and uses a Moore Finite State Machine (FSM) to perform the classification based on predefined age ranges. It incorporates START, ACK and RESET control signals, along with a 2-bit gated-clock counter placed after the FSM and before the LED indication stage. The final category is indicated using three separate LEDs. The project aims to demonstrate the practical application of combinational logic, sequential circuits, FSM design, counters and Verilog HDL in developing a functional digital system.
- **Inputs and outputs:** The system takes a 5-bit binary age input (age[4:0]) to represent ages from 0 to 31. It also accepts CLK (clock), RESET (initialization), START (to initiate the classification process) and ACK (to acknowledge the result and return the FSM to the IDLE state) as control inputs. The system produces three outputs: child_led, teen_led and adult_led, corresponding to the Child (0–12 years), Teen (13–19 years) and Adult (20–31 years) categories, respectively. The appropriate LED indicates the detected age category after classification.
- **Constraints and assumptions:** [The system uses a 5-bit unsigned binary input, restricting the supported age range to 0–31 years. It assumes that the age input remains stable during the classification process and that the START signal is activated to initiate detection. The age categories are predefined as Child (0–12 years), Teen (13–19 years) and Adult (20–31 years), with no overlapping ranges. The FSM operates using a clock signal and is initialized to the IDLE state through RESET. The ACK signal is used to return the system to IDLE after classification. The design assumes valid digital inputs and a properly functioning clock signal. The 2-bit gated-clock counter is implemented after the FSM and before the LED indication stage, as required by the chosen architecture.]

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

[The main problem addressed by this project is the automatic classification of a given age into one of three predefined categories: Child (0–12 years), Teen (13–19 years) and Adult (20–31 years). The system must accept a 5-bit binary age input, process it according to the specified age ranges and indicate the detected category using separate LEDs. It also requires START, ACK and RESET control signals to manage the classification process. Special attention is given to boundary conditions, particularly ages 12 and 13, and ages 19 and 20, to ensure that every valid input is assigned to exactly one category. The proposed solution uses a Moore Finite State Machine (FSM) with four states: IDLE, CHILD, TEEN and ADULT. When START is activated, the input age is evaluated and the FSM transitions to the appropriate category state. The classification output is then passed through a 2-bit gated-clock counter stage placed after the FSM and before the LED indication stage. The corresponding LED indicates the detected category, while ACK returns the system to IDLE and RESET initializes the circuit. A distinctive feature of the design is the integration of FSM-based age classification with a gated-clock counter, demonstrating the combined application of combinational and sequential digital logic. The design is feasible because it can be implemented using basic digital components such as comparators, logic gates, flip-flops and counters. It was implemented using Logisim and Verilog HDL, making it suitable for simulation, functional verification and practical demonstration.]

## 4. Architecture
<img width="927" height="515" alt="image" src="https://github.com/user-attachments/assets/fc2b4cdc-2d4b-433b-a2c8-ce2474682c38" />


![Block diagram](path/to/block_diagram.png)

## 5. FSM Design
FSM details

Does the design use an FSM? Yes. It is a Moore FSM, because the outputs (the three LEDs) depend only on the current state and not on the inputs.

States and encoding

Two state flip-flops (S1, S0) with binary encoding:
<img width="642" height="220" alt="image" src="https://github.com/user-attachments/assets/4e072cd1-e13b-401d-83c4-df751c871a3e" />
<img width="486" height="155" alt="image" src="https://github.com/user-attachments/assets/e5fe9c95-2b95-4129-9b89-45ed3a1fa765" />
<img width="1198" height="573" alt="image" src="https://github.com/user-attachments/assets/a0c39ae0-7c0b-435b-8bb4-a3b552c0e789" />


**Diagram:** <img width="486" height="155" alt="image" src="https://github.com/user-attachments/assets/16e250ef-755e-4cbb-a95b-b2d81107f311" />

**State table:** <img width="486" height="155" alt="image" src="https://github.com/user-attachments/assets/e3f5573b-b107-4ed1-9a62-3a887f841cb3" />

## 6. Logisim Implementation
- Logisim version: [Xilinx Vivado 2018.3. Behavioral simulation was run with the Vivado simulator (xsim), and the waveform screenshots show all LEDs and counters behaving as expected.]
- Circuit file: circ file uploaded
-The design was tested using different 5-bit age inputs to verify the correct classification into Child, Teen and Adult categories. Test cases included ages 8, 15 and 25, which were expected to activate the Child, Teen and Adult LEDs, respectively. Boundary conditions such as ages 12, 13, 19 and 20 were also considered to verify the correct age-range classification. Additional tests involved activating START to initiate classification, ACK to return the FSM to the IDLE state, and RESET to initialize the circuit. The observed classification behaviour was checked against the expected outputs, and the gated-clock counter stage was examined as part of the overall implementation.
- Issues and corrections:During the implementation and testing process, the main challenge was ensuring correct coordination between the FSM, the 2-bit gated-clock counter and the LED indication stage. Initially, the output behaviour required debugging to ensure that the appropriate category was indicated correctly. The placement of the counter after the FSM and before the LEDs was maintained to match the intended architecture. The control signals, state transitions and counter logic were examined to ensure proper operation. The final gated-clock counter logic was reviewed during the practical examination, where the faculty confirmed that the implemented logic was correct and identified it as a gated-clock counter.
- Screenshot/evidence: circ file uploaded

## 7. Verilog HDL Implementation
**Tool/Version:** The design was implemented using Verilog HDL. 

**Top Module and Submodules:** The top module is `age_group_detector_h4`. It accepts the 5-bit age input along with CLK, RESET, START and ACK control signals. The design incorporates FSM-based age classification, a 2-bit gated-clock counter stage and three LED outputs: Child, Teen and Adult.

**Architecture/Coding Decisions:** The design follows a Moore FSM architecture with four states: IDLE, CHILD, TEEN and ADULT. The FSM uses age-range conditions to determine the appropriate category. A 2-bit gated-clock counter is placed after the FSM and before the LED indication stage, maintaining the intended project architecture. START initiates classification, ACK returns the FSM to IDLE, and RESET initializes the system.

**Synthesizability Considerations:** The design uses standard synthesizable Verilog constructs such as registers, wires, conditional statements and sequential logic. The gated-clock counter requires particular attention during synthesis because gated clocks can introduce clock-related timing and reliability issues. Proper clock handling and reset behaviour must be considered for reliable hardware implementation.
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
<img width="1588" height="832" alt="Simulation" src="https://github.com/user-attachments/assets/0125f31e-74e6-405e-b1cf-09708b3c448b" />


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
