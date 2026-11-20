# Group Progress Status

**Class:** D9A  
**Group ID:** D9A_Group04  
**Project title:** Game Score Categorizer – H1 Four-Category (Excellent added)  
**Group leader:** Kulkarni Keshavraj Yogesh

## 1. Current milestone status
| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `01_Problem_Analysis/README.md` | 19/11/2026 13:16 |
| 2 | Architecture and block diagram prepared | Completed | `01_Problem_Analysis/block_diagram.png` | 19/11/2026 13:16 |
| 3 | FSM diagram/table completed, if applicable | Completed | `02_FSM_Logisim/FSM_Design.md`, `state_diagram.png` | 19/11/2026 13:16 |
| 4 | Logisim circuit implemented | Completed | `02_FSM_Logisim/Game_Score_Categorizer.circ` | 19/11/2026 14:50 |
| 5 | Logisim simulation verified | Completed | `02_FSM_Logisim/Game_Score_Categorizer.circ` (verified in Logisim Evolution 5.0.0) | 19/11/2026 15:52 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/Game_Score_Categorizer.v` | 19/11/2026 14:07 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/`, `Simulation_Results/` (Vivado 2018.3, 66/66 pass in 1000 ns) | 20/11/2026 09:27 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/` (9 LUTs, 9 FFs; bitstream generated) | 20/11/2026 09:33 |
| 9 | Hardware demonstration completed | Completed | `04_FPGA_Hardware/board_demo/` | 20/11/2026 10:15 |
| 10 | Results, presentation and report uploaded | Completed | `05_Results/`, `06_Presentation/`, `07_Final_Report/` | 20/11/2026 10:30 |
| 11 | Final Pull Request created | Completed | https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/28 | 20/11/2026 10:44 |

## 2. Time-wise progress log
| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | 12:58 | Problem statement received (H1) and studied | – | – | Requirements and FSM | Kulkarni Keshavraj Yogesh |
| 19/11/2026 | 13:16 | Requirements, I/O list, block diagram, FSM diagram, state table, equations | `01_Problem_Analysis/`, `02_FSM_Logisim/` | – | Logisim circuit | Kulkarni Keshavraj Yogesh |
| 19/11/2026 | 13:21 | Logisim circuit (input register, decoder, FSM, LEDs) | `02_FSM_Logisim/` | – | Logisim verification | Kulkarni Keshavraj Yogesh |
| 19/11/2026 | 14:08 | State LEDs removed; Logisim LED labels renamed | all folders | – | Logisim check | Kulkarni Keshavraj Yogesh |
| 19/11/2026 | 14:50 | Range decoder in Logisim changed to 3 comparators (> 4, > 8, > 12); docs, slides and report updated | `02_FSM_Logisim/` | – | Lab: Vivado and board | Kulkarni Keshavraj Yogesh |
| 19/11/2026 | 15:52 | Logisim circuit verified in Logisim Evolution 5.0.0 | `02_FSM_Logisim/Game_Score_Categorizer.circ` | – | Verilog verification in Vivado | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 09:57 | Logisim optimised: input register is one 4-bit Register (Enable = IDLE), output logic is one 3-to-8 Decoder; 43 gates + 7 FFs reduced to 23 gates + 3 FFs; re-verified in Logisim Evolution 5.0.0 | `02_FSM_Logisim/Game_Score_Categorizer.circ` | – | Verilog verification in Vivado | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 10:05 | Names aligned with faculty instructions: group ID D9A_Group04, repo DSD-2026-D9A-Group04; template READMEs added to 06 and 07 | all folders | – | Verilog verification in Vivado | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 09:27 | Vivado 2018.3 behavioural simulation: 66 checks, 66 pass, 0 fail | `03_Verilog_Implementation/Simulation_Results/` | – | Synthesis | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 09:33 | Synthesis, implementation and bitstream; Boolean board programmed | `04_FPGA_Hardware/` | – | Board demonstration | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 10:15 | Board demonstration recorded (category LEDs LD0–LD3) | `04_FPGA_Hardware/board_demo/` | – | Final documentation | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 10:30 | RGB feature dropped (core module used as top with `boolean.xdc`); Logisim screenshots, Vivado evidence, results, report, slides and reflection completed | all folders | – | Final Pull Request | Kulkarni Keshavraj Yogesh |
| 20/11/2026 | 10:44 | Final Pull Request #28 to the faculty repository titled and described | https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/28 | – | Faculty review | Kulkarni Keshavraj Yogesh |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| None | – | – | – |

## 4. End-of-day summary
### 19 November 2026
- Completed: problem analysis, block diagram, FSM design, Logisim circuit (comparator range decoder) verified in Logisim Evolution 5.0.0, Verilog RTL and testbench written
- In progress: presentation and report
- Pending: Vivado simulation, FPGA synthesis and board demonstration
- Evidence uploaded: `01_Problem_Analysis/`, `02_FSM_Logisim/`
- Plan for 20 November: optimise the Logisim circuit, run Vivado in the lab, demonstrate on the Boolean board, complete documentation

### 20 November 2026
- Completed: Logisim optimisation and screenshots, Vivado simulation (66/66 pass), synthesis and implementation (9 LUTs, 9 FFs), board programming and demonstration, results, presentation, report and team reflection
- Pending: faculty review of the Pull Request
- Evidence uploaded: `02_FSM_Logisim/screenshots/`, `03_Verilog_Implementation/Simulation_Results/`, `04_FPGA_Hardware/`
- Final submission status: submitted (Pull Request #28)

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Kulkarni Keshavraj Yogesh  
**Date/time:** 20/11/2026 10:32
