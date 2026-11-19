# Group Progress Status

**Class / group:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3 — age-group classification / detector FSM (confirm exact official title and wording)  
**Group leader:** Kaif Bagwan (@kaifjbagwan4116-coder)

## 1. Current milestone status

Use only: `Not Started`, `In Progress`, `Completed` or `Blocked`. File presence alone does not prove that simulation or hardware verification is complete.

| No. | Milestone | Status | Evidence path/link | Last updated / notes |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | In Progress | `01_Problem_Analysis/` | Exact official H3 title/wording and requirements still need confirmation |
| 2 | Architecture and block diagram prepared | In Progress | `01_Problem_Analysis/` | RTL structure can be described; final block diagram still pending |
| 3 | FSM diagram/table completed | In Progress | `02_FSM_Logisim/`, `README.md` §5 | Five-state model documented in README; separate diagram still pending |
| 4 | Logisim circuit files organized | In Progress | `02_FSM_Logisim/DSDlogs.circ`, `02_FSM_Logisim/DSDPRA.circ` | Two circuit files are present; verify which one is final and add simulation evidence |
| 5 | Logisim simulation verified | Not Started | `02_FSM_Logisim/` | Fresh evidence and expected/observed comparison pending |
| 6 | Current 5-bit Verilog RTL uploaded | Completed | `03_Verilog_Implementation/RTL/age_group_detector_core.v` | Current dedicated RTL uses 5-bit age input and separate range decoder/FSM/wrapper |
| 7 | Updated testbench uploaded | Completed | `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` | Includes boundary checks, full 0–31 decoder sweep, ERROR injection, ACK and reset checks; execution must still be freshly verified |
| 8 | Fresh simulation run and verification summary | Blocked | `03_Verilog_Implementation/Simulation_Results/XSim/` | Stored compile/elaboration artefacts appear to be from the older archived project; rerun current 5-bit RTL/testbench and save fresh output |
| 9 | FPGA constraints aligned with current 5-bit RTL | Blocked | `04_FPGA_Hardware/age_group_detector_boolean.xdc` | XDC still contains `sw[5]`, while current RTL declares `sw[4:0]`; update after confirming physical board pinout |
| 10 | Vivado project aligned with current RTL | Blocked | `04_FPGA_Hardware/Vivado_Project/age_group_fsm/` | Archived project source and testbench are still 6-bit; update them to match the 5-bit dedicated RTL/testbench |
| 11 | Fresh FPGA synthesis/implementation and bitstream | Blocked | `04_FPGA_Hardware/Implementation_Reports/`, `04_FPGA_Hardware/Bitstream/` | Existing reports/bitstream are present but must be regenerated after project and XDC alignment |
| 12 | Hardware demonstration completed | Not Started | `04_FPGA_Hardware/` | Physical board testing and direct evidence pending |
| 13 | Results, presentation and final report completed | Not Started | `05_Results/`, `06_Presentation/`, `07_Final_Report/` | Complete using fresh verified simulation and hardware results |
| 14 | Final Pull Request created | Not Started | Pending | Create after final review; base is faculty master repository and faculty-specified branch |
| 15 | Individual contribution roles and supporting artefact links documented | Completed | `README.md` §11 | Kartik: ideation/design; Vedant: Logisim; Arya: testbench/simulation; related repository files are linked. Fresh simulation validation remains pending | Each member should review and confirm their row; retain individual commits/work logs if authorship evidence is requested |

## 2. Time-wise progress log

Update at least once every two hours and at every major milestone. Use actual completion times, evidence paths, blockers and next actions. Do not backdate entries or pre-fill future work.

