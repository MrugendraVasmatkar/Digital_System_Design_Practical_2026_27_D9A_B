# Digital System Design – Group Project

> This is the group submission README. Retain all mandatory headings. Replace pending items with verified information as the project progresses. Do not claim simulation or hardware completion without evidence.

## 1. Team Details
| Role | Student name | Roll number / class | GitHub username |
|---|---|---|---|
| Group leader | Kaif Bagwan | Pending | [kaifjbagwan4116-coder](https://github.com/kaifjbagwan4116-coder) |
| Member 2 | Kartik Mishra | 36 / D9A | [2025kartikmishra-debug](https://github.com/2025kartikmishra-debug) |
| Member 3 | Vedant Pathare | 47 / D9B | [vedantpathare1137-crypto](https://github.com/vedantpathare1137-crypto) |
| Member 4 | Arya Ukirde | 66 / D9B | [d2026aryaukirde-max](https://github.com/d2026aryaukirde-max) |

**Class / group:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3  
**Repository URL:** https://github.com/kaifjbagwan4116-coder/DSD-2026-D9A-Group29  
**Faculty master repository:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B  
**Final Pull Request URL:** Pending

**Roster check:** The supplied team screenshot shows Kartik as D9A roll 36, Vedant as D9B roll 47, and Arya as D9B roll 66. Confirm the D9B class details and group eligibility against the official faculty roster. Kaif's roll number is still pending.

## 2. Assigned Problem Statement
- **Number/title:** H3. The exact official title and wording should be copied from the faculty-issued H3 problem statement.
- **Problem summary:** The project files currently supplied with the repository indicate an age-group classification / age-group detector FSM. This is a working description based on the existing files, not a substitute for the official H3 statement.
- **Objective:** Complete the design stated in H3 and demonstrate its operation using the required FSM/Logisim, Verilog, simulation and FPGA workflow. Refine this statement after checking the official problem wording.
- **Inputs and outputs (current supplied baseline):** The preserved Verilog snapshot has a clock, reset, start and acknowledgement controls, a 6-bit age input, and four LED status outputs. The board-level wrapper uses a 6-bit switch input and three button inputs. These details describe the supplied baseline only; reconcile them with the latest intended 5-bit H3 implementation before final sign-off.
- **Constraints and assumptions:** Confirm the valid age range, age-category boundaries, invalid-input handling, reset/acknowledgement behaviour, FPGA board/device and pin mapping against the official H3 statement and actual hardware.

## 3. Problem Analysis and Proposed Solution
The problem-analysis folder contains the supplied analysis placeholder and image. Complete this section from the official H3 statement by documenting the requirements, assumptions, input/output definitions, boundary cases, proposed solution and why the design is feasible.

The current repository snapshot suggests a state-machine-based age classifier. Do not treat the existing 6-bit RTL as the final specification; align the analysis and proposed solution with the final approved 5-bit implementation.

**Evidence location:** `01_Problem_Analysis/`

## 4. Architecture
The preserved project snapshot contains an age-group FSM and a board-level wrapper. In the supplied baseline, the wrapper synchronizes the button and switch inputs, generates start/acknowledgement pulses and connects the FSM status to four LEDs.

Add the final block diagram here and update this description if the final RTL architecture changes.

**Block diagram:** Pending  
**Architecture evidence:** `01_Problem_Analysis/`

## 5. FSM Design
The supplied baseline defines the states `IDLE`, `CHILD`, `TEEN`, `ADULT` and `ERROR`. Its LED outputs are decoded from the current state, which is consistent with a Moore-style output arrangement. The baseline uses a 3-bit state register and transitions from `IDLE` on `start`; the result states return to `IDLE` on acknowledgement. Reset returns the FSM to `IDLE`.

These are observations about the currently preserved baseline only. Verify the state model, state encoding, transition conditions and age thresholds against the final 5-bit RTL and official H3 requirements.

**FSM diagram:** Pending  
**State table:** Pending  
**Logisim circuit:** `02_FSM_Logisim/DSDlogs.circ`

## 6. Logisim Implementation
- **Logisim version:** Pending confirmation.
- **Circuit file:** `02_FSM_Logisim/DSDlogs.circ`.
- **Test cases and expected/observed behaviour:** Pending verification and documentation.
- **Issues and corrections:** Add actual issues and fixes after review.
- **Screenshot/evidence:** Add Logisim simulation screenshots/evidence under `02_FSM_Logisim/`.

The supplied `.circ` source file has been copied into the required folder. Its behaviour still needs to be checked against the final H3 FSM.

## 7. Verilog HDL Implementation
- **Tool/version:** Vivado project files are present in the supplied project snapshot; confirm the exact version used for the final build.
- **Top module and submodules (supplied baseline):** `age_group_detector_core` and `age_group_fsm`.
- **Architecture/coding decisions:** The supplied snapshot has a board-level wrapper and an FSM module. Review and update this description after the final 5-bit RTL is incorporated.
- **Synthesizability considerations:** Confirm the final RTL uses synthesizable constructs and that the final top module and constraints target the intended FPGA.
- **RTL:** `03_Verilog_Implementation/RTL/`
- **Testbench:** `03_Verilog_Implementation/Testbench/`
- **Preserved Vivado project:** `04_FPGA_Hardware/Vivado_Project/age_group_fsm/`

**Version note:** The supplied RTL snapshot uses a 6-bit age input. The latest intended H3 implementation is 5-bit. Keep the supplied snapshot as the preserved starting point, but update the dedicated RTL and matching testbench when the final 5-bit source is ready.

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | Add final H3 test vector | Pending | Pending | Pending |
| T02 | Add final H3 boundary test | Pending | Pending | Pending |
| T03 | Add final invalid/reset/acknowledgement test as applicable | Pending | Pending | Pending |

**Tool/version:** Existing XSim project artefacts are present; confirm the simulator version used for the final run.  
**Number passed/failed:** Not yet confirmed for the final 5-bit design.  
**Waveform/log path:** `03_Verilog_Implementation/Simulation_Results/`

The local folder check found 18 files under the simulation-results location. These are existing supplied artefacts; the folder-preparation script did not run a new simulation. Re-run the final testbench against the final RTL and record actual expected/observed results before marking verification complete.

## 9. FPGA Hardware Implementation
- **FPGA board/device:** Confirm the exact physical board and FPGA part number.
- **Tool/version:** Confirm the version used for the final implementation run.
- **Clock/constraints:** `04_FPGA_Hardware/age_group_detector_boolean.xdc`. Verify clock, package pins and I/O standards against the actual board.
- **Synthesis/implementation summary:** The supplied files include 12 implementation-report files in the checked reports folder. Confirm that they correspond to the final RTL and target device.
- **Programming and hardware test result:** Not yet confirmed by this folder-preparation step. Record actual programming and board observations after testing.
- **Evidence path:** `04_FPGA_Hardware/`

The local folder check found one bitstream file. Its presence does not prove that it corresponds to the final 5-bit RTL or that it has been programmed and tested on the physical board. Keep hardware evidence and claims tied to an actual demonstration.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| Supplied RTL snapshot uses a 6-bit input, while the latest intended H3 implementation is 5-bit | Existing project files represent an earlier implementation snapshot | Reconcile RTL, testbench, constraints and implementation outputs with the final design | Pending final update and verification |
| FPGA board and XDC pin mapping need confirmation | Physical board details have not yet been confirmed in this README | Verify board model, FPGA part and pinout before the final implementation and hardware test | Pending |

**Future improvements:** Add after final verification and group review.

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| Kaif Bagwan | Group leadership and repository coordination | Fork setup, local submission-folder preparation and initial folder verification; add further evidence as work progresses |
| Kartik Mishra | To be agreed by the group | Pending actual contribution record |
| Vedant Pathare | To be agreed by the group | Pending actual contribution record |
| Arya Ukirde | To be agreed by the group | Pending actual contribution record |

Update this table with each student's actual work. Every student must be ready to explain the complete project.

## 12. Progress Log
Maintain time-wise progress, evidence paths, blockers and next actions in `STATUS.md`. Update it at least once every two hours and at every major milestone.

## 13. Final Results and Conclusion
Pending completion of the final H3 problem analysis, 5-bit RTL/testbench reconciliation, final simulation, FPGA implementation review and physical hardware testing. Report measured results, limitations and conclusions only after verifying the corresponding evidence.

## 14. Team Reflection
Complete this section after the group has reviewed the final design and demonstration. Record actual learning outcomes and proposed improvements.

## 15. Final Submission Checklist
- [ ] Full team names, roll numbers and GitHub usernames completed and checked against the official roster.
- [ ] Official H3 problem statement title and wording included.
- [ ] Requirements, assumptions, input/output definitions and proposed solution documented.
- [ ] Architecture/block diagram included.
- [ ] FSM diagram and state table included and consistent with final RTL.
- [ ] Logisim `.circ` source and simulation evidence included.
- [ ] Final synthesizable Verilog RTL uploaded in `03_Verilog_Implementation/RTL/`.
- [ ] Matching testbench and test vectors uploaded in `03_Verilog_Implementation/Testbench/`.
- [ ] Final simulation waveforms, logs and verification summary uploaded in `03_Verilog_Implementation/Simulation_Results/`.
- [ ] FPGA board/device details and verified XDC constraints documented.
- [ ] Implementation reports and relevant bitstream included in `04_FPGA_Hardware/`.
- [ ] Actual hardware evidence included if hardware testing has been completed.
- [ ] Test cases, expected/observed comparison and conclusion documented in `05_Results/`.
- [ ] Final presentation uploaded in `06_Presentation/`.
- [ ] Final report uploaded in `07_Final_Report/`.
- [ ] `STATUS.md` is current and evidence paths are valid.
- [ ] Final Pull Request created against the faculty master repository and correct base branch.
