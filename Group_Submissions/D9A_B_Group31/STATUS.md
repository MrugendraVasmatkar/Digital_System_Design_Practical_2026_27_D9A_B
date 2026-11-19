# Group Progress Status

**Class:** D9A/D9B  
**Group ID:** D9A_B_Group31  
**Project title:** Weather Alert System (7H3)  
**Group leader:** Aditya Parab

## 1. Current milestone status

Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `README.md` (Sections 2–3) | 19/11/2026 |
| 2 | Architecture and block diagram prepared | Completed | `01_Problem_Analysis/system_block_diagram.png`, `README.md` (Section 4) | 19/11/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | `02_FSM_Logisim/moore_fsm_state_diagram.png`, `README.md` (Section 5) | 19/11/2026 |
| 4 | Logisim circuit implemented | Completed | `02_FSM_Logisim/DSD_FINAL_PRACTICAL (2).circ` | 19/11/2026 |
| 5 | Logisim simulation verified | Completed | `02_FSM_Logisim/logisim_sim_*.jpg` | 19/11/2026 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/weather_alert_system.v` (Vivado 2018.3) | 19/11/2026 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/tb_weather_alert_system.v`, `03_Verilog_Implementation/Simulation_Results/vivado_simulation_waveform.jpg`, `vivado_tcl_console.jpg` | 19/11/2026 |
| 8 | FPGA synthesis and implementation completed | In Progress | Vivado 2018.3 synthesis completed (`6` LUTs, `7` FFs, `0` latches); implementation pending | 19/11/2026 |
| 9 | Hardware demonstration completed | Not Started | [ ] | 19/11/2026 |
| 10 | Results, presentation and report uploaded | In Progress | `README.md` (Sections 1–7 completed); Sections 8–15 and slides pending | 19/11/2026 |
| 11 | Final Pull Request created | In Progress | [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10) (Open, 23 commits, no conflicts; Day 2 updates pending) | 19/11/2026 |

## 2. Time-wise progress log

Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 14:15 | Analyzed problem statement 7H3 (Hint H3 `ERROR` state for `w > 7`), expanded datapath to 4-bit input and 3-bit state register, and drafted initial Verilog simulation in Vivado. | `README.md` (Sections 2–3) | 3-bit input could not represent `> 7`; needed 4-bit unsigned bus. | Build and debug complete datapath and FSM in Logisim. | Aditya Parab |
| 19/11/2026 | 15:35 | Implemented full Logisim v26 circuit; resolved signed vs. unsigned comparator bug and replaced 6 comparators + logic gates with 3 unsigned `>` comparators (`0x2, 0x5, 0x7`) + Priority Encoder. Verified all 5 states (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`) and `START`/`ACK`/`RST`. | `Group_Submissions/D9A_B_Group31/02_FSM_Logisim/`, Logisim state screenshots | Initial 6-comparator wiring missed `=` boundaries and shifted `Pri` pins. | Finalize matching Verilog RTL, testbench, and synthesis in Vivado 2018.3. | Aditya Parab |
| 19/11/2026 | 19:35 | Completed final Verilog RTL (`weather_alert_system.v`) and behavioral testbench (`tb_weather_alert_system.v`) in Vivado 2018.3 matching Logisim's asynchronous reset and dual-register structure. Verified waveform across all categories and ran synthesis (`6` LUTs, `7` FFs, `0` latches). | `03_Verilog_Implementation/RTL/weather_alert_system.v`, `03_Verilog_Implementation/Testbench/tb_weather_alert_system.v`, Vivado schematic/utilization/waveform | None | Prepare Moore FSM & Block diagrams and document Sections 1–7 in `README.md`. | Aditya Parab |
| 19/11/2026 | 21:45 | Finalized System Block Diagram, Moore FSM State Diagram, `README.md` (Sections 1–7), and initial `STATUS.md` milestones and Day 1 log. | `README.md`, `STATUS.md`, Block & FSM diagrams | Need to organize and upload all evidence assets to repo. | Upload cleaned-up circuit, diagrams, and evidence files to fork and verify PR `#10`. | Aditya Parab |
| 19/11/2026 | 22:48 | Cleaned up outdated Logisim/diagram files in `Group_Submissions/D9A_B_Group31/`, uploaded updated project assets, and verified all 23 commits are synced cleanly into Open PR `#10` with zero merge conflicts. | [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10), `Group_Submissions/D9A_B_Group31/` | FPGA board testing and `README.md` Sections 8–15 scheduled for Day 2. | Link final image paths in `README.md`, complete Sections 8–15, finish FPGA implementation/demo, and finalize PR `#10` on Day 2. | Aditya Parab |
| 20/11/2026 | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |
| 20/11/2026 | [ ] | [ ] | [ ] | [ ] | [ ] | [ ] |

Add rows as needed.

## 3. Current blockers and support required

| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| FPGA board pin constraints (`.xdc`) and hardware testing pending | Delays completion of Milestones 8 (implementation) and 9 (hardware demo) | Synthesis (`synth_1`) already verified in Vivado 2018.3; preparing constraints and lab test checklist | Confirm target FPGA board availability for hardware demonstration |
| Relative image links in `README.md` Sections 4–8 | None (Resolved) | Verified and wired all relative paths to assets in `01_Problem_Analysis`, `02_FSM_Logisim`, and `03_Verilog_Implementation` | None |

## 4. End-of-day summary

### 19 November 2026

- **Completed:** Problem statement analysis and assumptions (7H3), System Block Diagram, 5-state Moore FSM Diagram and state tables, Logisim v26 schematic and full 5-state interactive verification (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`), final Verilog RTL (`weather_alert_system.v`), behavioral testbench (`tb_weather_alert_system.v`), Vivado 2018.3 behavioral waveform verification and RTL synthesis (`6` Slice LUTs, `7` Flip-Flops, `0` latches), `README.md` Sections 1–7, and Day 1 repository cleanup and sync to Open PR `#10` (23 commits, no merge conflicts).
- **In progress:** Linking final relative image/evidence paths in `README.md`, drafting `README.md` Sections 8–15, and preparing for FPGA implementation.
- **Pending:** FPGA pin constraints, bitstream implementation, and hardware demonstration (Milestones 8–9), final presentation slides and report (Milestone 10), and finalizing PR `#10` after Day 2 updates (Milestone 11).
- **Evidence uploaded:** `README.md` (Sections 1–7), `STATUS.md`, `weather_alert_system.v`, `tb_weather_alert_system.v`, Logisim v26 files under `Group_Submissions/D9A_B_Group31/02_FSM_Logisim/`, Block & FSM diagrams, Logisim 5-state screenshots, and Vivado synthesis/waveform screenshots (all synced via PR `#10`).
- **Plan for 20 November:** Update relative image paths in `README.md`, complete `README.md` Sections 8–15 (verification table, challenges, task allocation, conclusion, team reflection), complete FPGA implementation/hardware demo, upload presentation/report, and mark PR `#10` complete for final review.

### 20 November 2026

- Completed:
- Pending:
- Evidence uploaded:
- Final submission status:

## 5. Group leader confirmation

I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Aditya Parab  
**Date/time:** 19/11/2026, 22:48 IST