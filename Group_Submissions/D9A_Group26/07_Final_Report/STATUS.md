# Group Progress Status

**Class:** D9A  
**Group ID:** D9A_Group26  
**Project title:** Gaming XP Level Decoder with Level Counters (Problem Statement 8 - Hint H4)  
**Group leader:** Krishav Maurya

## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `Group_Submissions/D9A_Group26/01_Problem_Analysis/README.md` | 19/11/2026, 15:30 |
| 2 | Architecture and block diagram prepared | Completed | `Group_Submissions/D9A_Group26/01_Problem_Analysis/README.md` | 19/11/2026, 15:30 |
| 3 | FSM diagram/table completed, if applicable | Completed | `Group_Submissions/D9A_Group26/02_FSM_Logisim/README.md` | 19/11/2026, 15:45 |
| 4 | Logisim circuit implemented | In Progress | `Group_Submissions/D9A_Group26/02_FSM_Logisim/` (building `.circ` file) | 19/11/2026, 19:48 |
| 5 | Logisim simulation verified | Not Started | Pending completion of `.circ` wiring | 19/11/2026, 19:48 |
| 6 | Verilog RTL completed | Completed | `Group_Submissions/D9A_Group26/03_Verilog_Implementation/RTL/gaming_xp.v` | 19/11/2026, 16:15 |
| 7 | Testbench and simulation completed | Completed | `Group_Submissions/D9A_Group26/03_Verilog_Implementation/Simulation_Results/waveforms.png` | 19/11/2026, 16:45 |
| 8 | FPGA synthesis and implementation completed | Completed | `Group_Submissions/D9A_Group26/04_FPGA_Hardware/rtl_schematic.jpeg` (Vivado RTL elaboration) | 19/11/2026, 17:10 |
| 9 | Hardware demonstration completed | Not Started | Physical FPGA deployment not required per faculty; RTL verification used | 19/11/2026, 17:10 |
| 10 | Results, presentation and report uploaded | In Progress | `05_Results/README.md`, `06_Presentation/README.md`, `07_Final_Report/README.md` | 19/11/2026, 19:48 |
| 11 | Final Pull Request created | Completed | `https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/18` | 19/11/2026, 17:30 |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 15:15 | Forked master repo (`DSD-2026-D9A-Group26`), created `D9A_Group26` folder, and documented PS 8 (H4) requirements and I/O specifications | `01_Problem_Analysis/README.md` | None | Define Moore FSM state encoding and transition tables | Krishav Maurya, Iteesha Modanwal |
| 19/11/2026 | 16:00 | Completed Moore FSM state tables, wrote synthesizable Verilog RTL (`gaming_xp.v`), and ran self-checking testbench (`tb_gaming_xp.v`) in Vivado 2018.3 | `02_FSM_Logisim/README.md`, `03_Verilog_Implementation/` | None | Generate Vivado RTL schematic and open initial PR | Krishav Maurya, Shravani Rawool |
| 19/11/2026 | 17:30 | Elaborated RTL schematic on Spartan-7 (`xc7s25csga324-1`: 37 cells, 23 I/O ports, 62 nets) and opened Pull Request #18 | `04_FPGA_Hardware/rtl_schematic.jpeg`, PR #18 | None | Complete folder READMEs, expected vs. observed tables, and Logisim circuit | Shravani Rawool, Krishav Maurya |
| 19/11/2026 | 19:48 | Populated group `README.md` and subfolder documentation for `03`, `04`, `05`, `06`, and `07_Final_Report/STATUS.md` | `D9A_Group26/README.md`, `05_Results/README.md`, `07_Final_Report/STATUS.md` | Logisim `.circ` wiring in progress | Finish Logisim `.circ` circuit, upload screenshots and slides before 22:00 deadline | Krishav Maurya, Dhruv Kadam |

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Logisim-evolution `.circ` schematic still being finalized | Milestone 4 and 5 screenshots pending upload before 22:00 deadline | Wiring the 4-bit register, comparators, three 4-bit counters, and Moore FSM in Logisim-evolution | None |

## 4. End-of-day summary
### 19 November 2026 (Day 1)
- Completed: Problem analysis, I/O specifications, Moore FSM state tables, Verilog RTL (`gaming_xp.v`), Vivado behavioral simulation (`waveforms.png`, `tcl.png`), Vivado RTL schematic (`37 Cells`, `23 I/O Ports`, `62 Nets`), results verification tables, and Pull Request #18 creation.
- In progress: Finalizing Logisim-evolution `.circ` file and uploading final presentation slides prior to the 22:00 PR cutoff.
- Pending: Logisim `.circ` simulation screenshots and final report document upload.
- Evidence uploaded: `01_Problem_Analysis/README.md`, `02_FSM_Logisim/README.md`, `03_Verilog_Implementation/` (`gaming_xp.v`, `tb_gaming_xp.v`, `waveforms.png`, `tcl.png`), `04_FPGA_Hardware/rtl_schematic.jpeg`, `05_Results/README.md`, `06_Presentation/README.md`, `07_Final_Report/STATUS.md`.
- Plan for 20 November 2026: Review merged/updated PR #18, verify all links and diagrams, and prepare all four members for oral examination.

### 20 November 2026 (Day 2)
- Completed: Pending Day 2 review.
- Pending: Pending Day 2 review.
- Evidence uploaded: Pending Day 2 review.
- Final submission status: PR #18 Open and updating automatically on `krishav01-stack:main`.

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Krishav Maurya  
**Date/time:** 19/11/2026, 19:48 IST
