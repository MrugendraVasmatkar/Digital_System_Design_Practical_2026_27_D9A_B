# Group Progress Status

**Class:** D9A  
**Group ID:** D9A_Group20  
**Project title:** Gaming XP Level Decoder (Moore FSM, modification H3)  
**Group leader:** Parth Amit Joshi

## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `01_Problem_Analysis/Problem_Analysis.md` | 19/11/2026 |
| 2 | Architecture and block diagram prepared | Completed | `01_Problem_Analysis/Problem_Analysis.md`, README Section 4 | 19/11/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | `02_FSM_Logisim/FSM_Design.md` | 19/11/2026 |
| 4 | Logisim circuit implemented | Completed | `02_FSM_Logisim/Gaming_XP_Decoder_H3_simple.circ` | 19/11/2026 |
| 5 | Logisim simulation verified | Completed | `02_FSM_Logisim/logisim_1_idle.png` … `logisim_7_ack_idle.png`, results table in `FSM_Design.md` (7/7 pass) | 19/11/2026 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/gaming_xp_decoder.v` | 19/11/2026 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Simulation_Results/` (Vivado XSim 81/81 pass: Tcl and waveform screenshots; Icarus log) | 19/11/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/reports/` (8 LUT, 24 FF, timing met WNS +7.656 ns, 0 DRC), `gaming_xp_top.bit` | 19/11/2026 |
| 9 | Hardware demonstration completed | Blocked | Board not available; bitstream ready, test steps in `04_FPGA_Hardware/FPGA_Steps.md` | 19/11/2026 |
| 10 | Results, presentation and report uploaded | In Progress | `05_Results/Results_and_Conclusion.md` drafted; presentation and report not uploaded | 19/11/2026 |
| 11 | Final Pull Request created | Not Started | [ ] | [ ] |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 21:30 IST | Added Logisim circuit, RTL and testbench to the repo; ran testbench (81/81 pass, Icarus); wrote problem analysis, FSM design, verification summary, results draft, README | See milestone table | Vivado run, Logisim screenshots, board evidence not yet available | Add Vivado sim screenshots, Logisim screenshots, FPGA evidence; fill README `[TO FILL]` items | Parth Joshi (with Claude's help) |
| 19/11/2026 | 21:47 IST | Re-ran Vivado 2018.3 behavioural simulation: ALL TESTS PASSED (81 checks); saved Tcl console and waveform screenshots | `03_Verilog_Implementation/Simulation_Results/` | None | Constraints file, synthesis, implementation, board demo | Parth Joshi |
| 19/11/2026 | 22:00 IST | Added board top `gaming_xp_top` and Boolean Board constraints; synthesis, implementation and bitstream completed (timing met, 0 DRC violations) | `04_FPGA_Hardware/` | Boolean Board not available for the demo | Program the board and record the demo when available | Parth Joshi |
| 19/11/2026 | 22:58 IST | Found and fixed unconnected inputs on the ACTIVE OR gate in Logisim; ran 7 Logisim tests (IDLE, BEG, hold, INT, EXP, ERR, ACK), all passed; screenshots uploaded | `02_FSM_Logisim/` | None | Upload fixed `.circ`; presentation and report | Parth Joshi |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Boolean Board not available | Milestone 9 (hardware demo) blocked | Bitstream ready; will program and record when a board is available | Access to a lab Boolean Board |

## 4. End-of-day summary
### 19 November 2026
- Completed: problem analysis; FSM design; Logisim circuit and 7 Logisim tests (after fixing the ACTIVE OR gate); Verilog RTL and testbench (Vivado XSim 81/81 pass); board top level and constraints; synthesis, implementation and bitstream for the Boolean Board (timing met, 0 DRC).
- In progress: presentation and final report.
- Pending: hardware demonstration (board not available); final Pull Request.
- Evidence uploaded: `02_FSM_Logisim/`, `03_Verilog_Implementation/`, `04_FPGA_Hardware/`, `05_Results/`.
- Plan: program the board and record the demo when a board is available; upload presentation and report; open the Pull Request.

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Parth Amit Joshi  
**Date/time:** `[Actual date and time at final submission]`
