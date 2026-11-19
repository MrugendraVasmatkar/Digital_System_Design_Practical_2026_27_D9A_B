# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | [Vasudha Saxena] | [52] | [star388] |
| Member 2 | [Tanisha Dembla] | [8] | [tanishadembla88-commits] |
| Member 3 | [Prakhar Srivastava] | [62] | [prakharsrivastavwork-ship-it] |
| Member 4 | [Hadi Ansari] | [1] | [hadiansari25] |

**Class:** [D9A/D9B]  
**Group ID:** [D9A_Group02]  
**Repository URL:** [https://github.com/star388/DSD-2026-D9A-Group02]  
**Final Pull Request URL:** [URL]

## 2. Assigned Problem Statement
- **Number/title:** 8
- **Problem summary:** In my problem I has to Add a master level to my existing 3 level Gaming XP System, this required me to change the combinational logic of my circuit and also changes the XP Range assumed earlier.
- **Objective:** The system should be able to correctly identify which level a player belongs to depending on their XP(categorizing them into four levels).
- **Inputs and outputs:**
-   * `clk` (1-bit, Input): System clock (positive-edge triggered).
    * `reset` (1-bit, Input): Synchronous active-high reset; clears input register and returns FSM to `IDLE`.
    * `start` (1-bit, Input): Initiates XP classification from `IDLE`.
    * `ack` (1-bit, Input): Acknowledges the displayed level and returns the FSM to `IDLE`.
    * `xp_in[3:0]` (4-bit, Input): 4-bit unsigned XP value from switches (`X3` to `X0`).
    * `led_beginner` (1-bit, Output): Active-high LED for XP `0–3`.
    * `led_intermediate` (1-bit, Output): Active-high LED for XP `4–7`.
    * `led_expert` (1-bit, Output): Active-high LED for XP `8–11`.
    * `led_master` (1-bit, Output): Active-high LED for XP `12–15`.
* **Constraints and assumptions:**
    * `xp_in[3:0]` is treated as an unsigned binary integer (`0` to `15`).
    * Adding the Master state increases total states to 5 (`IDLE` + 4 levels), requiring a 3-bit state register ($\lceil \log_2 5 \rceil = 3$ flip-flops).
    * Outputs must follow a strict **Moore** architecture (LEDs depend only on the current state, with all LEDs OFF in `IDLE`).
    * `reset`, `start`, and `ack` are synchronous control signals sampled on the rising edge of `clk`.

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
