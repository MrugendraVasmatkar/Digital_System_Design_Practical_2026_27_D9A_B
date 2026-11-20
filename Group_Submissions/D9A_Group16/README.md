# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Sai Dhanwate | 09 | Sai-21d |
| Member 2 | Nish Jaitu | 22 | jaitunish-glitch |
| Member 3 | Pratham Golhar | 11 | PrathamGolhar |
| Member 4 | Devangi Gurav | 16 | DevangiG |

**Class:** D9A  
**Group ID:** D9A_Group16 
**Repository URL:** https://github.com/Sai-21d/DSD-2026-D9A-Group16
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 1H1 : Water Temperature Classifier
- **Problem summary:** The system classifies the input water temperature into four categories: Very Cold, Cold, Neutral, and Hot. The classification is based on a 3-bit binary temperature input, with each category representing a specific range of input values.
- **Objective:** To design a digital system that identifies the temperature category based on the 3-bit input and activates the corresponding output signal. The system should ensure that only one temperature category is indicated at a time.
- **Inputs and outputs:** Input:
- Temp[2:0] – 3-bit input representing the water temperature value (0–7).



Outputs:
- VC – Very Cold indicator (1 when temperature is 0–1).
- COLD – Cold indicator (1 when temperature is 2–3).
- NEUTRAL – Neutral indicator (1 when temperature is 4–5).
- HOT – Hot indicator (1 when temperature is 6–7).
- **Constraints and assumptions:** The temperature input is represented using a 3-bit unsigned binary value, allowing values from 0 to 7.



The input is assumed to be valid and stable during classification.



The temperature ranges are fixed:
- 0–1: Very Cold
- 2–3: Cold
- 4–5: Neutral
- 6–7: Hot



Only one category output should be HIGH at any given time.



The system operates using digital logic and follows the specified classification ranges.

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

The system must classify eight possible temperature input values into four distinct categories. Each category is assigned a specific range of two consecutive binary values. The main requirement is to ensure accurate classification and prevent multiple category outputs from being activated simultaneously.

The proposed solution uses digital comparators and logic gates to compare the 3-bit temperature input against fixed reference values. The comparator outputs are combined using AND, OR, NOR, and NOT gates to generate the four category signals.

The classification logic is designed as follows:
- Very Cold: Activated when the temperature input is between 0 and 1.
- Cold: Activated when the temperature input is between 2 and 3.
- Neutral: Activated when the temperature input is between 4 and 5.
- Hot: Activated when the temperature input is between 6 and 7.
The design can be implemented and verified using Logisim, where all eight possible input combinations can be tested. The logic is feasible because it uses basic digital components, requires a limited number of inputs and outputs, and provides mutually exclusive category indications.

The design can subsequently be extended using an FSM (Finite State Machine) to control the classification process through defined states and transitions, if required by the assigned system specification.

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.
The system is divided into two main functional blocks: the Temperature Classification Unit and the FSM Control Unit.

The Temperature Classification Unit accepts a 3-bit temperature input (Temp[2:0]) and uses digital comparators and logic gates to identify the corresponding temperature category. It generates one of four outputs: Very Cold (VC), Cold, Neutral, or Hot.

The FSM Control Unit manages the classification process through defined states. It receives the classification outputs and control signals, determines the current operating state, and activates the corresponding output.

Data and control flow:

The 3-bit temperature input is provided to the classification unit.

The classification unit identifies the temperature range and generates the corresponding category signal.

The FSM receives the category signal and selects the appropriate state.

The corresponding category output is activated.

The FSM remains in the selected state until the acknowledgement signal is received, after which it returns to the idle state.

Design trade-offs:

Comparators provide a straightforward method of identifying temperature ranges.

Logic gates reduce the need for complex processing.

An FSM provides structured control over the classification sequence but requires additional flip-flops and control logic.

The modular design makes testing, debugging, and future modifications easier.

