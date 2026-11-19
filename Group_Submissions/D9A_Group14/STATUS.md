# Project Status Report — [Project Title: to be filled once problem statement is confirmed]

> **Purpose:** `STATUS.md` for the Digital System Design Practical and Oral Examination, following `Sample STATUS_Soda_Dispenser_Sample.md`.
> Update this file whenever a task is completed and before each faculty review.

## 1. Group Details

| Item | Details |
|---|---|
| Class | D9A / D9B |
| Group Number | Group 14 (Group ID: D9A_Group14) |
| Project Title | [To be filled] |
| Group Leader | Samruddhi Samant — D9A Roll No. 49 |
| Member 2 | Siddharth Sanjeev Tiwari — D9A Roll No. 58 |
| Member 3 | Deven Shailendra Bhadane — D9B Roll No. 2 |
| Member 4 | Ojas Nitin Kadam — D9B Roll No. 20 |
| Repository | https://github.com/planetsamzz77/DSD-2026-D9A-Group14 |
| Last Updated | 2026-11-19, 15:53 |

## 2. Problem Statement

[To be filled: summary of the assigned problem statement in the group's own words.]

### Operating assumptions

- [To be filled]

## 3. Functional Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `reset` | Input | Resets the controller and datapath |
| [To be filled] | | |

## 4. Proposed FSM Architecture

[To be filled: FSM controller / datapath split, states, transitions, datapath registers and operations, and clock-cycle timing notes.]

### Proposed FSM states

| State | Function | Main action |
|---|---|---|
| [To be filled] | | |

### Datapath registers and operations

| Datapath element | Width | Purpose |
|---|---:|---|
| [To be filled] | | |

## 5. Project Stage-wise Progress

Status values: **Not Started**, **In Progress**, **Completed**, or **Needs Correction**.

| Stage | Task / Deliverable | Status | Evidence / Repository Path |
|---|---|---|---|
| 1 — Design | Understand and document the problem statement | Not Started | `01_Problem_Analysis/` |
| 1 — Design | Identify inputs, outputs, and operating conditions | Not Started | `01_Problem_Analysis/` |
| 1 — Design | Draw FSM state diagram and state table | Not Started | `02_FSM_Logisim/` |
| 1 — Design | Draw block diagram and define control signals | Not Started | `02_FSM_Logisim/` |
| 1 — Design | Build and test the architecture in Logisim | Not Started | `02_FSM_Logisim/` |
| 2 — Verilog | Write synthesizable RTL (controller and datapath) | Not Started | `03_Verilog_Implementation/RTL/` |
| 2 — Verilog | Integrate modules at top level | Not Started | `03_Verilog_Implementation/RTL/` |
| 2 — Verilog | Create testbench and run functional simulation | Not Started | `03_Verilog_Implementation/Testbench/` |
| 2 — Verilog | Save waveforms and simulation results | Not Started | `03_Verilog_Implementation/Simulation_Results/` |
| 3 — FPGA | Assign FPGA pins and configure constraints | Not Started | `04_FPGA_Hardware/` |
| 3 — FPGA | Synthesize, implement, and generate bitstream | Not Started | `04_FPGA_Hardware/` |
| 3 — FPGA | Demonstrate the design on FPGA hardware | Not Started | `04_FPGA_Hardware/` |
| 3 — Results | Record observations and verify expected behaviour | Not Started | `05_Results/` |
| 3 — Presentation | Prepare slides (max 3, excluding title) and demonstration | Not Started | `06_Presentation/` |
| 3 — Submission | Complete final report and checklist | Not Started | `07_Final_Report/` |

## 6. Functional Test Plan

Test in Logisim and in the Verilog testbench. Add the actual observed result and evidence link after testing.

| Test No. | Input / Action | Expected Result | Actual Result | Status |
|---:|---|---|---|---|
| 1 | Reset the system | FSM enters its initial state; registers cleared | Pending | Not Tested |
| 2 | [To be filled] | | Pending | Not Tested |

## 7. Progress Log

Record work completed by the group. Add a new row for every meaningful update.

| Date and Time | Work Completed / Issue Found | Member(s) Responsible | Evidence / Commit Link |
|---|---|---|---|
| 2026-11-19, 15:53 | Group repository set up: fork renamed to `DSD-2026-D9A-Group14`, group folder `D9A_Group14` created from template, team details added | Samruddhi Samant | Commit link to be added |

## 8. Individual Contributions

| Member | Assigned Responsibility | Work Actually Completed | Evidence / Commit Link |
|---|---|---|---|
| Samruddhi Samant | To be assigned | To be updated | Add link |
| Siddharth Sanjeev Tiwari | To be assigned | To be updated | Add link |
| Deven Shailendra Bhadane | To be assigned | To be updated | Add link |
| Ojas Nitin Kadam | To be assigned | To be updated | Add link |

All members must understand the complete design and be prepared to explain the FSM, datapath, Verilog code, simulation, and hardware demonstration during the oral examination. Assigned roles do not limit individual responsibility for understanding the project.

## 9. Faculty Review Checkpoints

| Review | Planned Time | Items to Demonstrate | Faculty Remarks / Action Items |
|---|---|---|---|
| Review 1 | 19 October 2026 — Afternoon | Problem understanding, FSM architecture, datapath, Logisim progress, GitHub updates | To be filled by faculty |
| Review 2 | 20 October 2026 — Morning | Verilog implementation, simulation evidence, FPGA progress, individual understanding | To be filled by faculty |

**At each review, the group should:**

- Open the latest version of the repository.
- Demonstrate the work completed since the previous update.
- Explain any incomplete task and the plan to finish it.
- Show relevant diagrams, source files, waveforms, results, or hardware.
- Ensure that each member can explain their contribution and answer questions.

## 10. Current Issues and Action Plan

| Issue / Pending Work | Planned Corrective Action | Responsible Member | Target Completion |
|---|---|---|---|
| Confirm assigned problem statement and project title | Check `Problem_Statements/` / ask faculty; update this file | Samruddhi Samant | [Date] |
| Collect GitHub usernames of members 2–4 | Add them to `README.md` and as repository collaborators | Samruddhi Samant | [Date] |

## 11. Current Overall Status

- **Current stage:** Not started — repository setup done
- **Completed:** Repository fork, group folder and team details
- **In progress:** —
- **Pending:** Problem analysis, FSM/Logisim, Verilog RTL and testbench, FPGA implementation, results, presentation, final report
- **Main risk:** [To be filled]
- **Next immediate task:** Confirm the problem statement, then start Stage 1 analysis

> **Student declaration:** The information in this status report represents the work completed by our group as of the stated update time. We will keep the repository updated and ensure that all submitted diagrams, code, simulations, and results are our group's own work.
