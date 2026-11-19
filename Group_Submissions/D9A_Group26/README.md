# Gaming XP Level Decoder (Problem Statement 8 — Hint H4)

## 1. Team Details

| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Krishav Maurya | 33 (D9A) | krishav01-stack |
| Member 2 | Shravani Rawool | 48 (D9A) | shravani12raw25-a11y |
| Member 3 | Iteesha Modanwal | 35 (D9B) | iteesha937 |
| Member 4 | Dhruv Kadam | 19 (D9B) | dhruvkadam060 |

- **Class:** D9A
- **Group ID:** D9A_Group26
- **Repository URL:** https://github.com/krishav01-stack/DSD-2026-D9A-Group26
- **Final Pull Request URL:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/18

## 2. Assigned Problem Statement

- **Number/title:** Problem Statement 8 (Hint H4) — Gaming XP Level Decoder with Level Counters
- **Problem summary:** Design and implement a synchronous digital system that accepts a 4-bit unsigned Experience Points (`xp_in[3:0]`, range `0–15`) input, classifies the player into Beginner (`0–3`), Intermediate (`4–10`), or Expert (`11–15`), illuminates the matching level LED until acknowledged (`ack`), and maintains cumulative 4-bit detection counts for each tier.
- **Objective:** Verify the complete datapath and 4-state Moore FSM controller in Logisim and synthesizable Verilog HDL with self-checking simulation and Vivado RTL analysis.
- **Inputs and outputs:**
  - **Inputs:** `clk` (1-bit), `reset` (1-bit), `start` (1-bit), `ack` (1-bit), `xp_in[3:0]` (4-bit)
  - **Outputs:** `led_beg` (1-bit), `led_int` (1-bit), `led_exp` (1-bit), `beg_count[3:0]` (4-bit), `int_count[3:0]` (4-bit), `exp_count[3:0]` (4-bit)
- **Constraints and assumptions:**
  - Unsigned 4-bit XP arithmetic (`0` to `15`).
  - Three independent **4-bit counters** (`0–15` capacity) prevent rollover across a full 16-value sweep (`4` Beginner, `7` Intermediate, `5` Expert).
  - Counter enable is gated by `start && (state == IDLE)` so holding `start` high does not double-count a single transaction.

## 3. Problem Analysis and Proposed Solution

1. **4-Bit Input Register:** Latches `xp_in[3:0]` synchronously on `start && (state == IDLE)` to prevent mid-round switch changes from corrupting state transitions.
2. **Range Comparator:** Decodes the 4-bit XP value into three mutually exclusive one-hot flags (`0–3` Beginner, `4–10` Intermediate, `11–15` Expert).
3. **Three 4-Bit Level Counters with Pass-Through:** Each counter increments by `+1` on `flag && start && (state == IDLE)` and holds its count across `ack` cycles until `reset = 1`, while passing the 1-bit level flags directly to the Moore FSM.
4. **4-State Moore FSM (`IDLE`, `BEG`, `INT`, `EXP`):** Transitions from `IDLE` (`00`) on `start = 1`, drives the active tier LED (`led_beg`, `led_int`, or `led_exp`), and returns to `IDLE` when `ack = 1`.

## 4. Folder Deliverables

- `01_Problem_Analysis/` — Requirements, I/O specifications, assumptions, and architecture
- `02_FSM_Logisim/` — Moore FSM state tables, Logisim `.circ` circuit, and simulation screenshots
- `03_Verilog_Implementation/` — Synthesizable RTL (`gaming_xp.v`), self-checking testbench (`tb_gaming_xp.v`), waveforms, and Tcl logs
- `04_FPGA_Hardware/` — Xilinx Spartan-7 (`xc7s25csga324-1`) RTL elaborated schematic and resource summary
- `05_Results/` — Expected vs. observed verification table and conclusion
- `06_Presentation/` — 5-slide project presentation
- `07
