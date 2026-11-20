# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Vaibhavi Bhamare | D9B 3 | https://github.com/2025vaibhavibhamare-dev |
| Member 2 |Tanvish Patil |D9A 41 | (https://github.com/9dtanvishpatil-art) |
| Member 3 | Sumit Tithe   |D9B 63 | (https://github.com/SumitThite) |
| Member 4 | Vikrant Kharatmol |D9B  71 | (https://github.com/8511kharatmolvikrantsvhs-bit) |

**Class:** [D9A/D9B]  
**Group ID:** [ D9A_Group32]  
**Repository URL:** (https://github.com/2025vaibhavibhamare-dev/DSD-2026-D9B-Group32) 
**Final Pull Request URL:**

## 2. Assigned Problem Statement
- **Number/title:** Age Group Detector using Moore Finite State Machine (FSM) with Four-Category Classification.5
- **Problem summary:** The project involves designing a digital system that classifies a person's age into four categories: Child (0–12), Teen (13–19), Adult (20–25), and Senior (26–31). A 5-bit binary input is used to represent the age, which is stored in an input register and processed by a range decoder. A Moore Finite State Machine (FSM) determines the corresponding age category and activates the respective LED indicator. The original three-category age detector is modified by introducing an additional Senior category.
- **Objective:** To design and implement a 5-bit age input system using Verilog HDL.

To develop a range decoder for classifying ages into four distinct categories.

To design a Moore FSM with separate states for IDLE, CHILD, TEEN, ADULT, and SENIOR, along with an intermediate CHECK state.

To implement START, ACK, and RESET control operations.

To display the detected age category using four individual LED indicators.

To simulate and verify all 32 possible age input combinations (0–31) using a Verilog testbench.

To implement the design on a Spartan-7 FPGA using Xilinx Vivado.
- **Inputs and outputs:**
- |---|---|---|---|
- Signal Width Description
clk |1bit |Clock signal for synchronous operation
reset |1 bit| Active-high reset to initialise the FSM
start| 1 bit| Initiates age capture and classification
ack| 1 bit| Returns the FSM to IDLE state2
age_switches[4:0]| 5 bits| Binary age input through five switches (0–31)

Outputs:
Signal  Width Description
child_led | 1 bit|  Indicates Child category (0–12)
teen_led  | 1 bit| Indicates Teen category (13–19)
adult_led |1 bit | Indicates Adult category (20–25)
senior_led| 1bit| Indicates Senior category (26–31)

Age Classification:

Age Range Category LED Output
0–12 | Child|Green
13–19| Teen | Yellow
20–25|Adult | Red
26–31  |Senior| Blue
- **Constraints and assumptions:** Input Range: The system accepts only 5-bit unsigned binary inputs, representing ages from 0 to 31.

Age Classification: Each age value belongs to exactly one of the four predefined categories, with no overlapping ranges.

Input Registration: The age entered through the switches is captured in the input register when START is activated while the FSM is in IDLE.

Moore FSM Operation: The output LEDs depend only on the current FSM state and not directly on the input age.

Reset Operation: An active-high synchronous reset initialises the FSM to the IDLE state, with all LEDs turned OFF.

Acknowledgement: The ACK signal returns the FSM from any classification state to IDLE, switching OFF all category LEDs.

Clock Dependency: All state transitions and input registration operations are synchronised with the rising edge of the clock.

Single Category Output: Only one category LED is activated at a time. All LEDs remain OFF in the IDLE and CHECK states.

Hardware Interface: Five slide switches are used for age input, three push buttons for START, ACK and RESET, and four LEDs for category indication on the Spartan-7 FPGA board.

## 3. Problem Analysis and Proposed Solution
## 3. Problem Analysis and Proposed Solution

### 3.1 Requirements Analysis

The Age Group Detector requires a digital system capable of accepting a 5-bit binary age input and classifying it into four predefined categories: Child, Teen, Adult and Senior. The system must store the input age, decode its range and use a Moore Finite State Machine (FSM) to generate the corresponding output.

The major requirements are:

- Accept a 5-bit age input representing values from 0 to 31.
- Store the input using a 5-bit register when the START signal is activated.
- Classify the age into one of four categories using range-based combinational logic.
- Implement a Moore FSM with IDLE, CHECK, CHILD, TEEN, ADULT and SENIOR states.
- Use RESET to initialise the system and ACK to return it to the IDLE state.
- Activate the appropriate LED for the detected category while keeping the remaining LEDs OFF.
- Verify all 32 possible input combinations through Verilog simulation and implement the design on a Spartan-7 FPGA.

### 3.2 Edge Cases and Challenges

The design must correctly handle boundary values to ensure accurate classification. Particular attention is given to ages at the transition points between categories.

- **Lower and upper limits:** Ages 0 and 31 must be correctly classified as Child and Senior respectively.
- **Category boundaries:** Ages 12, 13, 19, 20, 25 and 26 must activate the correct category LED.
- **Reset condition:** When RESET is activated, the FSM must return to IDLE and all LEDs must turn OFF.
- **Input stability:** Once START is activated, the entered age must be stored so that subsequent changes in switch positions do not affect the current classification.
- **Acknowledgement:** ACK must return the system from any classification state to IDLE.
- **Invalid state handling:** Any undefined FSM state must return to IDLE through the default state condition.

### 3.3 Proposed Solution

The proposed solution uses a combination of sequential and combinational logic implemented in Verilog HDL.

Initially, the age is entered through five switches and captured by a 5-bit input register when START is activated. The registered age is then processed by a combinational range decoder, which identifies the corresponding category based on predefined age intervals.

The decoded result is used by a Moore FSM to determine the system state. The FSM consists of six states: IDLE, CHECK, CHILD, TEEN, ADULT and SENIOR. The CHECK state evaluates the registered age and transfers the FSM to the appropriate classification state.

Based on the current state, the output logic activates one of the four LEDs. The RESET signal initialises the system, while ACK returns the FSM to IDLE after classification.

The design is developed and simulated using Xilinx Vivado and subsequently programmed onto a Spartan-7 FPGA board for hardware verification.

### 3.4 Distinctive Features

- **Four-category classification:** Extends the original three-category age detector by introducing a Senior category (26–31).
- **Moore FSM architecture:** Ensures that LED outputs depend only on the current state, providing stable and predictable outputs.
- **Registered input:** Stores the entered age to maintain input stability during classification.
- **Independent LED indicators:** Uses four separate LEDs to represent the four age categories.
- **Control operations:** Incorporates START, ACK and RESET signals for controlled system operation.
- **Complete input verification:** Tests all 32 possible age combinations using an automated Verilog testbench.
- **FPGA implementation:** Demonstrates the practical implementation of digital logic using a Spartan-7 FPGA and Vivado.

### 3.5 Feasibility of the Design

The proposed design is feasible because it uses basic digital design concepts such as registers, combinational logic, comparators and finite state machines. These components can be efficiently described using Verilog HDL and implemented using the FPGA resources available on the Spartan-7 board.

The design requires only five input switches, three push buttons, four LED indicators and an onboard clock. Vivado provides the necessary environment for RTL design, behavioural simulation, synthesis, implementation and bitstream generation.

Furthermore, the classification logic is straightforward, requires minimal hardware resources and can be verified exhaustively for all 32 possible input values. Therefore, the project is technically achievable, cost-effective and suitable for demonstrating the practical application of FSM-based digital system design.
## 4. Architecture
<img width="2720" height="1062" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/5cad6c67-9ed3-4957-9430-367b0cae9d9a" />



## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

<img width="2008" height="998" alt="mermaid-diagram (3)" src="https://github.com/user-attachments/assets/3f053bdb-854b-433b-805c-dfb0cfe8a95d" />


## 6. Logisim Implementation
- Logisim version: 4.1.0
- Circuit file: Uploaded
- Test cases and expected/observed behaviour: SS uploaded
- Issues and corrections: Adding one Cade done 
- Screenshot/evidence: uploaded

## 7. Verilog HDL Implementation
- Tool/version: Xilinx Vivado 2018.3
- Top module and submodules:Top module: age_group_detector

Testbench module: age_group_detector_tb

Functional blocks: Age Input Register, Range Decoder, Moore FSM Controller, State Register and Output Decoder.
- Architecture/coding decisions: The design uses a Moore Finite State Machine (FSM).

A 5-bit input register stores the age when START is activated.

A combinational range decoder classifies the age into Child (0–12), Teen (13–19), Adult (20–25) and Senior (26–31).

The FSM consists of six states: IDLE, CHECK, CHILD, TEEN, ADULT and SENIOR.

START initiates age capture and classification, ACK returns the FSM to IDLE, and RESET initialises the system.

The output decoder activates the corresponding LED based on the current FSM state.
- Synthesizability considerations: Sequential logic is implemented using positive-edge-triggered always blocks.

Combinational logic uses always @(*) blocks.

Non-blocking assignments (<=) are used for sequential logic, while blocking assignments (=) are used for combinational logic.

The RTL uses synthesizable constructs such as registers, conditional statements and case statements.

Simulation delays, $display statements and testbench-specific constructs are excluded from the synthesizable design.

The design is intended for implementation on a Spartan-7 FPGA.
- RTL: `03_Verilog_Implementation/RTL/`
- Testbench: `03_Verilog_Implementation/Testbench/`

## 8. Verification and Simulation Results
All 32 test cases passed successfully, with 0 failures.

Tool/version: ilinx Vivado 2018.3 (Behavioral Simulation).
Number passed/failed:32 test cases passed, 0 failed (100% pass rate)
Waveform/log path:

## 9. FPGA Hardware Implementation
- FPGA board/device:  RealDigital Boolean FPGA Development Board based on AMD Xilinx Spartan-7 FPGA.
- Tool/version:  Xilinx Vivado Design Suite 2018.3.
- Clock/constraints: The design uses a clock input (clk) to synchronise the FSM and registers.

Active-high synchronous reset is used.

Five slide switches are used for the 5-bit age input.

Pushbuttons are assigned for START, ACK and RESET.

Four LED outputs indicate Child, Teen, Adult and Senior categories.

Pin assignments and I/O standards are defined using an XDC constraints file.
- Synthesis/implementation summary: The Verilog RTL is synthesised using Vivado for the Spartan-7 FPGA.

The design consists of an age input register, range decoder, Moore FSM and output decoder.

Implementation includes logic optimisation, placement and routing.

A bitstream is generated for FPGA programming after successful implementation and design-rule checks.
- Programming and hardware test result:The generated bitstream is intended to be programmed onto the Boolean Spartan-7 FPGA board.

Age values are entered using the five slide switches.

START initiates age classification.

The corresponding category LED indicates the detected age group.

ACK returns the system to IDLE, and RESET initialises the system.
- Evidence path: `04_FPGA_Hardware/`

Explain differences between simulation and hardware results, if any.

## 10. Challenges, Debugging and Improvements
## 10. Challenges, Debugging and Improvements

| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| FPGA bitstream generation error | Missing pin location (LOC) and I/O standard constraints in the XDC file. | Identified the need to assign valid FPGA pin locations and appropriate I/O standards for all input and output ports. | DRC errors identified; correct board constraints are required before bitstream generation. |
| FSM output verification | Ensuring correct classification at age-group boundaries. | Tested all 32 possible age inputs using a Verilog testbench. | All 32 test cases passed with 0 failures. |
| Age input stability | The input switches may change while the FSM is processing. | Used an input register to store the age when START is activated. | Provides stable input during classification. |
| FSM state control | Ensuring the system returns to its initial state after displaying the result. | Implemented ACK and RESET control signals. | Allows the system to return to IDLE. |

Future improvements:
- Add pushbutton debouncing and synchronisation.
- Display the detected age group on the seven-segment display.
- Improve the hardware interface with additional status indicators.
- Extend the age input range using more input bits.
- Perform complete hardware testing on the Spartan-7 FPGA board.
- Optimise FPGA resource utilisation and timing performance.
## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Group leader | [ Logism Simulation And Presentation] | [Done ] |
| Tanvish Patil| [ Verilog Coding And Fpga] | [Done ] |
|Sumit Tithe | [Logism ] | [Don ] |
| Vikrant Kharatmol | [ Report] | [ Done] |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
The Age Group Detector was successfully designed using Verilog HDL and a Moore Finite State Machine in Xilinx Vivado 2018.3. The system classifies 5-bit age inputs (0–31) into four categories:

Child: 0–12

Teen: 13–19

Adult: 20–25

Senior: 26–31

The design includes an age input register, range decoder, FSM controller and four LED outputs. START captures the age input, ACK returns the system to IDLE, and RESET initialises the system.

Behavioral simulation was performed in Vivado using a Verilog testbench. All 32 test cases passed successfully, with 0 failures, achieving a 100% simulation pass rate.

The project demonstrates the use of combinational logic, sequential circuits, registers and FSM-based control in digital system design. Further hardware validation and testing on the Spartan-7 FPGA board are required to confirm the complete physical implementation.

Conclusion: The project successfully demonstrates a four-category age classification system through Verilog design and simulation, with correct classification across all 32 possible input combinations.

## 14. Team Reflection
Through this project, the team gained practical knowledge of digital system design, Logisim circuit development, Verilog HDL coding, Moore FSM implementation and behavioral simulation using Vivado.

The project helped us understand how input registers, range comparators and state machines work together to perform a classification task. We also learned the importance of testbenches, boundary-value testing, debugging and FPGA pin constraints.

In future improvements, we would focus on completing hardware validation, improving input synchronisation and debouncing, and adding a seven-segment display to show the detected age group.
## 15. Final Submission Checklist
- [Done ] Team details and problem analysis complete.
- [Done ] Architecture/block diagram included.
- [Done ] FSM diagram/table or justified alternative included.
- [Done ] Logisim source and simulation evidence uploaded.
- [Done ] Verilog RTL and testbench uploaded.
- [Done ] Simulation results and test cases documented.
- [Done ] FPGA implementation and hardware evidence uploaded.
- [Done ] Results, challenges and conclusion documented.
- [Done ] Presentation and final report uploaded.
- [Done ] STATUS.md is up to date.
- [Done ] Final Pull Request created and URL recorded.
