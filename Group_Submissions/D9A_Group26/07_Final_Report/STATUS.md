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
| 4 | Logisim circuit implemented | Completed | `Group_Submissions/D9A_Group26/02_FSM_Logisim/logidsim_group26.circ`, `logisim_circuit.jpg` | 19/11/2026, 21:55 |
| 5 | Logisim simulation verified | In Progress | `Group_Submissions/D9A_Group26/02_FSM_Logisim/logisim_circuit.jpg` (full 16-input sweep verification scheduled for 20/11/2026) | 19/11/2026, 21:55 |
| 6 | Verilog RTL completed | Completed | `Group_Submissions/D9A_Group26/03_Verilog_Implementation/RTL/gaming_xp.v` | 19/11/2026, 16:15 |
| 7 | Testbench and simulation completed | Completed | `Group_Submissions/D9A_Group26/03_Verilog_Implementation/Simulation_Results/waveforms.png` | 19/11/2026, 16:45 |
| 8 | FPGA synthesis and implementation completed | Completed | `Group_Submissions/D9A_Group26/04_FPGA_Hardware/rtl_schematic.jpeg` (Vivado RTL elaboration) | 19/11/2026, 17:10 |
| 9 | Hardware demonstration completed | Not Started | Physical FPGA deployment omitted per faculty instructions; RTL simulation verified | 19/11/2026, 17:10 |
| 10 | Results, presentation and report uploaded | In Progress | `05_Results/README.md`, `06_Presentation/README.md`, `07_Final_Report/README.md` (final deck and report upload on 20/11/2026) | 19/11/2026, 21:55 |
| 11 | Final Pull Request created | Completed | `https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/18` | 19/11/2026, 17:30 |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 15:15 | Forked master repository (`DSD-2026-D9A-Group26`), set up `D9A_Group26` folder, and documented PS 8 (H4) requirements and I/O specifications | `01_Problem_Analysis/README.md` | None | Define Moore FSM state encoding and transition tables | Krishav Maurya, Iteesha Modanwal |
| 19/11/2026 | 16:00 | Completed Moore FSM tables, wrote synthesizable Verilog RTL (`gaming_xp.v`), and verified self-checking testbench (`tb_gaming_xp.v`) in Vivado 2018.3 | `02_FSM_Logisim/README.md`, `03_Verilog_Implementation/` | None | Generate Vivado RTL schematic and open Pull Request #18 | Krishav Maurya, Shravani Rawool |
| 19/11/2026 | 17:30 | Elaborated RTL schematic on Spartan-7 (`xc7s25csga324-1`: 37 cells, 23 I/O ports, 62 nets) and created Pull Request #18 | `04_FPGA_Hardware/rtl_schematic.jpeg`, PR #18 | None | Complete folder READMEs and wire Logisim circuit | Shravani Rawool, Krishav Maurya |
| 19/11/2026 | 21:55 | Uploaded Logisim circuit (`logidsim_group26.circ`) and schematic capture (`logisim_circuit.jpg`), completed all folder `README.md` files (`01` to `07`), and updated Day 1 progress status | `02_FSM_Logisim/`, `05_Results/README.md`, `06_Presentation/README.md`, `07_Final_Report/STATUS.md` | Full 16-input Logisim sweep and final presentation/report upload pending Day 2 | Run full 16-value Logisim test sweep, upload presentation slides and final report on 20/11/2026 | Krishav Maurya, Dhruv Kadam |

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Full 16-input Logisim simulation sweep and final presentation/report upload scheduled for Day 2 | Milestones 5 and 10 marked `In Progress` at Day 1 cutoff | `.circ` source and schematic uploaded; completing 16-value simulation verification, presentation upload, and final report on Day 2 (`20/11/2026`) | None |

## 4. End-of-day summary
### 19 November 2026 (Day 1)
- Completed: Problem analysis, I/O specifications, Moore FSM state tables, Logisim-evolution circuit (`logidsim_group26.circ` and `logisim_circuit.jpg`), Verilog RTL (`gaming_xp.v`), Vivado behavioral simulation (`waveforms.png`, `tcl.png`), Vivado RTL schematic (`37 Cells`, `23 I/O Ports`, `62 Nets`), expected vs. observed results documentation, and Pull Request #18.
- In progress: Full 16-input (`0–15`) Logisim simulation sweep verification and 5-slide presentation deck (`D9A_Group26_Gaming_XP_Decoder`).
- Pending: Logisim simulation state screenshots, presentation file upload in `06_Presentation/`, and final report document in `07_Final_Report/` (scheduled for `20/11/2026`).
- Evidence uploaded: `D9A_Group26/README.md`, `01_Problem_Analysis/README.md`, `02_FSM_Logisim/` (`README.md`, `logidsim_group26.circ`, `logisim_circuit.jpg`), `03_Verilog_Implementation/` (`README.md`, `gaming_xp.v`, `tb_gaming_xp.v`, `waveforms.png`, `tcl.png`), `04_FPGA_Hardware/` (`README.md`, `rtl_schematic.jpeg`), `05_Results/README.md`, `06_Presentation/README.md`, `07_Final_Report/` (`README.md`, `STATUS.md`).
- Plan for 20 November 2026: Run full 16-value Logisim verification sweep, upload final presentation slides and report document, and prepare all four members for viva voce.

### 20 November 2026 (Day 2)
- Completed: Pending Day 2 execution.
- Pending: Pending Day 2 execution.
- Evidence uploaded: Pending Day 2 execution.
- Final submission status: PR #18 Open and synced on `krishav01-stack:main`.

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Krishav Maurya  
**Date/time:** 19/11/2026, 21:55 IST
