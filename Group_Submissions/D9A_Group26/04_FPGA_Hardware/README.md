# 04 – FPGA Hardware

## 1. Target Device & EDA Tool
- **EDA Tool:** Xilinx Vivado 2018.3
- **Target FPGA Device:** Xilinx Spartan-7 (`xc7s25csga324-1`)

## 2. Elaborated RTL Design Summary
- **Total RTL Cells:** 37
- **Total I/O Ports:** 23
  - **Inputs (8 bits):** `clk` (1), `reset` (1), `start` (1), `ack` (1), `xp_in[3:0]` (4)
  - **Outputs (15 bits):** `led_beg` (1), `led_int` (1), `led_exp` (1), `beg_count[3:0]` (4), `int_count[3:0]` (4), `exp_count[3:0]` (4)
- **Total Nets:** 62

## 3. Verification Scope & Hardware Status
- Functional and structural verification was completed via Vivado behavioral RTL simulation (`tb_gaming_xp.v`) and elaborated RTL schematic inspection.
- Physical FPGA board programming and pin constraints (`.xdc`) were not required per faculty instructions for this submission.

## 4. Evidence in This Folder
- `rtl_schematic.jpeg` — Vivado elaborated RTL schematic (`xc7s25csga324-1`) showing the range comparator, three parallel 4-bit level counters, and 4-state Moore FSM.
