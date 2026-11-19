# 03 – Verilog Implementation

## 1. Folder Structure & Files

| Subfolder | File(s) | Description |
|---|---|---|
| `RTL/` | `gaming_xp.v` | Synthesizable Verilog RTL module implementing the 4-bit input register, XP range comparator, three 4-bit level counters, and 4-state Moore FSM controller |
| `Testbench/` | `tb_gaming_xp.v` | Self-checking Verilog testbench (`10 ns` clock period) verifying synchronous `reset`, `start`/`ack` handshaking, LED outputs, and cumulative counter increments |
| `Simulation_Results/` | `waveforms.png`, `tcl.png` | Xilinx Vivado 2018.3 behavioral simulation waveform (`0 ns` to `270 ns`) and Tcl console verification logs |

## 2. RTL Architecture Overview
- **Synchronous Input & Gating:** `xp_in[3:0]` is sampled on the rising edge of `clk` only when `start && (state == IDLE)`, preventing mid-round switch changes or held `start` signals from causing double counts.
- **Combinational Range Classification:** Classifies unsigned `xp_in[3:0]` into Beginner (`0–3`), Intermediate (`4–10`), and Expert (`11–15`).
- **Parallel 4-Bit Level Counters:** `beg_count[3:0]`, `int_count[3:0]`, and `exp_count[3:0]` increment by `+1` on valid state entry and retain their values across `ack` cycles until `reset = 1`.
- **Moore FSM Output Logic:** State register (`IDLE = 2'b00`, `BEG = 2'b01`, `INT = 2'b10`, `EXP = 2'b11`) drives `led_beg`, `led_int`, and `led_exp` strictly from the current state and returns to `IDLE` when `ack = 1`.

## 3. Simulation Summary
- **Tool:** Xilinx Vivado 2018.3 Behavioral Simulator (`timescale 1ns/1ps`)
- **Verified Sequence:** Reset initialization (`0–20 ns`), Beginner detection (`xp_in = 2`), Intermediate detection (`xp_in = 7`), Expert detection (`xp_in = 14`), and repeat Beginner increment (`xp_in = 1`), ending with `beg_count = 2`, `int_count = 1`, `exp_count = 1` and zero testbench errors.
