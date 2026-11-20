# Group Progress Status

**Class:** D9A  
**Group ID:** D9A_Group07  
**Project title:** FRZ ACCEPT/REJECT Controller using Verilog HDL  
**Group leader:** Snehal Gharmude

## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | README.md (Sections 2 and 3) | 20/11/2026 |
| 2 | Architecture and block diagram prepared | Completed | README.md (Section 4) | 20/11/2026 |
| 3 | FSM diagram/table completed, if applicable | Completed | README.md (Section 5) | 20/11/2026 |
| 4 | Logisim circuit implemented | Completed | Logisim .circ file and circuit screenshot | 20/11/2026 |
| 5 | Logisim simulation verified | Completed | Logisim screenshot (FRZ_project_report.pdf, page 5) | 20/11/2026 |
| 6 | Verilog RTL completed | Completed | 03_Verilog_Implementation/RTL/ | 20/11/2026 |
| 7 | Testbench and simulation completed | Completed | 03_Verilog_Implementation/Testbench/, 03_Verilog_Implementation/Simulation_Results/FRZ_waveform.png | 20/11/2026 |
| 8 | FPGA synthesis and implementation completed | Completed | 04_FPGA_Hardware/FRZ_utilization_placed.rpt, 04_FPGA_Hardware/FRZ_timing_summary_routed.rpt | 20/11/2026 |
| 9 | Hardware demonstration completed | Completed | 04_FPGA_Hardware/ (Hardware implementation.mp4) | 20/11/2026 |
| 10 | Results, presentation and report uploaded | Completed | FRZ_project_report.pdf, DSD Practical Oral Exam.pptx | 20/11/2026 |
| 11 | Final Pull Request created | Completed | (https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/24) | 20/11/26 |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/11/2026 | [ ] | Started the Logisim circuit (about half done): fault-detection gates, inputs X3, X2, X1 and LED outputs | Logisim .circ file (partial) | None | Finish the state register and ACK in Logisim | Snehal Gharmude |
| 20/11/2026 | 9:00 AM - 2:00 PM | Completed and modified the Logisim circuit (D flip-flop with ACK clear, GREEN_LED and RED_LED outputs) and checked its behaviour | Logisim .circ file and screenshot | None | Write the Verilog RTL and testbench | Snehal Gharmude |
| 20/11/2026 | 9:00 AM - 2:00 PM | Wrote the Verilog RTL (FRZ.v) and testbench (FRZ_tb.v) | 03_Verilog_Implementation/RTL/, 03_Verilog_Implementation/Testbench/ | Q was unknown (X) at the start of simulation because there is no RESET | Hold ACK = 1 at the start of the testbench, then run the simulation in Vivado | Snehal Gharmude |
| 20/11/2026 | 9:00 AM - 2:00 PM | Ran the Vivado v2018.3 simulation; checked the waveform (Y and Y_bar react immediately, rejection is latched, ACK clears it) | 03_Verilog_Implementation/Simulation_Results/FRZ_waveform.png | None | Synthesise and implement the design | Snehal Gharmude |
| 20/11/2026 | 9:00 AM - 2:00 PM | Ran synthesis and implementation; generated utilization and timing reports (1 LUT, 1 FF, WNS 6.982 ns, all constraints met) | 04_FPGA_Hardware/FRZ_utilization_placed.rpt, 04_FPGA_Hardware/FRZ_timing_summary_routed.rpt | First XDC used Arty S7 pins, but the board is the Real Digital Boolean; fixed by rewriting FRZ.xdc with the Boolean pins | Program the board and test | Snehal Gharmude |
| 20/11/2026 | 9:00 AM - 2:00 PM | Programmed the Boolean board with FRZ.bit and ran hardware test cases 1 to 8; recorded a video | 04_FPGA_Hardware/ (Hardware implementation.mp4) | None | Finish README, report and presentation; create the Pull Request | Snehal Gharmude |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| None at present | None | Finishing the README, report and presentation uploads | None |

## 4. End-of-day summary
### 19 November 2026
- Completed: About half of the Logisim circuit.
- In progress: Logisim circuit (state register and ACK part).
- Pending: Rest of Logisim, Verilog RTL, testbench, Vivado simulation, synthesis, hardware implementation.
- Evidence uploaded: Partial Logisim file.
- Plan for 20 November: Finish Logisim, then complete the Verilog, Vivado and hardware work between 9:00 AM and 2:00 PM.

### 20 November 2026
- Completed: Logisim circuit, Verilog RTL and testbench, Vivado simulation, synthesis and implementation reports, FPGA programming and hardware demonstration (9:00 AM to 2:00 PM).
- Pending: Final upload of README, report and presentation; Final Pull Request.
- Evidence uploaded: Waveform screenshot, utilization and timing reports, hardware video, project report PDF.
- Final submission status: In progress. The Pull Request is not created yet.

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Snehal Gharmude  
**Date/time:** 20/11/2026 / 5:00 pm
