# Project Status Report — Game Score Categorizer (Mealy FSM)

> **Purpose:** `STATUS.md` for the Digital System Design Practical and Oral Examination, following `Sample STATUS_Soda_Dispenser_Sample.md`.
> Update this file whenever a task is completed and before each faculty review.

## 1. Group Details

| Item | Details |
|---|---|
| Class | D9A / D9B |
| Group Number | Group 14 (Group ID: day1_submission_grp14) |
| Project Title | Game Score Categorizer (Mealy FSM) - Problem statement 3H2 |
| Group Leader | Samruddhi Samant — D9A Roll No. 49 |
| Member 2 | Siddharth Sanjeev Tiwari — D9A Roll No. 58 |
| Member 3 | Deven Shailendra Bhadane — D9B Roll No. 2 |
| Member 4 | Ojas Nitin Kadam — D9B Roll No. 20 |
| Repository | https://github.com/planetsamzz77/DSD-2026-D9A-Group14 |
| Last Updated | 2026-11-20, 06:00 |

## 2. Problem Statement

Problem statement 3H2: Game Score Categorizer, hint H2 (Mealy FSM with immediate output). Design implemented so far: a Mealy FSM that reads a 4-bit `score` when `start` is asserted and lights one LED (low, medium or high). The LED stays on until the user acknowledges with `ack`.

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
| 1 — Design | Understand and document the problem statement | Completed | `01_Problem_Analysis/problem_statement.md` (assigned statement 3H2, hint H2, transcribed; photo `assigned_problem_statement_3H2.png`) |
| 1 — Design | Identify inputs, outputs, and operating conditions | Completed | `01_Problem_Analysis/io_specification.md` |
| 1 — Design | Draw FSM state diagram and state table | Completed | `02_FSM_Logisim/fsm_state_diagram.png`; state table in `README.md` section 5 |
| 1 — Design | Draw block diagram and define control signals | Completed | `02_FSM_Logisim/block_diagram.png` |
| 1 — Design | Build and test the architecture in Logisim | In Progress | `02_FSM_Logisim/Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` (final circuit built; overview screenshot added; Logisim simulation screenshots for scores 3 (LOW), 5 (MEDIUM), 13 (HIGH) and IDLE added (`low.png`, `medium.png`, `high.png`, `idle.png`); ACK, RESET and other scores still pending) |
| 2 — Verilog | Write synthesizable RTL (controller and datapath) | Completed | `03_Verilog_Implementation/RTL/mealy_simple.v` |
| 2 — Verilog | Integrate modules at top level | Completed | `03_Verilog_Implementation/RTL/mealy_simple.v` (single module) |
| 2 — Verilog | Create testbench and run functional simulation | Completed | `03_Verilog_Implementation/Testbench/game_tb.v`; waveform in `Simulation_Results/` |
| 2 — Verilog | Save waveforms and simulation results | In Progress | `03_Verilog_Implementation/Simulation_Results/behavioral_simulation_waveform.png` (console log pending) |
| 3 — FPGA | Assign FPGA pins and configure constraints | Completed | `04_FPGA_Hardware/constraints.xdc` |
| 3 — FPGA | Synthesize, implement, and generate bitstream | Completed | `04_FPGA_Hardware/implemented_design.png`, `04_FPGA_Hardware/utilization_report.png` (timing met with a 10 ns clock constraint) |
| 3 — FPGA | Demonstrate the design on FPGA hardware | Not Started | `04_FPGA_Hardware/` |
| 3 — Results | Record observations and verify expected behaviour | In Progress | `05_Results/README.md` (simulation results recorded; hardware results pending) |
| 3 — Presentation | Prepare slides (title + 4 content slides per guidelines) and demonstration | In Progress | `06_Presentation/Group14_DSD_Presentation.pptx` (draft; hardware demo and real challenges still to fill) |
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
| 2026-11-19, 19:20 | FPGA device recorded in README section 9: Spartan-7 XC7S50-CSGA324-1 | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 19:35 | Pull Request opened to faculty repo: https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/33 | Samruddhi Samant | PR 33 |
| 2026-11-19, 20:00 | Group ID renamed to `day1_submission_grp14` (folder renamed from D9A_Group14); project topic confirmed as Game Score Categorizer (Mealy FSM) | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 20:20 | Vivado 2018.3 synthesized-design screenshot added (later removed from the repo); pins match constraints; bitstream generation shown complete | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 20:45 | Vivado elaborated RTL schematic added (`03_Verilog_Implementation/rtl_elaborated_schematic.png`) and linked in README section 7 | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 21:00 | RESET=1 (from any state) arrow added to the FSM state diagram | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 21:30 | Vivado behavioral simulation run; waveform `behavioral_simulation_waveform.png` added (scores 2, 7, 13 give LOW, MEDIUM, HIGH LED; LEDs off after ack); README section 8 updated | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 22:00 | Vivado implemented design screenshot added (`04_FPGA_Hardware/implemented_design.png`); README section 9 updated | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 22:20 | Vivado utilization report added (`04_FPGA_Hardware/utilization_report.png`); README section 9 updated | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 22:40 | Vivado power report added (`04_FPGA_Hardware/power_report.png`); README section 9 updated | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 23:00 | Vivado timing summary added (`04_FPGA_Hardware/timing_summary.png`); design is unconstrained, create_clock still to be added | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 23:15 | Synthesized-design screenshot removed from the repo (implemented design, utilization, power and timing screenshots remain) | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 23:40 | Block diagram added (`02_FSM_Logisim/block_diagram.png`) and described in README section 4 | Samruddhi Samant | Commit link to be added |
| 2026-11-19, 23:59 | Draft presentation added (`06_Presentation/Group14_DSD_Presentation.pptx`): title slide + 4 content slides | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 00:10 | Presentation updated with VESIT college logo, college name and department (Electronics and Telecommunication) | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 00:30 | Individual contributions recorded in README section 11, STATUS section 8 and presentation slide 5 | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 00:50 | University logo added to the presentation title slide | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 01:10 | Problem statement number 3H2 recorded in README, problem analysis, STATUS and presentation | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 01:40 | Results added: `05_Results/README.md` (expected vs observed, requirements, measured results, limitations, conclusion) and README section 13 | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 02:00 | Logisim comparator-version screenshot added (`02_FSM_Logisim/circuit_overview_v2_comparators.png`); matching .circ still to be uploaded | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 02:30 | Updated Logisim circuit `Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` uploaded as the final version (matches the comparator screenshot) | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 03:00 | Assigned statement 3H2 (hint H2, Mealy FSM) transcribed into the problem analysis with a requirement mapping; photo of the handout added | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 03:30 | Clock constraint (create_clock 10 ns) added to constraints; bitstream regenerated; screenshots `constraints_with_clock.png` and `bitstream_generation_completed.png` added; refreshed timing report still pending | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 04:00 | Logisim simulation screenshot added (`02_FSM_Logisim/sim_score13_high.png`, SCORE = 13 gives HIGH LED); other scores, ACK and RESET pending | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 04:30 | Constrained timing run: WNS 7.665 ns, WHS 0.540 ns, 0 failing endpoints, all constraints met; `timing_summary.png` replaced | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 05:00 | Siddharth (Siddharthqzz29), Deven (DevenBhadane) and Ojas (OjasKadam07) added as collaborators on the group repository and accepted | Samruddhi Samant | Repository settings |
| 2026-11-20, 05:30 | Self-checking testbench `game_tb_full.v` written (not yet simulated) and Logisim test plan `logisim_test_plan.md` added | Samruddhi Samant | Commit link to be added |
| 2026-11-20, 06:00 | Siddharth (Siddharthqzz29) and Deven (DevenBhadane) committed Logisim simulation screenshots (low, medium, high, idle) from their own accounts; duplicate root-level .circ upload removed (identical to the v2 file in 02_FSM_Logisim) | Siddharth Sanjeev Tiwari, Deven Shailendra Bhadane | commits 84c8655, fcfda1c |

