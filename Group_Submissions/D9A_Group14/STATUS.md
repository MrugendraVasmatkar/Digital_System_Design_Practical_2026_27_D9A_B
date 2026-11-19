# Project Status Report — Score-based LED Indicator (Mealy FSM)

> **Purpose:** `STATUS.md` for the Digital System Design Practical and Oral Examination, following `Sample STATUS_Soda_Dispenser_Sample.md`.
> Update this file whenever a task is completed and before each faculty review.

## 1. Group Details

| Item | Details |
|---|---|
| Class | D9A / D9B |
| Group Number | Group 14 (Group ID: D9A_Group14) |
| Project Title | Score-based LED indicator using a Mealy FSM (`mealy_simple`) — title to be confirmed |
| Group Leader | Samruddhi Samant — D9A Roll No. 49 |
| Member 2 | Siddharth Sanjeev Tiwari — D9A Roll No. 58 |
| Member 3 | Deven Shailendra Bhadane — D9B Roll No. 2 |
| Member 4 | Ojas Nitin Kadam — D9B Roll No. 20 |
| Repository | https://github.com/planetsamzz77/DSD-2026-D9A-Group14 |
| Last Updated | 2026-11-19, 19:05 |

## 2. Problem Statement

[Official problem statement title/number to be confirmed.] Design implemented so far: a Mealy FSM that reads a 4-bit `score` when `start` is asserted and lights one LED (low, medium or high). The LED stays on until the user acknowledges with `ack`.

### Operating assumptions

- Score classes: **LOW** for score ≤ 4, **MED** for 5–10, **HIGH** for 11–15.
- Outputs are Mealy: the LED responds in the same cycle that `start` is asserted in `IDLE`, before the state register updates.
- `ack` returns the FSM to `IDLE` and turns the LED off. Synchronous, active-high `reset`.

## 3. Functional Inputs and Outputs

| Signal | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `reset` | Input | Synchronous reset; forces state to `IDLE` |
| `start` | Input | Start a round; captures the class of `score` (only in `IDLE`) |
| `ack` | Input | Acknowledge the result and return to `IDLE` |
| `score[3:0]` | Input | Score value (0–15) |
| `low_led` | Output | On for LOW result |
| `med_led` | Output | On for MED result |
| `high_led` | Output | On for HIGH result |

## 4. Proposed FSM Architecture

Single-module Mealy FSM (`mealy_simple`) with a 2-bit state register and combinational Mealy outputs. There is no separate datapath. Pin assignments are in `04_FPGA_Hardware/constraints.xdc`.

### Proposed FSM states

| State | Function | Main action |
|---|---|---|
| `IDLE` (0) | Wait for `start` | On `start`, classify `score` and go to `LOW`, `MED` or `HIGH`; LED output is already asserted this cycle |
| `LOW` (1) | Show LOW result | `low_led` on while `ack` is low; `ack` returns to `IDLE` |
| `MED` (2) | Show MED result | `med_led` on while `ack` is low; `ack` returns to `IDLE` |
| `HIGH` (3) | Show HIGH result | `high_led` on while `ack` is low; `ack` returns to `IDLE` |

### Datapath registers and operations

| Datapath element | Width | Purpose |
|---|---:|---|
| `state` | 2 bits | Current FSM state |

## 5. Project Stage-wise Progress

Status values: **Not Started**, **In Progress**, **Completed**, or **Needs Correction**.

| Stage | Task / Deliverable | Status | Evidence / Repository Path |
|---|---|---|---|
| 1 — Design | Understand and document the problem statement | In Progress | `01_Problem_Analysis/problem_statement.md` (draft; official statement to be confirmed) |
| 1 — Design | Identify inputs, outputs, and operating conditions | Completed | `01_Problem_Analysis/io_specification.md` |
| 1 — Design | Draw FSM state diagram and state table | Completed | `02_FSM_Logisim/fsm_state_diagram.png`; state table in `README.md` section 5 |
| 1 — Design | Draw block diagram and define control signals | Not Started | `02_FSM_Logisim/` |
| 1 — Design | Build and test the architecture in Logisim | In Progress | `02_FSM_Logisim/Game_Score_Categorizer_H2_Mealy_Machine.circ` (circuit built; overview screenshot `circuit_overview.png` added; simulation screenshots pending) |
| 2 — Verilog | Write synthesizable RTL (controller and datapath) | Completed | `03_Verilog_Implementation/RTL/mealy_simple.v` |
| 2 — Verilog | Integrate modules at top level | Completed | `03_Verilog_Implementation/RTL/mealy_simple.v` (single module) |
| 2 — Verilog | Create testbench and run functional simulation | In Progress | `03_Verilog_Implementation/Testbench/game_tb.v` (written; not yet simulated) |
| 2 — Verilog | Save waveforms and simulation results | Not Started | `03_Verilog_Implementation/Simulation_Results/` |
| 3 — FPGA | Assign FPGA pins and configure constraints | Completed | `04_FPGA_Hardware/constraints.xdc` |
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
| 2026-11-19, 16:10 | Mealy FSM RTL (`mealy_simple.v`), testbench (`game_tb.v`) and FPGA constraints (`constraints.xdc`) added; simulation and hardware tests not yet run | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 16:30 | Logisim circuit `Game_Score_Categorizer_H2_Mealy_Machine.circ` added (2 D flip-flops, gate-level logic, 3 LEDs); simulation screenshots pending | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 16:45 | Problem analysis added: `problem_statement.md` (assumptions, edge cases, solution) and `io_specification.md` (signals, widths, pins) | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 17:00 | Logisim circuit overview screenshot `circuit_overview.png` and `02_FSM_Logisim/README.md` added | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 17:15 | Group README sections 2-5, 7 and 9 filled from the design; FSM state table and state diagram added | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 18:55 | FSM state diagram image `fsm_state_diagram.png` added and linked in README section 5 | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 19:05 | Group number and members 2-4 GitHub usernames recorded in README | Samruddhi Samant | Commit link to be added |

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
| Add members 2–4 as repository collaborators | Usernames recorded in README; send invitations from fork Settings → Collaborators | Samruddhi Samant | [Date] |

## 11. Current Overall Status

- **Current stage:** Stage 2 — Verilog RTL and testbench written; simulation pending
- **Completed:** Repository setup, Mealy FSM RTL, testbench, FPGA pin constraints
- **In progress:** —
- **Pending:** Problem analysis, FSM/Logisim, Verilog RTL and testbench, FPGA implementation, results, presentation, final report
- **Main risk:** [To be filled]
- **Next immediate task:** Run the testbench in a simulator and save the log/waveform; then Logisim, synthesis and bitstream

> **Student declaration:** The information in this status report represents the work completed by our group as of the stated update time. We will keep the repository updated and ensure that all submitted diagrams, code, simulations, and results are our group's own work.