![Block diagram]Group_Submissions/D9A_Group16/02_FSM_Logisim/02_FSM_Logisim/Block_Diagram.jpeg

## 5. FSM Design
The proposed design uses a **Moore Finite State Machine (FSM)**, in which the outputs depend on the current state.

### States and State Encoding

| State     | Encoding | Function |
|-----------|----------|----------|
| IDLE      | 000      | Waits for the START signal |
| VERY_COLD | 001      | Indicates temperature from 0–1 |
| COLD      | 010      | Indicates temperature from 2–3 |
| NEUTRAL   | 011      | Indicates temperature from 4–5 |
| HOT       | 100      | Indicates temperature from 6–7 |

### Transition Conditions

1. When RESET = 1, the FSM transitions to the IDLE state.
2. In the IDLE state, the FSM remains in IDLE while START = 0.
3. When START = 1, the FSM checks the temperature category and transitions to the corresponding state.
4. The FSM remains in the selected category state while ACK = 0.
5. When ACK = 1, the FSM returns to the IDLE state.

### Reset Behaviour

The reset signal forces the FSM into the IDLE state, where all category outputs remain LOW.

### Output Behaviour

Only the output corresponding to the active category state is HIGH. All other category outputs remain LOW.


**Diagram:** Group_Submissions/D9A_Group16/02_FSM_Logisim/02_FSM_Logisim/FSM_Diagram.png.png
**State table:** Group_Submissions/D9A_Group16/02_FSM_Logisim/02_FSM_Logisim/FSM_State_Transition_table.md

## 6. Logisim Implementation
- Logisim version: Logisim 2.7.1.
- Circuit file: Group_Submissions/D9A_Group16/02_FSM_Logisim/02_FSM_Logisim/Water_Temp.circ
- Test cases and expected/observed behaviour: 
The circuit is designed to classify all eight possible combinations of the 3-bit temperature input.

| Temp[2:0] | Decimal | Expected Output |
|-----------|---------|-----------------|
| 000       | 0       | VERY COLD       |
| 001       | 1       | VERY COLD       |
| 010       | 2       | COLD            |
| 011       | 3       | COLD            |
| 100       | 4       | NEUTRAL         |
| 101       | 5       | NEUTRAL         |
| 110       | 6       | HOT             |
| 111       | 7       | HOT             |

The expected behaviour is that exactly one category output is HIGH for every valid input combination. The observed behaviour should be recorded after testing all eight combinations in Logisim.

- Screenshot/evidence:Group_Submissions/D9A_Group16/02_FSM_Logisim/02_FSM_Logisim/Simulation_Evidence.jpeg

## 7. Verilog HDL Implementation
- Tool/version: Vivado 2018.3
- Top module and submodules:
-  - `top.v` – Top-level module integrating the design.
- `water_temp_classifier.v` – Implements temperature classification logic.
- `btn_pulse.v` – Generates button pulse signals for control operations.
- Architecture/coding decisions: The design follows a modular architecture in which individual functionalities are implemented in separate Verilog modules. The temperature classification logic processes the 3-bit input and generates one of four category outputs. The top module integrates the required modules into a single design.
- Synthesizability considerations: The RTL uses synthesizable Verilog constructs and combinational/sequential logic as required. The design avoids simulation-only delays and is structured for FPGA synthesis and implementation.

- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
| Test ID | Inputs/Conditions | Expected Output | Observed Output | Pass/Fail |
|---|---|---|---|---|
| T01 | Temp = 000 (0) | VERY COLD | VERY COLD | PASS |
| T02 | Temp = 001 (1) | VERY COLD | VERY COLD | PASS |
| T03 | Temp = 010 (2) | COLD | COLD | PASS |
| T04 | Temp = 011 (3) | COLD | COLD | PASS |
| T05 | Temp = 100 (4) | NEUTRAL | NEUTRAL | PASS |
| T06 | Temp = 101 (5) | NEUTRAL | NEUTRAL | PASS |
| T07 | Temp = 110 (6) | HOT | HOT | PASS |
| T08 | Temp = 111 (7) | HOT | HOT | PASS |
  