## 8. Individual Contributions

| Member | Assigned Responsibility | Work Actually Completed | Evidence / Commit Link |
|---|---|---|---|
| Samruddhi Samant | Verilog source code, testbench, FPGA constraints, bitstream, presentation, FSM state diagram | Done (see README section 11) | `03_Verilog_Implementation/`, `04_FPGA_Hardware/`, `06_Presentation/`, `02_FSM_Logisim/fsm_state_diagram.png` |
| Siddharth Sanjeev Tiwari | Logisim design and simulation | Done | `02_FSM_Logisim/Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` |
| Deven Shailendra Bhadane | Logisim design and simulation | Done | `02_FSM_Logisim/Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` |
| Ojas Nitin Kadam | Verilog source code and testbench | Done | `03_Verilog_Implementation/RTL/`, `03_Verilog_Implementation/Testbench/` |

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
| Testbench must cover all 16 scores, all four FSM states, reset and START/ACK, and be self-checking with PASS/FAIL messages (Q3 of the statement) | `Testbench/game_tb_full.v` is written; run it in Vivado (top `game_tb_full`) and save the log and waveform in `Simulation_Results/` | Ojas Nitin Kadam / Samruddhi Samant | [Date] |
| Logisim must be verified for all 16 inputs (Q1 of the statement) | Follow `02_FSM_Logisim/logisim_test_plan.md`: simulate scores 0-15, ACK and RESET in the v2 circuit and capture screenshots | Siddharth Sanjeev Tiwari / Deven Shailendra Bhadane | [Date] |
| Statement lists a 4-bit input register loaded by START; the design has none | Check with faculty whether it is required, or document why the design samples the score directly | Samruddhi Samant | [Date] |

## 11. Current Overall Status

- **Current stage:** Stage 2 — Verilog RTL and testbench written; simulation pending
- **Completed:** Repository setup, Mealy FSM RTL, testbench, FPGA pin constraints
- **In progress:** —
- **Pending:** Problem analysis, FSM/Logisim, Verilog RTL and testbench, FPGA implementation, results, presentation, final report
- **Main risk:** [To be filled]
- **Next immediate task:** Run the testbench in a simulator and save the log/waveform; then Logisim, synthesis and bitstream

> **Student declaration:** The information in this status report represents the work completed by our group as of the stated update time. We will keep the repository updated and ensure that all submitted diagrams, code, simulations, and results are our group's own work.
