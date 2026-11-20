# Group Progress Status

**Class:** D9A and D9B
**Group ID:** D9A_B_Group03
**Project title:** FORBIDDEN ZONE REJECTOR  
**Group leader:** Ankita karmakar
## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | [README.md](./README.md) | 19/10/2026 |
| 2 | Architecture and block diagram prepared | Completed | [Block diagram](./02_FSM_Logisim/Architecture_BlockDiagram.jpeg) | 19/10/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | [FSM](./02_FSM_Logisim/FSM.jpg) | 19/11/2026 |
| 4 | Logisim circuit implemented | Completed | [Evidence](./02_FSM_Logisim/logisim_circ_Forbidden_Zone_Rejector_updated.circ) | 19/10/2026 |
| 5 | Logisim simulation verified | Completed | [Evidence](./02_FSM_Logisim/Logisim_circuit.png) | 19/10/2026 |
| 6 | Verilog RTL completed | Completed | [RTL](./03_Verilog_Implementation/RTL/) | 20/11/2026 |
| 7 | Testbench and simulation completed | Completed | [Testbench](./03_Verilog_Implementation/Testbench) | 20/11/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | [Implementation](./03_Verilog_Implementation/Simulation_Result) [Constraint](Group_Submissions/D9A_B_Group03/03_Verilog_Implementation/xdc_constraint_file) | 20/11/2026 |
| 9 | Hardware demonstration completed | Completed | [Hardware Implementation Video](./04_FPGA_Hardware) | 20/11/2026 |
| 10 | Results, presentation and report uploaded | Completed | [Results](./D9A_B_Group03/05_Results) | 20/11/2026 |
| 11 | Final Pull Request created | Not Started | [ ] | [ ] |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/10/2026 | 11:30 am| Problem analysis and architecture done | [README.md](./README.md) | None | Build Logisim circuit | Chaitanya Jadhav |
| 19/10/2026 | 2:00 pm | Logisim circuit built (ripple counter, 2 comparators, OR/NAND) | [Evidence](./02_FSM_Logisim/Logisim_circuit.png) | Comparator wiring | Fix wiring, verify 0–15 | Chaitanya Jadhav |
| 19/10/2026 | 2:00 pm | Logisim simulation verified for range 6–9 | [Evidence](./02_FSM_Logisim/Logisim_circuit.png) | None | Start Verilog RTL | Ankita karmakar |
| 16/11/2026 | 12:30 pm | COUNTER.v created | [RTL](./03_Verilog_Implementation/RTL) | None | Write comparator and top module | Manas Narkar |
| 20/11/2026 | 12:30 pm | COMPARATOR.v and fz_rejector.v (Moore FSM, parameters N, L, H) written | [RTL](./03_Verilog_Implementation/RTL) | None | Write testbench | Manas Narkar |
| 20/11/2026 | 12:30 pm | tb_fz_rejector.v written, simulated ranges [6,9], [4,7], [8,11], all checks passed | [Testbench](./03_Verilog_Implementation/Testbench) | None | Results doc, then FPGA | Ankita karmakar |
| 20/11/2026 | 2:00 pm | FPGA synthesis, implementation and hardware test done | [Hardware Implementation Video](./04_FPGA_Hardware)  | None | Presentation, report, final Pull Request | Vidyesh Raut |

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
- Evidence uploaded: [Presentation](./08Presentation) [Report](./07_Final_Report)
- Final submission status: Completed

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Ankita Karmakar 
**Date/time:** 20 November 2026 / 3:30 pm
