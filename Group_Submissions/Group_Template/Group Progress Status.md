# Group Progress Status

**Class:** D9A / D9B  
**Group ID:** [e.g. D9A_D9B_GroupXX]  
**Project title:** H4 – Weather Alert System: Add Category Counter  
**Group leader:** Yashodhara Suryawanshi (D9A – 56)

## 1. Current milestone status
Use: `Not Started`, `In Progress`, `Completed` or `Blocked`.

| No. | Milestone | Status | Evidence path/link | Last updated |
|---:|---|---|---|---|
| 1 | Problem requirements and assumptions documented | Completed | `README.md`, `final ppt dsd.pptx` | [Date] |
| 2 | Architecture and block diagram prepared | Completed | `02_Architecture/elaborated_schematic.png` | [Date] |
| 3 | FSM diagram/table completed, if applicable | Completed | `README.md`, `02_Architecture/fsm_diagram.png` | [Date] |
| 4 | Logisim circuit implemented | Completed | `01_Logisim/weather_alert_H4.circ` | [Date] |
| 5 | Logisim simulation verified | Completed | `01_Logisim/logisim_simulation.png` | [Date] |
| 6 | Verilog RTL completed | Completed | `03_Verilog_Implementation/RTL/weather_alert_H4.v` | [Date] |
| 7 | Testbench and simulation completed | Completed | `03_Verilog_Implementation/Testbench/tb_weather_alert_H4.v`, `03_Verilog_Implementation/Simulation/waveform_weather_alert_H4.png` | [Date] |
| 8 | FPGA synthesis and implementation completed | In Progress | `04_FPGA_Hardware/` *(Vivado RTL elaboration on `xc7k70tfbv676-1` completed: 39 Cells, 34 I/O Ports, 60 Nets)* | [Date] |
| 9 | Hardware demonstration completed | Not Started | `04_FPGA_Hardware/` *(Update to Completed once demonstrated on physical FPGA board)* | [Date] |
| 10 | Results, presentation and report uploaded | Completed | `final ppt dsd.pptx`, `README.md` | [Date] |
| 11 | Final Pull Request created | In Progress | `[Final Pull Request URL]` | [Date] |

## 2. Time-wise progress log
Update at least once every two hours and at each major milestone. Record actual work and actual times; do not pre-fill future updates.

| Date | Actual time | Work completed | Evidence path | Blocker | Next action | Updated by |
|---|---|---|---|---|---|---|
| 19/10/2026 | [HH:MM] | Finalized H4 problem requirements, 3-bit wind speed ranges (Calm `0–2`, Breezy `3–5`, Storm `6–7`), and 4-state Moore FSM (`IDLE`, `CALM`, `BREEZY`, `STORM`). | `README.md` | None | Design gate-level Range Decoder and category counters in Logisim | Yashodhara Suryawanshi |
| 19/10/2026 | [HH:MM] | Built Logisim circuit with 3-bit input (`W2, W1, W0`), Range Decoder (`S0_calm`, `S1_breezy`, `S2_Storm`), and three D flip-flop counter chains (`D1–D5`, `D12–D15`, `D22–D25`). | `01_Logisim/weather_alert_H4.circ` | Boundary overlap at `Wind = 011` (3) | Refine Boolean equations for mutually exclusive decoding | Sunny Yadav |
| 19/10/2026 | [HH:MM] | Corrected gate-level decoding equations and verified all 8 binary wind inputs (`000`–`111`) and independent counter increments in Logisim simulation. | `01_Logisim/logisim_simulation.png` | None | Begin Verilog HDL RTL implementation in Vivado | Sunny Yadav |
| 20/10/2026 | [HH:MM] | Coded `weather_alert_H4.v` with FSM controller, 4-bit category counters (`Calm_Count`, `Breezy_Count`, `Storm_Count`), LED outputs, and `Buzzer`; verified RTL elaborated schematic (`39 Cells`, `34 I/O Ports`, `60 Nets`). | `03_Verilog_Implementation/RTL/weather_alert_H4.v`, `02_Architecture/elaborated_schematic.png` | None | Write self-checking testbench and run behavioral simulation | Jyotiraditya Nikam |
| 20/10/2026 | [HH:MM] | Completed `tb_weather_alert_H4.v` and Vivado behavioral simulation (`0 ns` to `271 ns`) across all 8 wind values (`0–7`) and reset cycles with `0` errors; finalized presentation (`final ppt dsd.pptx`) and `README.md`. | `03_Verilog_Implementation/Testbench/tb_weather_alert_H4.v`, `final ppt dsd.pptx` | Physical FPGA board pin-mapping/demo pending | Complete FPGA bitstream/hardware test (if applicable) and raise Final Pull Request | Neha Patil |

Add rows as needed.

## 3. Current blockers and support required
| Blocker | Impact | Action being taken | Faculty support required |
|---|---|---|---|
| Physical FPGA board pin constraints (`.xdc`) and push-button debouncing for `START`, `ACK`, and `reset` | Hardware demonstration on the lab FPGA board is pending | Reviewing board pinout and preparing XDC constraints for switches, LEDs, and buzzer *(update to "None" once resolved)* | Confirmation of target lab FPGA board model and pin assignment file (if board demo is required) |

## 4. End-of-day summary
### 19 October 2026
- Completed: Problem analysis, wind-range specifications, 4-state Moore FSM design, and full Logisim gate-level circuit implementation and verification.
- In progress: Transitioning design from Logisim schematic to synthesizable Verilog HDL.
- Pending: Verilog RTL (`weather_alert_H4.v`), testbench (`tb_weather_alert_H4.v`), Vivado simulation/elaboration, FPGA implementation, and final presentation.
- Evidence uploaded: `01_Logisim/weather_alert_H4.circ`, `01_Logisim/logisim_simulation.png`, initial `README.md`.
- Plan for 20 October: Complete Verilog RTL, self-checking testbench, Vivado RTL schematic and behavioral simulation waveforms, final PPT, and Git Pull Request.

### 20 October 2026
- Completed: Verilog RTL (`weather_alert_H4.v`), Vivado RTL elaboration (`39 Cells`, `34 I/O Ports`, `60 Nets` on `xc7k70tfbv676-1`), self-checking behavioral simulation (`tb_weather_alert_H4.v`, 10/10 test cases passed with `errors = 0`), final presentation (`final ppt dsd.pptx`), and full `README.md` documentation.
- Pending: Physical FPGA bitstream programming/hardware demo (if required) and recording the Final Pull Request URL.
- Evidence uploaded: `weather_alert_H4.v`, `tb_weather_alert_H4.v`, Vivado elaborated schematic, simulation waveform screenshot, `final ppt dsd.pptx`, `README.md`, and `STATUS.md`.
- Final submission status: Simulation, RTL elaboration, Logisim verification, and presentation are complete; ready to raise Final Pull Request once bracketed links/timestamps are filled in.

## 5. Group leader confirmation
I confirm that this status reflects the work completed by the group and that the linked evidence has been uploaded.

**Group leader:** Yashodhara Suryawanshi  
**Date/time:** [Actual date and time]