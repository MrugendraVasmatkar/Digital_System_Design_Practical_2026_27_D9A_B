# Group Progress Status

**Class / group:** D9A  
**Group ID:** D9A_Group29  
**Assigned problem statement:** H3 — the preserved project files suggest an age-group FSM / detector; official title and wording still need confirmation  
**Group leader:** Kaif Bagwan (@kaifjbagwan4116-coder)

## 1. Current milestone status

Use only: `Not Started`, `In Progress`, `Completed` or `Blocked`. A file being present does not by itself mean that its simulation or hardware result has been verified.

| No. | Milestone | Status | Evidence path/link | Last updated / notes |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | In Progress | `01_Problem_Analysis/` | H3 official wording and completed requirements analysis still need confirmation |
| 2 | Architecture and block diagram prepared | Not Started | `01_Problem_Analysis/` | Final diagram and explanation pending |
| 3 | FSM diagram/table completed, if applicable | In Progress | `02_FSM_Logisim/DSDlogs.circ` | Logisim source exists; final FSM diagram and state table pending |
| 4 | Logisim circuit implemented | In Progress | `02_FSM_Logisim/DSDlogs.circ` | Circuit file copied; correspondence with final H3 design still to be checked |
| 5 | Logisim simulation verified | Not Started | `02_FSM_Logisim/` | Add actual simulation evidence; no new simulation was run by the setup script |
| 6 | Verilog RTL completed | In Progress | `03_Verilog_Implementation/RTL/age_group_detector_core.v` | Supplied baseline is present and uses a 6-bit input; reconcile with intended final 5-bit implementation |
| 7 | Testbench and test vectors completed | In Progress | `03_Verilog_Implementation/Testbench/tb_age_group_detector.v` | Supplied testbench is present; update and rerun with final RTL |
| 8 | Simulation results and verification summary completed | In Progress | `03_Verilog_Implementation/Simulation_Results/` | Local check found 18 existing artefact files; final 5-bit simulation and pass/fail summary pending |
| 9 | FPGA constraints, reports and bitstream organized | In Progress | `04_FPGA_Hardware/` | XDC present; local check found 12 implementation reports and one bitstream; confirm correspondence to final RTL/device |
| 10 | Hardware demonstration completed | Not Started | `04_FPGA_Hardware/` | Direct evidence from the physical board pending |
| 11 | Results, presentation and final report completed | Not Started | `05_Results/`, `06_Presentation/`, `07_Final_Report/` | Complete using actual test results and evidence |
| 12 | Final Pull Request created | Not Started | Pending | Create after review; base must be the faculty master repository on the faculty-specified branch |

## 2. Time-wise progress log

Update at least once every two hours and at every major milestone. Record actual completion times, evidence paths, blockers and next actions. Do not backdate entries or pre-fill future work.

| Date | Actual time (IST) | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19 Nov 2026 | Time not recorded in terminal | Ran the group-folder preparation script; it reported 145 files in `Group_Submissions/D9A_Group29/` | `Group_Submissions/D9A_Group29/` | Team roll number for Kaif and official H3 wording/title pending | Verify folder structure and required files | Kaif Bagwan |
| 19 Nov 2026 | Time not recorded in terminal | Checked all nine required directories and six key files; local checks found 18 simulation artefacts, 12 implementation reports and one bitstream | `Group_Submissions/D9A_Group29/` | Existing RTL snapshot is 6-bit; intended final version is 5-bit; final simulation/hardware verification pending | Update README/STATUS, then reconcile final RTL and testbench | Kaif Bagwan |
| 19 Nov 2026 | 21:47 | Updated group documentation draft using the supplied team roster screenshot and local folder-check results; files still need to be copied into the local submission folder | `README.md`, `STATUS.md` (downloaded drafts) | Kaif's roll number and official H3 wording/title pending; confirm D9B class details for two members | Replace the group README/STATUS with the updated drafts and verify before staging | Kaif Bagwan |

Add a new row for each meaningful milestone and at least once every two hours while work is in progress. When copying this documentation into the repository, add a fresh entry with the actual copy/commit time.

## 3. Current blockers and support required

| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Kaif's roll number has not been supplied | Team details remain incomplete | Add it after checking the official roster | No, unless roster information is unavailable |
| Screenshot lists Kartik as D9A roll 36, Vedant as D9B roll 47 and Arya as D9B roll 66, while this submission is D9A | Confirm that the section details and group allocation are correct | Check the official group roster before final submission | Only if the roster and assigned group do not match |
| Exact official H3 title and wording are not recorded here | Problem analysis cannot be finalized against the exact statement | Copy the faculty-issued H3 problem statement and validate the design against it | Only if the statement or requirements are unclear |
| Supplied RTL snapshot uses a 6-bit age input | It may not match the latest intended 5-bit implementation | Preserve the supplied baseline; update RTL, testbench and dependent outputs together | No, unless specification needs clarification |
| Physical FPGA board model and pinout need confirmation | XDC and hardware results cannot yet be certified | Verify the actual board, FPGA part and pin mapping | Yes, if board documentation/pinout is unavailable |
| Collaborator invitations have been sent; acceptance is not confirmed | Other members may not yet have repository write access | Each member must accept the GitHub invitation | Faculty help only if invitations cannot be accepted |

## 4. End-of-day summary

### 19 November 2026
- **Completed:** Prepared `Group_Submissions/D9A_Group29/`; setup script reported 145 files; verified all nine required directories and six key files; local evidence checks found 18 simulation artefacts, 12 implementation reports and one bitstream.
- **In progress:** Completing group documentation, checking member roster details and reconciling supplied project files with the final H3 implementation.
- **Pending:** Kaif's roll number, confirmation of D9B section details for two members, exact H3 wording/title, final 5-bit RTL and matching testbench, final simulation rerun, board/pinout confirmation, hardware evidence, final results, presentation and report.
- **Evidence currently organized locally:** Project assets are under `Group_Submissions/D9A_Group29/`. The local Git changes have not yet been committed or pushed.
- **Next action:** Copy the updated README and STATUS into the group folder, review the staged changes, then commit and push to the group fork.

## 5. Group leader confirmation

This is an initial progress record based on the setup-script output and the folder/file checks supplied by the group leader. Final confirmation should be added after reviewing the complete contents and verifying that evidence matches the final design.

**Group leader:** Kaif Bagwan  
**Date:** 19 November 2026  
**Confirmation:** Pending final review
