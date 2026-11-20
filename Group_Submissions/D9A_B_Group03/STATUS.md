# Group Progress Status

**Class:** D9A and D9B
**Group ID:** D9A_B_Group03
**Project title:** FORBIDDEN ZONE REJECTOR  
**Group leader:** Ankita karmakar
## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | [README.md](README.md) | 19/10/2026 |
| 2 | Architecture and block diagram prepared | Completed | [Block diagram](Group_Submissions/D9A_B_Group03/02_FSM_Logisim/Architecture_BlockDiagram.jpeg) | 19/10/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | [README.md](README.md) (Section 5) | 20/11/2026 |
| 4 | Logisim circuit implemented | Completed | [Evidence](Group_Submissions/D9A_B_Group03/02_FSM_Logisim/logisim_circ_Forbidden_Zone_Rejector_updated.circ) | 19/10/2026 |
| 5 | Logisim simulation verified | Completed | [Evidence](Group_Submissions/D9A_B_Group03/02_FSM_Logisim/Logisim_circuit.png) | 19/10/2026 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/` | 20/11/2026 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/` | 20/11/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/` | 20/11/2026 |
| 9 | Hardware demonstration completed | Completed | `04_FPGA_Hardware/` | 20/11/2026 |
| 10 | Results, presentation and report uploaded | In Progress | [Results_and_Analysis.md](Results_and_Analysis.md) | 20/11/2026 |
| 11 | Final Pull Request created | Not Started | [ ] | [ ] |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/10/2026 | 11:30 am| Problem analysis and architecture done | README.md | None | Build Logisim circuit | Ankita karmakar |
| 19/10/2026 | 2:00 pm | Logisim circuit built (ripple counter, 2 comparators, OR/NAND) | Group_Submissions/D9A_B_Group03/02_FSM_Logisim/logisim_circ_Forbidden_Zone_Rejector_updated.circ | Comparator wiring | Fix wiring, verify 0–15 | Ankita karmakar |
| 19/10/2026 | 2:00 pm | Logisim simulation verified for range 6–9 | Group_Submissions/D9A_B_Group03/02_FSM_Logisim/Logisim_circuit.png | None | Start Verilog RTL | Ankita karmakar |
| 16/11/2026 | 12:30 pm | COUNTER.v created | 03_Verilog_Implementation/RTL/ | None | Write comparator and top module | Ankita karmakar |
| 20/11/2026 | 12:30 pm | COMPARATOR.v and fz_rejector.v (Moore FSM, parameters N, L, H) written | 03_Verilog_Implementation/RTL/ | None | Write testbench | Ankita karmakar |
| 20/11/2026 | 12:30 pm | tb_fz_rejector.v written, simulated ranges [6,9], [4,7], [8,11], all checks passed | 03_Verilog_Implementation/Testbench/ | None | Results doc, then FPGA | Ankita karmakar |
| 20/11/2026 | 2:00 pm | FPGA synthesis, implementation and hardware test done | 04_FPGA_Hardware/ | None | Presentation, report, final Pull Request | Ankita karmakar |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| None | None | None | None |

## 4. End-of-day summary
### 19 October 2026
- Completed: Logisim Circuit implemented and simulated
- In progress: Verilog RTL
- Pending: Verilog RTL, testbench, FPGA
- Evidence uploaded: Group_Submissions/D9A_B_Group03/02_FSM_Logisim/logisim_circ_Forbidden_Zone_Rejector_updated.circ
- Plan for 20 October: Verilog RTL & Simulation + Hardware Implemenentation

### 20 November 2026
- Completed: Verilog RTL (COUNTER, COMPARATOR, fz_rejector), testbench for 3 ranges (all passed), FPGA implementation and hardware test, README and Results_and_Analysis.md
- Pending: Presentation and report, final Pull Request
- Evidence uploaded: 03_Verilog_Implementation/RTL/, 03_Verilog_Implementation/Testbench/, 04_FPGA_Hardware/, Results_and_Analysis.md
- Final submission status: In progress

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Ankita Karmakar 
**Date/time:** 20 November 2026 / 3:30 pm
