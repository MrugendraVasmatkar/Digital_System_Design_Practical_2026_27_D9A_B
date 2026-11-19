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

### 1. Requirements

The objective of this project is to design a 3-bit Water Temperature Classifier that identifies the temperature category of water and activates the corresponding valve output. The system accepts a 3-bit binary input representing temperature levels from 0 to 7.

The temperature is classified into three categories:

- **COLD:** Input values from 0 to 2.
- **NEUTRAL:** Input values from 3 to 5.
- **HOT:** Input values from 6 to 7.

The system consists of a 3-bit input register, range decoder, Finite State Machine (FSM), clock, and three output indicators representing the COLD, NEUTRAL, and HOT valves.

The FSM is controlled using START, ACK, and RESET signals. For the H2 modification, the original Moore FSM is redesigned as a Mealy FSM to generate valve outputs immediately based on the current state and temperature input.

### 2. Edge Cases

The system must correctly classify all eight possible combinations of the 3-bit input.

- Input 000 (0) must be classified as COLD.
- Input 001 (1) must be classified as COLD.
- Input 010 (2) must be classified as COLD.
- Input 011 (3) must be classified as NEUTRAL.
- Input 100 (4) must be classified as NEUTRAL.
- Input 101 (5) must be classified as NEUTRAL.
- Input 110 (6) must be classified as HOT.
- Input 111 (7) must be classified as HOT.

Additional operating conditions:

- RESET must return the FSM to its initial IDLE state.
- START must initiate the temperature classification process.
- ACK must acknowledge the result and return the FSM to IDLE.
- Only one valve output should be active at a time.
- All valve outputs must remain OFF when the system is reset or disabled.

### 3. Proposed Solution

The proposed solution is to implement a 3-bit Water Temperature Classifier using a Mealy Finite State Machine.

The system first accepts the temperature input through three switches (T2, T1, T0). A 3-bit register stores the input value. The stored value is then passed to a range decoder, which uses comparator logic to classify the temperature as COLD, NEUTRAL, or HOT.

The classification signals are processed by the Mealy FSM controller. The FSM uses state registers, combinational logic gates, and control signals such as START, ACK, and RESET to manage the operation.

Unlike the original Moore FSM, the Mealy FSM generates the valve outputs based on both the current state and the current temperature input. This allows the outputs to respond immediately to input changes without waiting for an additional state transition.

The three output indicators represent the COLD, NEUTRAL, and HOT valve conditions.

### 4. Distinctive Features

- Uses a Mealy FSM instead of the original Moore FSM for immediate output generation.
- Supports all eight possible combinations of the 3-bit temperature input.
- Classifies temperature into three predefined categories: COLD, NEUTRAL, and HOT.
- Uses comparator-based range detection for accurate temperature classification.
- Includes START, ACK, and RESET controls for managing system operation.
- Uses three separate output indicators to display the detected temperature category.
- Uses a register to store the temperature input and ensure synchronized operation.

### 5. Feasibility

The proposed design is feasible because it uses basic digital components such as registers, comparators, flip-flops, logic gates, and LEDs. The 3-bit input provides only eight possible combinations, making temperature classification simple and efficient.

The Mealy FSM requires a small number of states and can be implemented using basic sequential and combinational logic. The circuit can be designed and tested using Logisim Evolution and implemented in Verilog HDL for simulation and verification using Vivado.

The project provides a practical demonstration of digital logic design, comparator-based classification, sequential circuits, and Finite State Machines. It can also be extended in the future by connecting an actual temperature sensor and electrically controlled water valves.

## 4. Architecture
Modules Explanation
1. Input Module (Switches): Provides a 3-bit temperature input (T2, T1, T0), representing values from 0 to 7.

2. Input Register (3-bit): Stores the temperature input on the rising edge of the clock, ensuring stable data for classification.

3. Temperature Classification Module (Comparator/Range Decoder): Compares the registered input with predefined temperature ranges and generates three signals:
- COLD = 1 for 0–2
- NEUTRAL = 1 for 3–5
- HOT = 1 for 6–7
4. FSM Controller (Mealy FSM): Controls the classification process using the state register, next-state logic and output logic. START initiates classification, ACK acknowledges the result, and RESET initializes the FSM.

5. Output Module: Controls three LED indicators representing the COLD, NEUTRAL and HOT valve outputs.
4.3 Data and Control Flow
1. The three-bit temperature input (T2, T1, T0) is provided through input switches.
2. The input register captures and stores the temperature value using the clock signal.
3. The range decoder classifies the stored temperature into COLD, NEUTRAL or HOT.
4. The Mealy FSM processes the classification signals along with START, ACK and RESET.
5. When START is activated in IDLE, the corresponding valve output is generated immediately based on the temperature category.
6. The FSM transitions to the WAIT_ACK state and waits for acknowledgement.
7. When ACK is activated, the FSM returns to IDLE.
8. RESET initializes the FSM to IDLE and turns OFF all valve outputs.
4.4 Design Trade-offs
Aspect	Chosen design	Trade-off / justification
FSM model	Mealy FSM	Provides immediate output response but may be more sensitive to input glitches.
Temperature detection	Comparator-based range decoder	Simple and fast classification, but requires multiple logic gates.
Input handling	3-bit register	Provides stable, synchronized input at the cost of additional hardware.
Output system	Three separate LEDs	Clearly indicates each temperature category but requires three output indicators.
State control	START, ACK and RESET	Provides controlled operation but requires additional control logic.

4.5 Architecture Summary
The proposed architecture combines input storage, comparator-based temperature classification and a Mealy FSM controller to achieve automatic water temperature classification. The design supports all eight possible 3-bit input combinations and provides immediate valve indication through three separate outputs. It is suitable for implementation and verification using Logisim Evolution and Verilog HDL.
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
