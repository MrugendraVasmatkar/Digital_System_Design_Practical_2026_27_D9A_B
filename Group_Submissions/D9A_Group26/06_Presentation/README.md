# 06 - Presentation

## 1. Status & Submission Details
- **Status:** In Progress (Day 1 Practical: 19-11-2026, Finalizing before 22:00 IST Pull Request Deadline)
- **Format:** 5 Slides Total (1 Title Slide + 4 Content Slides, strictly following faculty guidelines)
- **File:** `D9A_Group26_Gaming_XP_Decoder.pptx`

## 2. Slide-by-Slide Coverage Plan

| Slide | Section | Key Contents Covered |
|:---:|---|---|
| 1 | Title & Team Identification | VESIT & University of Mumbai details, Problem Statement 8 (Hint H4) title, SE EXTC (2026/27), Group `D9A_Group26` member names, roll numbers, and GitHub handles |
| 2 | Problem Analysis & Architecture | Requirements, 8-bit input and 15-bit output specifications, H4 4-bit counter rollover constraints, and 4-stage datapath block diagram |
| 3 | Combinational Logic, FSM & RTL | Range comparator equations (`0 to 3`, `4 to 10`, `11 to 15`), 4-state Moore FSM state encoding and transition table, Logisim block architecture, and `start && (state == IDLE)` RTL gating |
| 4 | Simulation & FPGA Target | Vivado 2018.3 testbench verification (`tb_gaming_xp.v`, `0 to 270 ns` waveform), Spartan-7 (`xc7s25csga324-1`) resource summary (`37 Cells`, `23 I/O Ports`, `62 Nets`), and elaborated RTL schematic |
| 5 | Results & Team Contributions | Expected vs. observed results across all 16 XP values (`4` Beginner, `7` Intermediate, `5` Expert), challenges resolved, limitations, conclusion, and individual member contributions |

## 3. Oral Examination Readiness
All four members (`Krishav Maurya`, `Shravani Rawool`, `Iteesha Modanwal`, and `Dhruv Kadam`) have reviewed the FSM transitions, Verilog RTL, simulation waveforms, and Logisim architecture for live questioning.
