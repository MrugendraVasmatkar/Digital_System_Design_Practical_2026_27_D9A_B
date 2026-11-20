# Group Progress Status

**Class:** D9A / D9B (mixed group)  
**Group ID:** Group 28 [use the official format, e.g. D9B_Group28]  
**Project title:** Age Group Detector – Mealy FSM with Immediate Output (H2)  
**Group leader:** Aditi Patwa (D9B, 52)

## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `README.md` §2–3; `01_Design_and_Analysis/problem_statement.jpg`, `h2_task.jpg` | 19/10/2026 |
| 2 | Architecture and block diagram prepared | Completed | `01_Design_and_Analysis/block_diagram.png`, `logisim_block_diagram.png` | 19/10/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | `01_Design_and_Analysis/fsm_state_diagram.png`, `fsm_state_table.pdf` | 19/10/2026 |
| 4 | Logisim circuit implemented | Completed | `02_Logisim_Implementation/Age_Group_Detector_Mealy.circ`, `logisim_circuit.png` | 19/10/2026 |
| 5 | Logisim simulation verified | Completed | `02_Logisim_Implementation/logisim_simulation_teen.png` | 19/10/2026 |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/age_group_mealy.v` | 19/10/2026 |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/tb_age_group_mealy.v`, `Simulation/waveform.jpg` (errors = 0) | 19/10/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | `04_FPGA_Hardware/constraints/age_group_mealy_direct.xdc`, `04_FPGA_Hardware/README.md` | 20/10/2026 |
| 9 | Hardware demonstration completed | Completed | `04_FPGA_Hardware/photos/boolean_board_running.jpg`; video https://youtube.com/shorts/BUKTNVhrPmg?feature=share | 20/10/2026 |
| 10 | Results, presentation and report uploaded | Completed | `05_Results/`, `06_Presentation/`, `07_Final_Report/`, `08_Viva/` | 20/10/2026 |
| 11 | Final Pull Request created | [Not Started / Completed] | [PR URL] | [ ] |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/10/2026 | [hh:mm] | Studied the problem statement and Task H2. Derived the K-map range-decoder equations. Planned the Moore → Mealy conversion: 2 states (IDLE, ACTIVE), E = RESET̄·ACK̄·(START+Q), LED = E·group | `01_Design_and_Analysis/problem_statement.jpg`, `h2_task.jpg` | None | Build the Logisim circuit | [Name] |
| 19/10/2026 | [hh:mm] | Built the Logisim circuit: 5-bit input register (EN = Q̄), 1-bit state register, next-state logic and Mealy output logic. Replaced the K-map gates with 2 unsigned comparators (Age<13, Age<20) | `02_Logisim_Implementation/Age_Group_Detector_Mealy.circ` | Only CHILD shown for every age; LED blinked after ACK | Fix the register appearance; give ACK priority | [Name] |
| 19/10/2026 | [hh:mm] | Fixed the Logisim issues: registers set to the Classic appearance (pins had moved, so the age read as 0), and ACK priority added to the next-state logic (no blinking with START held). Verified boundary ages 0, 12, 13, 19, 20, 31. Drew the Mealy state diagram, state/output tables and block diagrams | `02_Logisim_Implementation/logisim_simulation_teen.png`, `01_Design_and_Analysis/` | None | Write the Verilog RTL and testbench | [Name] |
| 19/10/2026 | [hh:mm] | Wrote structural Verilog that mirrors the Logisim circuit, and a self-checking testbench (32 ages, START/ACK/RESET, immediate output, START held). Simulated in Vivado XSim: errors = 0 | `03_Verilog_Implementation/RTL/`, `Testbench/`, `Simulation/waveform.jpg` | None | Write the Boolean Board constraints and generate the bitstream | [Name] |
| 20/10/2026 | [hh:mm] | Wrote the Boolean Board XDC (pins from the Real Digital constraints file). First implementation runs failed: [Place 30-574] clock placement, then [Common 17-55] and DRC NSTD-1/UCIO-1 (port names did not match the top module `age_group_mealy`) | `04_FPGA_Hardware/constraints/` | Bitstream generation failed | Rewrite the XDC with the top module's port names | [Name] |
| 20/10/2026 | [hh:mm] | Fixed the XDC (all 12 ports constrained, CLOCK_DEDICATED_ROUTE override added). Bitstream generated and the board programmed. Hardware test passed: correct LED for the boundary ages, instant ACK response, age lock and RESET | `04_FPGA_Hardware/photos/boolean_board_running.jpg`; demo video | None | Document the results; prepare the presentation and report | [Name] |
| 20/10/2026 | [hh:mm] | Prepared the results (32/32 test table, accuracy analysis, limitations), the 3-slide presentation, the final report (PDF and DOCX), viva Q&A, README and STATUS | `05_Results/`, `06_Presentation/`, `07_Final_Report/`, `08_Viva/`, `README.md` | None | Fill in the Vivado utilisation/timing figures; create the final Pull Request | [Name] |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| None open. All earlier blockers resolved: Logisim register pins (Classic appearance), LED blinking (ACK priority), Vivado clock placement and unconstrained ports (XDC corrected) | – | – | No |

## 4. End-of-day summary
### 19 October 2026
- Completed:
  - Problem analysis and Moore → Mealy design (2 states, equations).
  - Block diagrams, Mealy state diagram, state/output tables.
  - Logisim circuit and its simulation (issues fixed).
  - Verilog RTL and self-checking testbench; simulation passed with errors = 0.
- In progress: Boolean Board constraints (XDC).
- Pending: FPGA bitstream and hardware demonstration; results, presentation and report.
- Evidence uploaded: `01_Design_and_Analysis/`, `02_Logisim_Implementation/`, `03_Verilog_Implementation/`
- Plan for 20 October: generate the bitstream, test on the Boolean Board, record the demo, document the results and prepare the presentation and report.

### 20 October 2026
- Completed:
  - FPGA implementation (XDC fixed, bitstream generated).
  - Hardware demonstration passed, with video.
  - Results analysis.
  - Presentation, final report, viva Q&A, README and STATUS.
- Pending:
  - Fill in the Vivado version, LUT count and WNS from the Vivado reports.
  - Add GitHub usernames and repository/PR URLs.
  - Create the final Pull Request.
- Evidence uploaded: `04_FPGA_Hardware/`, `05_Results/`, `06_Presentation/`, `07_Final_Report/`, `08_Viva/`
- Final submission status: [All work complete – final Pull Request pending / submitted]

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Aditi Patwa  
**Date/time:** [Actual date and time]