Number passed: 8
Number failed: 0
Waveform/log path: Group_Submissions/D9A_Group16/03_Verilog_Implementation/03_Verilog_Implementation/Evidence.jpeg

## 9. FPGA Hardware Implementation
- FPGA board/device: Boolean Board
- Tool/version: Xilinx Vivado 2018.3
- Clock/constraints: The design was configured using an XDC constraints file to assign the input and output signals to the corresponding FPGA pins. Clock and reset constraints were configured as required by the design.
- Synthesis/implementation summary: The Verilog RTL design was successfully synthesized and implemented using Vivado. Placement and routing were completed, and the FPGA configuration bitstream was generated.
- Programming and hardware test result:The generated bitstream was programmed onto the Boolean Board. All eight possible 3-bit temperature inputs were tested, and the corresponding category outputs were verified.
- **Evidence path:** `04_FPGA_Hardware/`
- Evidence path: `04_FPGA_Hardware/`

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Sai Dhanwate | Management,Logisim & GitHub | Management and overview of all tasks, created Logisim design GitHub management |
| Nish Jaitu | Vivado and FPGA | Created Vivado and FPGA implementation. |
| Devangi Gurav | Vivado, Presentation and Report | Completed and designed Reports,etc. and helped in verilog |
| Pratham Golhar | Logisim and written Report | Created Logisim Design and completed written report |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
Summarise requirements met, correctness of simulation/hardware results, measured results, limitations and conclusion.

The Water Temperature Classifier was successfully designed and implemented using Logisim, Verilog HDL and FPGA technology. The system accepts a 3-bit binary temperature input and classifies it into four categories: Very Cold, Cold, Neutral and Hot.

| Parameter | Final Result |
|---|---|
| Temperature Input | 3-bit unsigned binary |
| Classification Categories | 4 |
| Total Input Combinations | 8 |
| Logisim Implementation | Completed |
| Verilog RTL Implementation | Completed |
| Verilog Simulation | Completed |
| FPGA Board | Boolean Board |
| FPGA Development Tool | Vivado 2018.3 |
| Hardware Implementation | Completed |
| Test Cases Passed | 8/8 |
| Functional Accuracy | 100% |

All eight possible input combinations were verified against their expected temperature categories. The simulation and hardware outputs were consistent, demonstrating the functional correctness of the design.

The project successfully demonstrates the practical application of digital comparators, logic gates, Verilog HDL, FSM concepts and FPGA implementation.

**Limitations:**
- The system supports only 3-bit temperature inputs.
- Temperature classification ranges are fixed.
- Physical temperature sensing is not included in the current design.
- The system can be extended with additional input resolution and sensor integration.

## 14. Team Reflection
What did the team learn? What would you improve?

Through this project, the team gained practical experience in digital system design, combinational logic implementation, Verilog HDL programming, FSM design and FPGA development.

The project helped us understand the complete digital design workflow, from problem analysis and circuit development to simulation, synthesis, hardware programming and verification.

We also improved our skills in debugging, teamwork, module integration and technical documentation.

**Future Improvements:**
- Integrating a physical temperature sensor.
- Increasing input resolution for more accurate classification.
- Adding an LCD or seven-segment display.
- Introducing configurable temperature thresholds.
- Improving the design with additional control and monitoring features.

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete.
- [x] Architecture/block diagram included.
- [x] FSM diagram/table or justified alternative included.
- [x] Logisim source and simulation evidence uploaded.
- [x] Verilog RTL and testbench uploaded.
- [x] Simulation results and test cases documented.
- [x] FPGA implementation and hardware evidence uploaded.
- [x] Results, challenges and conclusion documented.
- [x] Presentation and final report uploaded.
- [x] STATUS.md is up to date.
- [x] Final Pull Request created and URL recorded.
