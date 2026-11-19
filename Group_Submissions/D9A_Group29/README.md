# Digital System Design – Group Project Submission

> Group submission for D9A_Group29. This document follows the mandatory faculty template headings. Keep the headings, update pending items as work progresses, and claim completion only when supported by evidence.

## 1. Team Details
| Role | Student name | Roll number / class | GitHub username |
|---|---|---|---|
| Group leader | Kaif Bagwan | Pending confirmation | [kaifjbagwan4116-coder](https://github.com/kaifjbagwan4116-coder) |
| Member 2 | Kartik Mishra | 36 / D9A* | [2025kartikmishra-debug](https://github.com/2025kartikmishra-debug) |
| Member 3 | Vedant Pathare | 47 / D9B* | [vedantpathare1137-crypto](https://github.com/vedantpathare1137-crypto) |
| Member 4 | Arya Ukirde | 66 / D9B* | [d2026aryaukirde-max](https://github.com/d2026aryaukirde-max) |

**Group class:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3  
**Repository:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Faculty master repository:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B  
**Final Pull Request URL:** Pending

\*The class and roll details above were transcribed from the team screenshot previously supplied. Confirm them against the official faculty roster. Kaif's roll number is still pending.

## 2. Assigned Problem Statement
- **Number/title:** H3 — copy the exact official title and wording from the faculty-issued problem statement before final submission.
- **Project description:** The current implementation is an age-group classification system using comparator/decoder outputs and a finite-state machine.
- **Objective:** Classify a 5-bit age input into CHILD, TEEN or ADULT states, and enter ERROR when none of the three category-detect signals is asserted. The exact interpretation and limits must be checked against the official H3 statement.
- **Inputs:** The updated RTL uses a 5-bit age input (`age_in[4:0]` / board input `sw[4:0]`), clock, reset, start and acknowledgement controls. The board wrapper has three button inputs.
- **Outputs:** Four status LEDs representing CHILD, TEEN, ADULT and ERROR.
- **Current category boundaries in RTL:** CHILD = 0–12, TEEN = 13–19, ADULT = 20–31.
- **Error condition:** `no_match_debug = ~(child_detect | teen_detect | adult_detect)`. The FSM enters ERROR when all three category-detect signals are zero.
- **Assumptions/constraints:** Confirm these ranges and all required input/output behaviour against the official H3 statement. Confirm the actual FPGA board pinout before relying on the XDC.

## 3. Problem Analysis and Proposed Solution
The updated Verilog separates age-range detection from sequential control:

1. `age_range_decoder` generates `child_detect`, `teen_detect` and `adult_detect` from the 5-bit age input.
2. `age_group_fsm` consumes those signals. When `start` is asserted in IDLE, it stores the age and selects CHILD, TEEN or ADULT. If all three detection signals are zero, it selects ERROR.
3. A reset returns the FSM to IDLE. An acknowledgement from any result state returns it to IDLE.
4. The board wrapper synchronizes button and switch inputs, forms start/acknowledgement pulses and drives the four LEDs.

The testbench also forces all three comparator/detector signals low to exercise the ERROR path. This is a deliberate fault-condition testbench stimulus, not an assertion that a valid 5-bit age naturally falls outside the three configured ranges.

**Evidence:** `01_Problem_Analysis/`

## 4. Architecture
The current RTL contains three logical blocks:

- **Age range decoder:** combinational comparisons for CHILD, TEEN and ADULT.
- **FSM controller:** sequential state storage and transitions among IDLE, CHILD, TEEN, ADULT and ERROR.
- **Board wrapper:** input synchronization, edge/pulse generation and LED connection.

Add the final block diagram to `01_Problem_Analysis/` and ensure it matches the uploaded RTL.

**Block diagram:** Pending  
**Architecture evidence:** `01_Problem_Analysis/`

## 5. FSM Design
The RTL uses five states: `IDLE`, `CHILD`, `TEEN`, `ADULT` and `ERROR`, encoded with three bits. LED outputs are decoded from the current state, giving Moore-style outputs.

| Current state | Condition | Next state | LED output |
|---|---|---|---|
| IDLE | `start=0` | IDLE | All off |
| IDLE | `start=1`, child detect=1 | CHILD | CHILD |
| IDLE | `start=1`, teen detect=1 | TEEN | TEEN |
| IDLE | `start=1`, adult detect=1 | ADULT | ADULT |
| IDLE | `start=1`, all three detect signals=0 | ERROR | ERROR |
| CHILD / TEEN / ADULT / ERROR | `ack=0` | Hold current state | Corresponding LED remains on |
| CHILD / TEEN / ADULT / ERROR | `ack=1` | IDLE | All off |
| Any state | `reset=1` | IDLE | All off |

**FSM diagram:** Pending upload  
**State table:** Included above; add a separate diagram/table image if required by faculty.  
**Logisim circuits:** `02_FSM_Logisim/DSDlogs.circ` and `02_FSM_Logisim/DSDPRA.circ`.

The two Logisim circuit files are preserved. Confirm which circuit corresponds to the final 5-bit implementation and include simulation screenshots/evidence; do not assume a source file is verified merely because it is present.

## 6. Logisim Implementation
- **Circuit files:** `02_FSM_Logisim/DSDlogs.circ` and `02_FSM_Logisim/DSDPRA.circ`.
- **Logisim version:** The `DSDPRA.circ` file identifies Logisim-evolution v4.1.0; confirm the version used for the final circuit/demo.
- **Test cases and expected/observed behaviour:** Pending final circuit simulation and comparison with the Verilog FSM.
- **Issues and corrections:** Record actual debugging changes here.
- **Screenshot/evidence:** `01_Problem_Analysis/` currently contains the supplied image; add clearly identified Logisim simulation evidence under `02_FSM_Logisim/`.

## 7. Verilog HDL Implementation
- **Tool/version:** Vivado 2018.3 is identified in the preserved project file.
- **Target part recorded in preserved project:** `xc7s50csga324-1`.
- **RTL:** `03_Verilog_Implementation/RTL/age_group_detector_core.v`.
- **Testbench:** `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`.
- **Simulation artefacts:** `03_Verilog_Implementation/Simulation_Results/XSim/`.
- **Module names:** `age_range_decoder`, `age_group_fsm` and `age_group_detector_core`.

The current dedicated RTL and testbench use a 5-bit age input. The FSM checks the combined no-match condition before category selection, so ERROR is selected when CHILD, TEEN and ADULT detect signals are all zero.

## 8. Verification and Simulation Results
The updated testbench includes:

- Boundary checks for ages 0, 12, 13, 19, 20 and 31.
- A sweep across all 32 possible 5-bit age values to check that the decoder produces exactly one category indication for each configured value.
- FSM checks for CHILD, TEEN and ADULT, including LED outputs and latched age.
- An injected all-comparators-zero condition to verify transition to ERROR.
- Acknowledgement return-to-IDLE and reset-from-ERROR checks.

**Testbench source:** `03_Verilog_Implementation/Testbench/tb_age_group_detector.v`  
**Existing XSim artefacts:** `03_Verilog_Implementation/Simulation_Results/XSim/`

**Verification status:** The updated testbench is present in the repository, but the stored XSim compile/elaboration artefacts reference the older Vivado project snapshot. Re-run the updated testbench against the current 5-bit RTL and save a fresh run log/waveform before reporting final pass/fail totals. Do not state “ALL TESTS PASSED” until a fresh run confirms it.

## 9. FPGA Hardware Implementation
- **Tool/version recorded in project:** Vivado 2018.3.
- **FPGA part recorded in project:** `xc7s50csga324-1`.
- **Constraints:** `04_FPGA_Hardware/age_group_detector_boolean.xdc`.
- **Implementation reports:** `04_FPGA_Hardware/Implementation_Reports/`.
- **Bitstream:** `04_FPGA_Hardware/Bitstream/age_group_detector_core.bit`.
- **Vivado project archive:** `04_FPGA_Hardware/Vivado_Project/age_group_fsm/`.

**Important hardware integration issue:** The current dedicated RTL uses a 5-bit switch input (`sw[4:0]`), but the preserved XDC still contains a pin constraint for `sw[5]`. The archived Vivado project source and testbench are also older 6-bit versions. Update the Vivado project source/testbench and XDC to match the current 5-bit RTL, then rerun synthesis/implementation and regenerate the bitstream before treating the existing reports or bitstream as final for this design.

Confirm the physical board model and pinout before hardware programming. The presence of a bitstream or reports does not prove the latest design was programmed or demonstrated on the board.

## 10. Challenges, Debugging and Improvements
| Issue | Action / status |
|---|---|
| ERROR condition must occur when all three category detect outputs are zero | Current FSM explicitly checks `no_match_debug` and selects ERROR. Testbench injects `000` on the three signals to verify this path. |
| Input width changed from the earlier 6-bit snapshot to 5-bit | Dedicated RTL and testbench have been updated to 5-bit; archived Vivado project source/testbench and XDC still need alignment. |
| Existing implementation reports/bitstream may not match the latest RTL | Rebuild with the final source and corrected constraints before claiming final hardware results. |

Future improvements: add after final simulation and hardware validation.

## 11. Task Allocation and Individual Contribution
| Student | Responsibility | Actual contribution and supporting evidence |
|---|---|---|
| Kaif Bagwan | Group leadership, integration and repository coordination | Coordinated the group submission structure, repository updates and overall integration/documentation. Evidence: [group submission folder](./), [current RTL](03_Verilog_Implementation/RTL/age_group_detector_core.v), [submission README](README.md). |
| Kartik Mishra | **Ideation and initial design contribution** | Contributed to project ideation and helped shape the overall age-group detector solution and its classification/decision flow. Supporting project evidence: [problem-analysis reference image](01_Problem_Analysis/WhatsApp%20Image%202026-11-19%20at%203.57.32%20PM.jpeg), [problem analysis and proposed solution](README.md#3-problem-analysis-and-proposed-solution), and [FSM design/transition table](README.md#5-fsm-design). |
| Vedant Pathare | **Logisim circuit implementation** | Worked on the FSM/logic implementation in Logisim and the associated circuit files. Evidence: [DSDPRA.circ](02_FSM_Logisim/DSDPRA.circ), [DSDlogs.circ](02_FSM_Logisim/DSDlogs.circ), and [Logisim folder README](02_FSM_Logisim/README.md). The final circuit should still be opened and checked against the current 5-bit Verilog design, and a fresh Logisim simulation screenshot should be added. |
| Arya Ukirde | **Testbench development and simulation** | Worked on the Verilog testbench and simulation verification, including boundary-age checks, the full 0–31 decoder sweep, CHILD/TEEN/ADULT state checks, forced all-comparators-zero ERROR tests, acknowledgement and reset cases. Evidence: [current testbench source](03_Verilog_Implementation/Testbench/tb_age_group_detector.v), [XSim simulation artefacts](03_Verilog_Implementation/Simulation_Results/XSim/), and [XSim output image](03_Verilog_Implementation/Simulation_Results/XSim/image.png). A fresh simulation using the latest 5-bit RTL/testbench pair is still required before reporting final PASS/FAIL results. |

**Evidence note:** The links above attach the relevant group project artefacts for each assigned contribution. They support the listed work but do not independently prove individual file authorship; retain each member's commits or a short individual work log if the faculty asks for authorship-level evidence. Every student should be able to explain the complete project.

## 12. Progress Log
Maintain timestamped updates, evidence paths, blockers and next actions in `STATUS.md`. Update it at least once every two hours and at each major milestone.

## 13. Final Results and Conclusion
Pending a fresh simulation of the current 5-bit RTL/testbench pair, alignment and rerun of the Vivado project with corrected constraints, and physical FPGA demonstration. Complete this section only with verified results and observed behaviour.

## 14. Team Reflection
Complete after the team has reviewed the final design, simulation and hardware demonstration.

## 15. Final Submission Checklist

### Completed and present in the repository
- [x] Required `Group_Submissions/D9A_Group29/` submission folder and main folder structure created.
- [x] Initial problem-analysis reference material uploaded under `01_Problem_Analysis/`.
- [x] Both Logisim circuit source files (`DSDlogs.circ` and `DSDPRA.circ`) included under `02_FSM_Logisim/`.
- [x] Current dedicated 5-bit synthesizable RTL included in `03_Verilog_Implementation/RTL/`.
- [x] Matching 5-bit testbench source included in `03_Verilog_Implementation/Testbench/`.
- [x] Existing XSim simulation artefacts retained under `03_Verilog_Implementation/Simulation_Results/XSim/` (these are not yet accepted as fresh verification of the current 5-bit source).
- [x] Existing Vivado project archive, implementation reports and bitstream retained under `04_FPGA_Hardware/` (they still need to be regenerated from the final 5-bit design).
- [x] Individual contribution roles and links to supporting project artefacts added in Section 11.
- [x] Current design approach, FSM states/state table, and testbench coverage described in this README.

### Still pending before final submission
- [ ] Confirm all team details and roll numbers against the official faculty roster; add Kaif's roll number and verify the D9B section details shown for Vedant and Arya.
- [ ] Insert the exact official H3 title and problem-statement wording.
- [ ] Complete the formal requirements/assumptions analysis against the official H3 statement.
- [ ] Upload the final architecture/block diagram.
- [ ] Upload a separate FSM diagram and verify that it matches the final RTL.
- [ ] Open and verify the Logisim circuit against the final 5-bit design; add fresh Logisim simulation screenshots/evidence.
- [ ] Run the current 5-bit RTL and testbench together; save fresh simulation logs, waveform and PASS/FAIL verification summary.
- [ ] Update the archived Vivado project source and testbench to the current 5-bit design.
- [ ] Verify the actual FPGA board model and pinout, then update the XDC to match the 5-bit interface.
- [ ] Regenerate synthesis/implementation reports and the bitstream from the corrected final Vivado project.
- [ ] Add physical FPGA demonstration evidence, if the hardware demo is part of the submission requirement.
- [ ] Add expected-versus-observed test results and the verified conclusion in `05_Results/`.
- [ ] Upload the final presentation in `06_Presentation/`.
- [ ] Upload the final report in `07_Final_Report/`.
- [ ] Copy/commit this revised README and STATUS, then add the actual update time and evidence to `STATUS.md`.
- [ ] Create the final Pull Request targeting the faculty master repository and faculty-specified base branch.
