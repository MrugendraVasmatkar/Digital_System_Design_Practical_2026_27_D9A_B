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
| 2 | Architecture and block diagram prepared | Completed | `Group_Submissions/D9A_B_Group31/` (Block diagram), `README.md` (Section 4) | 19/11/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | `Group_Submissions/D9A_B_Group31/` (Moore FSM diagram), `README.md` (Section 5) | 19/11/2026 |
| 4 | Logisim circuit implemented | Completed | `Group_Submissions/D9A_B_Group31/02_FSM_Logisim/` (Logisim v26 circuit & schematic PDF — Harika, Siddharth, Shravan) | 19/11/2026 |
| 5 | Logisim simulation verified | Completed | Logisim state screenshots (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`) | 19/11/2026 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/weather_alert_system.v` (Vivado 2018.3 — Harika, Siddharth) | 19/11/2026 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/tb_weather_alert_system.v`, Vivado waveform (`README.md` Section 8) | 20/11/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/` (`.xdc` constraints file, `.bit` bitstream generated in Vivado 2018.3; `6` LUTs, `7` FFs, `0` latches) | 20/11/2026 |
| 9 | Hardware demonstration completed | Completed | Live Spartan-7 Boolean Board verification (`DONE` LED ON; `SW0–SW3`, `BTN0–BTN2`, and `LD0–LD4` verified including `IDLE` on `LD0` and `ERROR` on `LD4`); evidence in PPT & [Google Drive Folder](https://drive.google.com/drive/folders/1Xcc0Mg-2GSt6F4gS0qtcCkv1bvgAitn9?usp=sharing) | 20/11/2026 |
| 10 | Results, presentation and report uploaded | Completed | `README.md` (Sections 1–15), Final Project Report PDF (`Final_Project_Report_7H3_D9A_B_Group31.pdf`), 3-slide Presentation PPT (with FPGA Error state photo & Drive link), and [Google Drive Folder](https://drive.google.com/drive/folders/1Xcc0Mg-2GSt6F4gS0qtcCkv1bvgAitn9?usp=sharing) | 20/11/2026 |
| 11 | Final Pull Request created | Completed | [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10) (All final deliverables submitted and synced, zero merge conflicts) | 20/11/2026 |

## 2. Time-wise progress log

Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 14:15 | Full team brainstormed problem statement 7H3 (Hint H3 `ERROR` state for `w > 7`), finalized 4-bit input and 3-bit state register architecture, and drafted initial verification plan. | `README.md` (Sections 2–3) | 3-bit input could not represent `> 7`; needed 4-bit unsigned bus. | Build and debug complete datapath and FSM in Logisim. | Aditya Parab |
| 19/11/2026 | 15:35 | Implemented full Logisim v26 circuit (Harika, Siddharth, Shravan); resolved signed vs. unsigned comparator bug and replaced 6 comparators + logic gates with 3 unsigned `>` comparators (`0x2, 0x5, 0x7`) + Priority Encoder. Verified all 5 states (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`). | `Group_Submissions/D9A_B_Group31/02_FSM_Logisim/`, Logisim state screenshots | Initial 6-comparator wiring missed `=` boundaries and shifted `Pri` pins. | Finalize matching Verilog RTL, testbench, and synthesis in Vivado 2018.3. | Aditya Parab |
| 19/11/2026 | 19:35 | Completed final Verilog RTL (`weather_alert_system.v`) and behavioral testbench (`tb_weather_alert_system.v`) in Vivado 2018.3 (Harika, Siddharth) matching Logisim's async reset and dual-register structure. Verified waveform and synthesis (`6` LUTs, `7` FFs, `0` latches). | `03_Verilog_Implementation/RTL/weather_alert_system.v`, `03_Verilog_Implementation/Testbench/tb_weather_alert_system.v`, Vivado schematic/utilization/waveform | None | Prepare Moore FSM & Block diagrams and document Sections 1–7 in `README.md`. | Aditya Parab |
| 19/11/2026 | 21:45 | Finalized System Block Diagram, Moore FSM State Diagram, `README.md` (Sections 1–7), and Day 1 `STATUS.md` milestones and log. | `README.md`, `STATUS.md`, Block & FSM diagrams | Need to organize and upload all evidence assets to repo. | Upload cleaned-up circuit, diagrams, and evidence files to fork and verify PR `#10`. | Aditya Parab |
| 19/11/2026 | 22:48 | Cleaned up outdated Logisim/diagram files in `Group_Submissions/D9A_B_Group31/`, uploaded updated project assets, and verified all 23 commits are synced cleanly into Open PR `#10` with zero merge conflicts. | [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10), `Group_Submissions/D9A_B_Group31/` | FPGA board testing and `README.md` Sections 8–15 scheduled for Day 2. | Add `.xdc` constraints, generate bitstream, prepare PPT, and complete remaining documentation. | Aditya Parab |
| 20/11/2026 | 09:38 | Added `.xdc` constraints file and generated FPGA bitstream (`.bit`) in Vivado 2018.3 (Harika, Siddharth); marked Milestone 8 `Completed`; updated `README.md` with PR `#10` URL and Sections 8, 9, and 10. | `04_FPGA_Hardware/` (`.xdc`, `.bit`), `README.md`, `STATUS.md`, [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10) | None | Fill remaining `README.md` sections, finalize PPT, and compile final report PDF. | Aditya Parab |
| 20/11/2026 | 10:11 | Completed `README.md` Sections 11 (individual team contributions), 13 (Final Results & Conclusion), 14 (Team Reflection), and 15 (Checklist); drafted presentation content and compiled full Final Project Report. | `README.md`, `STATUS.md`, Final Project Report | Final PPT and report PDF upload pending. | Upload Final Project Report PDF and PPT, then run live FPGA demo. | Aditya Parab |
| 20/11/2026 | 10:18 | Uploaded Final Project Report PDF and presentation to the repository; updated `README.md` and `STATUS.md`; all deliverables synced cleanly to Open PR `#10` with zero merge conflicts. | `README.md`, `STATUS.md`, Final Project Report PDF, Presentation PPT, [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10) | None | Complete live physical FPGA board demonstration and viva evaluation. | Aditya Parab |
| 20/11/2026 | 14:13 | Completed live hardware demonstration on the RealDigital AMD Xilinx Spartan-7 Boolean Board (verified bitstream deployment with `DONE` LED ON, `SW0–SW3`, `BTN0–BTN2`, and `LD0–LD4` across states including `IDLE` on `LD0` and `ERROR` on `LD4`); finalized 3-slide PPT with FPGA Error state photo and Google Drive project link; completed viva and final submission with all 11 milestones marked `Completed`. | `04_FPGA_Hardware/`, Final 3-Slide PPT, Final Project Report PDF, [Google Drive Folder](https://drive.google.com/drive/folders/1Xcc0Mg-2GSt6F4gS0qtcCkv1bvgAitn9?usp=sharing), [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10) | None | None — all project work and final submissions are complete. | Aditya Parab |

Add rows as needed.

## 3. Current blockers and support required

| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| None | None — all 11 project milestones, live FPGA hardware demonstration, viva, presentation, final report, and GitHub Pull Request submission are complete. | Final `STATUS.md` updated and synced cleanly to PR `#10`. | Ready for final PR `#10` review and merge. |

## 4. End-of-day summary

### 19 November 2026

- **Completed:** Problem statement analysis and assumptions (7H3), System Block Diagram, 5-state Moore FSM Diagram and state tables, Logisim v26 schematic and full 5-state interactive verification (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`), final Verilog RTL (`weather_alert_system.v`), behavioral testbench (`tb_weather_alert_system.v`), Vivado 2018.3 behavioral waveform verification and RTL synthesis (`6` Slice LUTs, `7` Flip-Flops, `0` latches), `README.md` Sections 1–7, and Day 1 repository cleanup and sync to Open PR `#10` (23 commits, no merge conflicts).
- **In progress:** Linking final relative image/evidence paths in `README.md`, drafting `README.md` Sections 8–15, and preparing for FPGA implementation.
- **Pending:** FPGA pin constraints, bitstream implementation, and hardware demonstration (Milestones 8–9), final presentation slides and report (Milestone 10), and finalizing PR `#10` after Day 2 updates (Milestone 11).
- **Evidence uploaded:** `README.md` (Sections 1–7), `STATUS.md`, `weather_alert_system.v`, `tb_weather_alert_system.v`, Logisim v26 files under `Group_Submissions/D9A_B_Group31/02_FSM_Logisim/`, Block & FSM diagrams, Logisim 5-state screenshots, and Vivado synthesis/waveform screenshots (all synced via PR `#10`).
- **Plan for 20 November:** Update relative image paths in `README.md`, complete `README.md` Sections 8–15 (verification table, challenges, task allocation, conclusion, team reflection), complete FPGA implementation/hardware demo, upload presentation/report, and mark PR `#10` complete for final review.

### 20 November 2026

- **Completed (as of 14:13 IST):** Added `.xdc` constraints (`F14` 100 MHz clock, `BTN0–BTN2`, `SW0–SW3`, `LD0–LD4`) and generated the Spartan-7 FPGA bitstream (`.bit`) in Vivado 2018.3; completed live FPGA hardware demonstration on the RealDigital Spartan-7 Boolean Board (verified `IDLE` on `LD0` and `ERROR` on `LD4`); finalized all `README.md` sections (1–15), the comprehensive Final Project Report PDF, and the 3-slide presentation PPT with FPGA hardware evidence and Google Drive folder link; completed viva and synced all final files cleanly to Open PR `#10` with zero merge conflicts (all 11/11 milestones completed).
- **Pending:** None.
- **Evidence uploaded:** `.xdc` constraints file and `.bit` bitstream under `04_FPGA_Hardware/`, live FPGA hardware verification photos, Final Project Report PDF, 3-slide presentation PPT, finalized `README.md`, updated `STATUS.md`, [Google Drive Project Folder](https://drive.google.com/drive/folders/1Xcc0Mg-2GSt6F4gS0qtcCkv1bvgAitn9?usp=sharing), and [PR #10](https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10).
- **Final submission status:** All deliverables submitted and verified (11/11 milestones completed; Open PR `#10` with zero merge conflicts, ready for faculty merge).

## 5. Group leader confirmation

I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Aditya Parab  
**Date/time:** 20/11/2026, 14:13 IST