| Date | Actual time (IST) | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19 Nov 2026 | Time not recorded | Prepared the group submission directory and copied the template/project assets into the faculty-required folder structure | `Group_Submissions/D9A_Group29/` | Documentation and file verification pending at that point | Verify required folders and files | Kaif Bagwan |
| 19 Nov 2026 | Time not recorded | Checked all nine required directories and six key files; local check reported 18 files in Simulation_Results, 12 implementation reports and one bitstream | `Group_Submissions/D9A_Group29/` | Counts represent existing files, not newly run tests | Review README/STATUS and keep evidence claims accurate | Kaif Bagwan |
| 19 Nov 2026 | 22:16–22:18 (repository activity) | Latest GitHub commits updated the age detector RTL/input size and refactored the testbench; the repository now contains dedicated 5-bit RTL and testbench files | `03_Verilog_Implementation/RTL/age_group_detector_core.v`; `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` | Archived Vivado project and XDC do not yet match the 5-bit sources | Update archived project sources/testbench and XDC, then rerun simulation and implementation | Kaif Bagwan |
| 19 Nov 2026 | Time not recorded | Prepared the revised README and STATUS from the current group-repository files, documenting the 5-bit RTL and outstanding Vivado/XDC mismatch | `README.md`, `STATUS.md` | Exact H3 title, roll number for Kaif, and roster confirmation pending | Copy the revised documentation into the group folder and commit/push it | Kaif Bagwan |
| 19 Nov 2026 | Time not recorded — enter actual time when committing | Updated contribution allocation and linked supporting project artefacts: Kartik—ideation/design; Vedant—Logisim; Arya—testbench/simulation. Revised the final checklist to separate completed repository contents from pending verification and final deliverables | `README.md` §11 and §15; linked files under `01_Problem_Analysis/`, `02_FSM_Logisim/`, and `03_Verilog_Implementation/` | Individual authorship is not independently established by the linked group artefacts; fresh 5-bit simulation, Logisim verification and FPGA refresh remain pending | Have members review their contribution rows; copy/commit both revised docs and enter the actual time | Kaif Bagwan |

Add a new row at each major milestone and at least once every two hours while work is active. After copying and committing these files, add a separate log entry with the actual local time of that update.

## 3. Current blockers and support required

| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Kaif's roll number is not recorded | Team details remain incomplete | Confirm from the official roster | No, unless roster information is unavailable |
| Screenshot lists Kartik as D9A roll 36, Vedant as D9B roll 47 and Arya as D9B roll 66, while this is a D9A group | Class/group allocation needs confirmation | Verify against the official faculty group roster | Ask faculty if the roster does not match |
| Exact H3 title and official wording not copied into README | Requirements cannot be finally signed off | Copy the assigned H3 statement from the faculty repository | Only if the statement is unclear |
| Current 5-bit RTL and archived Vivado project are inconsistent | Synthesis/implementation from archived project would not necessarily represent current RTL | Copy the current 5-bit RTL and testbench into the Vivado project's source set and update project files | No, unless project/device configuration needs clarification |
| XDC still constrains `sw[5]`, but current RTL has `sw[4:0]` | Constraint mismatch may cause implementation warnings/errors or an incorrect pin mapping | Verify the actual board pinout and remove/update the obsolete sixth switch constraint as appropriate | Board pinout/faculty help if not available |
| Existing XSim logs are from the archived project snapshot | They do not certify the latest 5-bit testbench | Run a fresh simulation with current RTL and testbench; save logs and waveform | No |
| Collaborator invitations were sent, but acceptance has not been confirmed | Teammates may not yet have write access | Each teammate should accept the invitation | Faculty only if invitation/permission fails |

## 4. End-of-day summary

### 19 November 2026
- **Completed:** Group submission directory prepared; required folder structure checked; existing Logisim, Verilog, testbench, simulation and FPGA files organized; latest dedicated 5-bit RTL and refactored testbench are present in GitHub.
- **In progress:** Final documentation, Logisim circuit verification, FSM diagram and roster confirmation.
- **Pending / blocked:** Fresh simulation using the latest 5-bit RTL/testbench; matching Vivado project update; XDC correction after board pinout verification; regenerated reports/bitstream; physical hardware demonstration; results, presentation and final report.
- **Evidence paths:** `03_Verilog_Implementation/RTL/`, `03_Verilog_Implementation/Testbench/`, `03_Verilog_Implementation/Simulation_Results/`, `04_FPGA_Hardware/`.
- **Next action:** Align the archived Vivado source/testbench and constraints with the current 5-bit implementation, then run a fresh simulation before updating verification results. Have each member confirm the contribution row and keep their individual commits/work log if requested.

## 5. Group leader confirmation

This status is based on repository inspection and the project files currently uploaded. It is an interim progress record, not a declaration that final simulation or hardware verification is complete.

**Group leader:** Kaif Bagwan  
**Date:** 19 November 2026  
**Confirmation:** Pending review of fresh simulation and hardware evidence.
