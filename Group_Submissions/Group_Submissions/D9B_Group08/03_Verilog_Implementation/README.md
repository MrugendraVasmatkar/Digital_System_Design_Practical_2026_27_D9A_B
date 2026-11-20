# 03 – Verilog Implementation & Verification Summary

**Group:** Group 08 | **Tool:** Xilinx Vivado | **Target Device:** Spartan-7 `xc7s50csga324-1` (Speed Grade `-1`)

## 1. Modular RTL Architecture (`RTL/forbidden_zone_rejector_h4.v`)

The Verilog-2001 RTL matches the Stage 1 Logisim schematic flip-flop for flip-flop, with strictly **synchronous active-high reset** (`always @(posedge clk) if (reset)`) and zero gated clocks:

| Module | Role | Key Logic / Registers |
| :--- | :--- | :--- |
| `start_pulse_gen` (`u_pulse`) | 2-FF registered rising-edge detector | `q1`, `q2` (`FDRE`); `start_pulse = q1 & ~q2` |
| `fz_detector_y` (`u_det`) | Purely combinational range check (`6–9`) | `y = (~x[3] & ~x[2]) \| (x[2] & ~x[1]) \| (x[3] & x[1])`; `fz = ~y` |
| `h4_counters` (`u_counters`) | Two parameterized 4-bit up-counters | `accept_count[3:0]`, `reject_count[3:0]` enabled via `en_accept`/`en_reject` |
| `forbidden_zone_rejector_h4` | Top-level datapath + Moore FSM | `x_reg[3:0]`, `q_d1`, `count_pulse`, `q_state` (`Q+ = (q_d1 & fz_det) \| (q_state & ~q_d1 & ~ack)`) |

## 2. Self-Checking Testbench (`Testbench/tb_forbidden_zone_rejector_h4.v`)

* **Clock:** 100 MHz (`10 ns` period; `#5` half-period toggle).
* **Test Coverage:**
  1. Synchronous active-high `RESET` verification (checks `state === 2'b00`, `y_out === 1'b1`, both counts `=== 4'd0`).
  2. Exhaustive `for`-loop sweep across all **16 input values (`0` to `15`)**, synchronized to the 4-cycle pipeline (`FF1` → `x_reg`/`D1` → `FF_STATE`/`D2` → `Counters`) and checked at `@(negedge clk)` using case inequality (`!==`) to catch any `X`/`Z` states.
  3. Explicit `ACK` verification after every forbidden value (`6, 7, 8, 9`) confirming return to `IDLE (00)` with zero false counter increments.
* **Simulation Result:** Completed at **`860 ns`** with **`0` errors**, **`Accept_Count = 12 (0xC)`**, and **`Reject_Count = 4 (0x4)`**.

### Expected vs. Observed Verification Summary

| Input Range (`X[3:0]`) | Expected Zone | Expected State (`state`) | Expected LEDs (`Acc`, `Rej`) | Observed in Vivado | Status |
| :--- | :--- | :---: | :---: | :--- | :---: |
| `RESET = 1` | Reset | `00` (`IDLE`) | `1`, `0` | `state=0`, `Acc=0`, `Rej=0` | **PASS** |
| `0`–`5` (`0000`–`0101`) | Allowed (6 values) | `00` (`IDLE`) | `1`, `0` | `state=0`, `Accept_Count: 1→6` | **PASS** |
| `6`–`9` (`0110`–`1001`) | Forbidden (4 values) | `01` (`REJECT`) | `0`, `1` | `state=1`, `Reject_Count: 1→4` | **PASS** |
| `ACK = 1` (after `6–9`) | Acknowledge | `00` (`IDLE`) | `1`, `0` | Returned to `0`, counts unchanged | **PASS** |
| `10`–`15` (`1010`–`1111`) | Allowed (6 values) | `00` (`IDLE`) | `1`, `0` | `state=0`, `Accept_Count: 7→12 (0xC)` | **PASS** |

## 3. Vivado Synthesis & Spartan-7 Utilization (`xc7s50csga324-1`, Speed `-1`)

| Site Type | Used | Available | Utilization % | Architectural Mapping |
| :--- | :---: | :---: | :---: | :--- |
| **Slice (`SLICEL`)** | **10** | 8,150 | **0.12%** | Compact logic packing (`0` SLICEM) |
| **LUT as Logic** | **9** | 32,600 | **0.03%** | `5` O6-only + `4` O5&O6; `q_state_i_1` (`LUT6`) merges `u_det` + FSM next-state |
| **LUT as Memory** | **0** | 9,600 | **0.00%** | Pure register/logic implementation |
| **Slice Registers (`FDRE`)** | **17** | 65,200 | **0.03%** | `2` (`u_pulse`) + `4` (`x_reg`) + `2` (`D1/D2`) + `1` (`q_state`) + `8` (`counters`) |
| **Unique Control Sets** | **4** | 8,150 | **0.05%** | 1 global `BUFG` clock (`clk_IBUF_BUFG_inst`), 1 sync `reset`, 4 `CE` enables |

* **Netlist Quality Confirmed:** `0` inferred latches, `100%` synchronous `FDRE` primitives, single global `BUFG` clock tree (zero gated clocks).
