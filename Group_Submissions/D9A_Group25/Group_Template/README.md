# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Devang Joshi | 24 | devang277 |
| Member 2 | Shivansh Sinha | 61 | shivanshsinha6 |
| Member 3 | Atharva Londhe | 31 | londheATHARVA |
| Member 4 | Shubham Pansare | 46 | Hxhjdjdi |

**Class:** D9A  
**Group ID:**  D9A_Group25  
**Repository URL:** https://github.com/devang277/DSD-2026-D9A-Group25  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 8H5
- **Problem summary:** To show the player's previous level when their level changes in a game xp level indicator (4-bit)
- **Objective:** To retrieve and store when there is a change in XP level and clock should go HIGH. the change must reflect in a separate set of LEDs as per previous state
- **Inputs and outputs:** inputs: clk, rst, st, ack, sw_0, sw_1, sw_2, sw_3
outputs: led1, led2, led3, led4, led5, led6
- **Constraints and assumptions:** 

## 3. Problem Analysis and Proposed Solution
Explain the requirements, edge cases, proposed solution, distinctive features and why the design is feasible.

The circuit must take a 4-bit XP value through the input register and classify it as beginner (0-3), intermediate (4-10) or expert (11-15) for all 16 values, show the current level on the primary LEDs (LED1, LED2, LED3) until ACK is given, and remember the previously detected level so it can be compared with the new level every time a new input is loaded using START. The XP comparator gives three lines, beginner, intermediate and expert, to the FSM, and the same 4-bit output of the input register also goes directly to the FSM as the current input. If the new level is different from the stored level, the FSM generates a HIGH change signal for one clock cycle, and this signal acts as the clock of the second LED register, which captures the previous level and makes the matching LED among LED4, LED5 and LED6 glow. This second set is cleared when the next input comes in. The edge cases handled are that the first input after RESET has no previous level and must not generate a change, an input staying in the same level, like 5 and then 9, must not generate a change, the boundary values 3, 4, 10 and 11 must go into the correct level, and a RESET in the middle of operation must clear the stored level and all LEDs. The distinctive features are that the second set of LEDs shows the level the player came from at the moment of the change, that the change signal comes out of a flip-flop so it can be used as a clock without glitches, that levels and not raw XP values are compared so there is no false change, and that the FPGA version has a debouncer and a synchronizer for the buttons and switches. The design is feasible because it uses only a small number of components, a 4-bit register, two comparisons, a few 2-bit registers and some decoding gates, which fit easily in the FPGA, the 100 MHz clock is much faster than the logic needs, and the inputs change at human speed. The same logic has already been built in Logisim, simulated in Vivado with all checks passing, and implemented in Vivado.

## 4. Architecture
Insert/link the block diagram and explain modules, data/control flow and design trade-offs.

![Block diagram](path/to/block_diagram.png)

## 5. FSM Design
State whether the design uses an FSM. If yes, specify Moore/Mealy, states/encoding, state diagram, state table, transition conditions and reset behaviour. If not, justify the alternative.

Yes, the design uses an FSM. The primary LED outputs follow a Moore model because they depend only on the current state, while the change detection works in a Mealy style because it depends on the current input and the stored previous level. The FSM has four states, IDLE (00), BEGINNER (01), INTERMEDIATE (10) and EXPERT (11), and the same 2-bit codes are used for the levels so that the FSM can move straight to the detected level. In IDLE, when START is given, the FSM goes to BEGINNER if XP is 0-3, to INTERMEDIATE if XP is 4-10, and to EXPERT if XP is 11-15, and from any level state it returns to IDLE when ACK is given, otherwise it stays in the same state. All LEDs are off in IDLE, and the second set of LEDs is controlled by the change signal. RESET is synchronous and active-high, and it takes the FSM to IDLE and clears the stored levels, the valid flags and all LEDs, so the next input is treated as the first input and generates no change. The state diagram and the state table follow directly from these transitions, and I can write them out if you need them.

**Diagram:** https://github.com/devang277/DSD-2026-D9A-Group25/blob/main/Group_Submissions/D9A_Group25/Group_Template/02_FSM_Logisim/gamingxp25.circ
**State table:** [Path/link]

## 6. Logisim Implementation
- Logisim version: Logisim Evolution
- Circuit file: https://github.com/devang277/DSD-2026-D9A-Group25/blob/main/Group_Submissions/D9A_Group25/Group_Template/02_FSM_Logisim/gamingxp25.circ
- Test cases and expected/observed behaviour: [Details]
- Issues and corrections: Slightly differs from the RTL Schematic as it does not have Acknowledge and Start, hence difference is observed in clock cycle as well.
- Screenshot/evidence: https://github.com/devang277/DSD-2026-D9A-Group25/blob/main/Group_Submissions/D9A_Group25/Group_Template/06_Presentation/Solution%20of%20Problem%208%20H5.pptx 

## 7. Verilog HDL Implementation
- Tool/version: AMD Xilinx Vivado 2025.2
- Top module and submodules: xp_h5_top
 ├── u_rst    (btn_cond)
 ├── u_start  (btn_cond)
 ├── u_ack    (btn_cond)
 ├── xp_s1 / xp_s2  (registers in the top)
 └── u_core   (xp_decoder_h5)
- Architecture/coding decisions: Architecture of the code is divided into 7 parts. button, ports and state encoding, comparator, next state logic, main clocked block, second let set and top module.
- Synthesizability considerations: the button cleaning has been done considering the possibility of the physical button bouncing and giving repetitive signals instead of single signal. 100 MHZ FPGA has been considered for the design code. the input register has been made using 2 flip flops to act as the synchronizer. This is done to avoid a wrong/bad value reaching the next state logic in case of one flip flop going into metastable state. it adds a two clock delay but the hardware is safer and more efficent. 
- RTL: Group_Submissions/D9A_Group25/Group_Template/03_Verilog_Implementation/RTL
- Testbench: Group_Submissions/D9A_Group25/Group_Template/03_Verilog_Implementation/Testbench

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | [ ] | [ ] | [ ] | [ ] |
| T02 | [ ] | [ ] | [ ] | [ ] |
| T03 | [ ] | [ ] | [ ] | [ ] |

Tool/version: AMD Xilinx Vivado 
Number passed/failed: All Pass 
Waveform/log path: Group_Submissions/D9A_Group25/Group_Template/03_Verilog_Implementation/Simulation_Results

## 9. FPGA Hardware Implementation
- FPGA board/device: AMD (Xilinx) Spartan 7 Real Digital Boolean Board
- Tool/version: AMD Xilinx Vivado
- Clock/constraints: [Details]
- Synthesis/implementation summary: [Details]
- Programming and hardware test result: Worked the same.
- Evidence path: Group_Submissions/D9A_Group25/Group_Template/04_FPGA_Hardware

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
- [.] Team details and problem analysis complete.
- [.] Architecture/block diagram included.
- [ ] FSM diagram/table or justified alternative included.
- [.] Logisim source and simulation evidence uploaded.
- [.] Verilog RTL and testbench uploaded.
- [.] Simulation results and test cases documented.
- [.] FPGA implementation and hardware evidence uploaded.
- [ ] Results, challenges and conclusion documented.
- [.] Presentation and final report uploaded.
- [ ] STATUS.md is up to date.
- [.] Final Pull Request created and URL recorded.
