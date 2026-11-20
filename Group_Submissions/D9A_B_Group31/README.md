# Digital System Design – Group Project

> Complete every mandatory section. Do not delete headings. Replace bracketed prompts. If a section is not applicable, explain why.

## 1. Team Details
| Role | Student name | Roll number | GitHub username |
|---|---|---|---|
| Group leader | Aditya Parab | 37 | adityaparabvesid25 |
| Member 2 | Harika Darbha | 8 | 2025darbhaharika |
| Member 3 | Shravan Kotian | 26 | ShravanK27 |
| Member 4 | Siddharth Gupta | 14 | SIDV5-95G |

**Class:** D9A/D9B  
**Group ID:** D9A_B_Group31  
**Repository URL:** https://github.com/adityaparabvesid25/DSD-2026-D9A-B-Group31  
**Final Pull Request URL:** https://github.com/MrugendraVasmatkar/Digital_System_Design_Practical_2026_27_D9A_B/pull/10

## 2. Assigned Problem Statement
- **Number/title:** 7H3 — Weather Alert System with Invalid Input `ERROR` State (Hint H3)
- **Problem summary:** Design, simulate, and verify a synchronous digital Weather Alert System built around a datapath and a Moore Finite State Machine (FSM) controller. The system samples wind speed readings, classifies them into three valid alert levels—`CALM` (`0–2`), `BREEZY` (`3–5`), and `STORM` (`6–7`)—and implements modification **H3**, which introduces an `ERROR` state to detect out-of-range inputs (`> 7`), assert an error indicator LED, and return safely to `S_IDLE` upon `ACK` or `RST`.
- **Objective:**
  - Design and simulate the complete datapath (4-bit input register and unsigned range decoder) and 5-state Moore FSM in Logisim-evolution (Version 26).
  - Develop the updated 5-state Moore FSM diagram, state encoding table, transition table, and output table covering `S_IDLE`, `S_CALM`, `S_BREEZY`, `S_STORM`, and `S_ERROR`.
  - Implement a synthesizable Verilog RTL module (`weather_alert_system.v`), behavioral testbench (`tb_weather_alert_system.v`), `.xdc` pin constraints, and FPGA bitstream (`.bit`) in Xilinx Vivado 2018.3 to verify valid (`0–7`) and invalid (`8–15`) wind categories, `START`/`ACK`/`RST` control transitions, and indicator outputs.
- **Inputs and outputs:**

| Signal Name | Direction | Width | Meaning / Function |
| :--- | :---: | :---: | :--- |
| `w` (`W3–W0`) | Input | 4-bit | Unsigned wind speed input (`0–2`: Calm, `3–5`: Breezy, `6–7`: Storm, `8–15`: Error) |
| `clk` (`CLK`) | Input | 1-bit | System clock synchronizing `input_reg` and `state_reg` |
| `rst` (`RST`) | Input | 1-bit | Asynchronous active-high reset (`always @(posedge clk or posedge rst)` in Verilog; `R` clear pin in Logisim) that clears registers and returns the FSM to `S_IDLE` |
| `start` (`START`) | Input | 1-bit | Loads the decoded weather category into the FSM state register when `ack = 0` |
| `ack` (`ACK`) | Input | 1-bit | Acknowledges the active weather alert or error condition and returns the FSM to `S_IDLE` |
| `idle_led` | Output | 1-bit | Status indicator LED asserted in `S_IDLE` (`000`) while all weather alert LEDs remain OFF |
| `calm_led` | Output | 1-bit | Green indicator LED asserted in `S_CALM` (`001`, range `0–2`) |
| `breezy_led` | Output | 1-bit | Yellow indicator LED asserted in `S_BREEZY` (`010`, range `3–5`) |
| `stormy_led` | Output | 1-bit | Red indicator LED / Buzzer asserted in `S_STORM` (`011`, range `6–7`) |
| `error_led` | Output | 1-bit | Error indicator LED asserted in `S_ERROR` (`100`, range `> 7`, Hint H3) |

- **Constraints and assumptions:**
  - **4-Bit Input Expansion (Required for Hint H3):** The base specification uses a 3-bit wind input (`0–7`), which saturates at `111` (`7`) and mathematically cannot represent values `> 7`. Expanding `w`, `input_reg`, and the range comparators to **4 bits** (`0000–1111`, decimal `0–15`) enables explicit detection of invalid inputs (`8–15`).
  - **3-Bit State Register Expansion:** Adding the fifth state (`S_ERROR`) exceeds the 4-state capacity of a 2-bit register (`00–11`). The FSM state register (`state_reg`) is therefore expanded to **3 bits** ($\lceil \log_2 5 \rceil = 3$, codes `000` through `100`).
  - **Unsigned Comparison:** All 4-bit comparators are configured in **unsigned** mode so that binary `1000–1111` are evaluated as `8–15` (`> 7`) rather than negative 2's complement integers (`-8` to `-1`).
  - **Asynchronous Active-High Reset:** Both the Logisim schematic (register `R` clear pins) and the Vivado Verilog RTL (`always @(posedge clk or posedge rst)`) use an asynchronous active-high reset (`rst`) for exact hardware parity and immediate recovery to `S_IDLE` from any state.
  - **Moore FSM Output Discipline:** Indicator LEDs depend strictly on the registered state (`state_reg`), preventing combinational glitches on external inputs from triggering false alerts.
  - **Safe Control Priority:** When both `START` and `ACK` are asserted simultaneously (`ack = 1, start = 1`), `ACK` takes priority and transitions the system safely back to `S_IDLE`.

## 3. Problem Analysis and Proposed Solution

### Functional Requirements
The system must initialize into a standby `S_IDLE` state with all weather alert indicators OFF, latch and classify 4-bit wind readings (`w`) upon `START`, hold the active alert state (`S_CALM`, `S_BREEZY`, `S_STORM`, or `S_ERROR`) while `START = 0` and `ACK = 0`, and return to `S_IDLE` whenever `ACK` or `RST` is asserted. Under modification **H3**, any reading greater than `7` (`8–15`) must assert `error_led` and remain latched until acknowledged or reset.

### Edge Cases Analyzed
- **Range Threshold Boundaries (`2/3`, `5/6`, `7/8`):** Implementing separate lower- and upper-bound comparators (`>=` and `<=`) without equality (`=`) paths causes boundary values such as `3`, `5`, `6`, or `7` to drop out of range. Every integer from `0` through `15` must map cleanly to a unique category.
- **Distinguishing Wind Speed `0` (`0000`) from `S_IDLE`:** A wind reading of `0` belongs to the valid `S_CALM` (`0–2`) range, whereas `S_IDLE` is a standby state. Assigning separate encodings (`S_IDLE = 000`, `S_CALM = 001`) ensures that asserting `START` with `w = 0000` properly activates `calm_led`.
- **Signed vs. Unsigned Comparator Trap:** Defaulting 4-bit comparators to 2's complement causes values `8–15` (`1000–1111`) to evaluate as negative integers, silently breaking `> 7` error detection. Enforcing unsigned comparison resolves this completely.
- **Two-Stage Register Pipeline (`input_reg` $\rightarrow$ `state_reg`):** Because `input_reg` samples `w` on one rising clock edge and `state_reg` latches `encoded_state` on the following clock edge when `start = 1`, `start` must either be asserted after loading `w` (in Logisim) or held for two clock cycles (`#20` in Vivado) so the newly latched wind value propagates cleanly into `state_reg`.
- **Mid-Alert Input Fluctuations:** Changing `w` (`W3–W0`) while an alert is active (`start = 0, ack = 0`) updates `input_reg` without disturbing `state_reg`, keeping the latched alert LED stable.
- **Simultaneous `START` and `ACK` Assertion:** Giving `ACK` priority over `START` (MUX inputs `10` and `11` tied to `000` in Logisim; `else if (ack)` checked before `else if (start)` in Verilog) guarantees deterministic recovery to `S_IDLE`.

### Proposed Solution and Distinctive Features
- **3-Comparator + Priority Encoder Architecture:** Instead of using six comparators with multiple `AND`/`OR` gates to check both upper and lower limits of every range, the datapath uses **three 4-bit unsigned comparators** testing only strict upper thresholds (`> 2`, `> 5`, `> 7`) wired directly into an **8-to-3 Priority Encoder (`Pri`)**. Pin `1` (`001`, `S_CALM`) is tied permanently HIGH as the baseline fallback for `0–2`, while the `>` outputs of `0x2`, `0x5`, and `0x7` feed Pins `2` (`S_BREEZY`), `3` (`S_STORM`), and `4` (`S_ERROR`). Higher-index pins override lower ones, outputting the exact 3-bit state code (`001`–`100`) with zero discrete logic gates and zero boundary-equality bugs.
- **1-to-1 Logisim-to-Verilog Structural Parity:** The Verilog RTL (`weather_alert_system.v`) directly mirrors the Logisim schematic—implementing a 4-bit `input_reg`, a combinational `> 7 / > 5 / > 2` priority chain (`encoded_state`), an `ack`-prioritized 3-bit `state_reg`, and five one-hot decoded LED outputs—synthesizing to only **6 Slice LUTs** and **7 Flip-Flops** with **0 latches**.

### Feasibility
The entire design requires minimal hardware resources—one 4-bit register, one 3-bit register, three 4-bit unsigned comparators, one priority encoder, one 4-to-1 3-bit MUX, and one 3-to-8 decoder. It operates on a single clock domain with clean asynchronous reset behavior and glitch-free Moore outputs, making it straightforward to simulate in Logisim-evolution, verify, implement, and generate a bitstream in Vivado 2018.3, and deploy on FPGA hardware.

## 4. Architecture

![Block diagram](path/to/image_b5e9ea.png)

### Module Breakdown
1. **Input Interface & 4-Bit Input Register (`input_reg[3:0]`):** Combines the four wind input switches (`W0` LSB through `W3` MSB forming `w[3:0]`) into a 4-bit unsigned bus via a bus combiner (splitter) and latches the reading on every rising edge of `clk` (asynchronously cleared to `0000` on `rst = 1`).
2. **Threshold Comparators (`> 2`, `> 5`, `> 7`) & Priority Encoder (`Pri` / `encoded_state`):** Three 4-bit unsigned comparators evaluate `input_reg` against `0x2`, `0x5`, and `0x7`. Their strict greater-than (`>`) outputs drive Pins `2`, `3`, and `4` of the Priority Encoder (with Pin `1` tied to `1` and Pins `0, 5, 6, 7` tied to `0`), producing the 3-bit category code:
   - `0–2` $\rightarrow$ `001` (`S_CALM`)
   - `3–5` $\rightarrow$ `010` (`S_BREEZY`)
   - `6–7` $\rightarrow$ `011` (`S_STORM`)
   - `8–15` $\rightarrow$ `100` (`S_ERROR`)
3. **4-to-1 Control MUX & 3-Bit State Register (`state_reg[2:0]`):** Controlled by `{ack, start}`:
   - `00` (`ack = 0, start = 0`): Feedback loop from `state_reg` (**Hold State**).
   - `01` (`ack = 0, start = 1`): Loads `encoded_state` from the Priority Encoder (**Load Alert**).
   - `10` (`ack = 1, start = 0`) & `11` (`ack = 1, start = 1`): Loads `000` (**Return to `S_IDLE`**).  
   The 3-bit State Register updates on `posedge clk` and clears asynchronously to `000` (`S_IDLE`) when `rst = 1`.
4. **3-to-8 Output Decoder & Status LEDs:** Decodes `state_reg[2:0]` directly into mutually exclusive indicator outputs (`idle_led`, `calm_led`, `breezy_led`, `stormy_led`, and `error_led`).

### Data Flow and Control Flow
- **Data Flow:** Wind inputs `w[3:0]` (`W3–W0`) enter `input_reg`, pass through the unsigned threshold comparators and Priority Encoder to generate `encoded_state[2:0]`, route through the 4-to-1 Control MUX into `state_reg[2:0]`, and feed the output decoder to drive the five status LEDs.
- **Control Flow:** `clk` synchronizes both registers. Active-high `rst` asynchronously clears both registers to `S_IDLE (000)`. Asserting `start = 1` (with `ack = 0`) selects channel `01` to latch the classified weather category. While `start = 0` and `ack = 0`, channel `00` holds the active state indefinitely. Asserting `ack = 1` selects channel `10` (or `11`), returning `state_reg` to `S_IDLE (000)` on the next clock edge.

### Design Trade-Offs

| Design Decision | Chosen Approach | Alternative Considered | Rationale & Trade-Off |
| :--- | :--- | :--- | :--- |
| **Wind Input Width** | 4-bit (`w[3:0]`, `0–15`) | 3-bit (`0–7`) | Requires 1 extra input pin and flip-flop, but is mathematically necessary to represent out-of-range values (`> 7`) for Hint H3. |
| **Range Decoder Logic** | 3 Unsigned Comparators (`> 2, > 5, > 7`) + Priority Encoder | 6 Comparators + `AND`/`OR` gates | Cuts comparator count in half, removes discrete logic gates, reduces propagation delay, and eliminates `>=`/`<=` boundary-wiring faults. |
| **FSM Type** | Moore FSM | Mealy FSM | Adds one clock cycle of output latency compared to Mealy, but guarantees stable, glitch-free LED outputs isolated from input noise. |
| **Reset Strategy** | Asynchronous Active-High (`rst`) | Synchronous Reset | Matches Logisim's asynchronous register clear (`R`) pin and ensures immediate recovery to `S_IDLE` even if the clock is halted. |
| **State Encoding** | 3-bit Sequential Binary (`000`–`100`) | 5-bit One-Hot (`00001`–`10000`) | Uses 3 flip-flops instead of 5 (total 7 FFs in Vivado synthesis) and keeps Logisim and Verilog state registers identical, at the minor cost of a small output decoder. |
| **Input Register Pipeline** | Registered Input (`input_reg` $\rightarrow$ `state_reg`) | Unregistered combinational input | Isolates switch skew/bounce from comparators at the cost of a 1-clock pipeline delay between latching `w` and updating `state_reg`. |

## 5. FSM Design

Yes, the system uses a **5-state Moore Finite State Machine (FSM)**. A Moore architecture was chosen because all five status LEDs depend strictly on the registered current state (`state_reg`), ensuring glitch-free alert indicators even when external wind switches (`w`) change asynchronously.

**Diagram:** `path/to/image_b5e94c.png`  
**State table:** See the State Encoding, Moore Output, and State Transition tables below.

### State Encoding and Moore Output Table

| State Name | Encoding (`Q2 Q1 Q0`) | `idle_led` | `calm_led` | `breezy_led` | `stormy_led` | `error_led` | Description |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| **`S_IDLE`** | `000` | `1` | `0` | `0` | `0` | `0` | Standby state; all weather alert LEDs OFF |
| **`S_CALM`** | `001` | `0` | `1` | `0` | `0` | `0` | Valid wind range `0 <= w <= 2` (`0000–0010`) |
| **`S_BREEZY`** | `010` | `0` | `0` | `1` | `0` | `0` | Valid wind range `3 <= w <= 5` (`0011–0101`) |
| **`S_STORM`** | `011` | `0` | `0` | `0` | `1` | `0` | Valid wind range `6 <= w <= 7` (`0110–0111`) |
| **`S_ERROR`** | `100` | `0` | `0` | `0` | `0` | `1` | Invalid wind range `w > 7` (`1000–1111`, Hint H3) |

### State Transition Table

| Current State | `RST` (`rst`) | `ACK` (`ack`) | `START` (`start`) | Registered Wind (`input_reg`) | Next State | Transition Condition / Behavior |
| :--- | :---: | :---: | :---: | :---: | :---: | :--- |
| Any (`000`–`100`) | `1` | `X` | `X` | Any | **`S_IDLE` (`000`)** | Asynchronous reset overrides all inputs and clears system to `S_IDLE` |
| **`S_IDLE` (`000`)** | `0` | `0` | `0` | Any | **`S_IDLE` (`000`)** | Remain in standby (`START == 0`) |
| **`S_IDLE` (`000`)** | `0` | `1` | `X` | Any | **`S_IDLE` (`000`)** | Remain in standby (`ACK == 1` takes priority) |
| **`S_IDLE` (`000`)** | `0` | `0` | `1` | `w <= 2` | **`S_CALM` (`001`)** | `START == 1 & ACK == 0 [w <= 2]` |
| **`S_IDLE` (`000`)** | `0` | `0` | `1` | `3 <= w <= 5` | **`S_BREEZY` (`010`)** | `START == 1 & ACK == 0 [3 <= w <= 5]` |
| **`S_IDLE` (`000`)** | `0` | `0` | `1` | `6 <= w <= 7` | **`S_STORM` (`011`)** | `START == 1 & ACK == 0 [6 <= w <= 7]` |
| **`S_IDLE` (`000`)** | `0` | `0` | `1` | `w > 7` | **`S_ERROR` (`100`)** | `START == 1 & ACK == 0 [w > 7]` |
| **`S_CALM` / `S_BREEZY` / `S_STORM` / `S_ERROR`** | `0` | `0` | `0` | Any | **Hold Current State** | `ACK == 0 & START == 0` retains latched alert |
| **`S_CALM` / `S_BREEZY` / `S_STORM` / `S_ERROR`** | `0` | `1` | `X` | Any | **`S_IDLE` (`000`)** | `ACK == 1` acknowledges alert/error and returns to `S_IDLE` |

### Reset Behaviour
Asserting active-high `rst = 1` (`RST = 1`) **asynchronously** clears both `input_reg` (`0000`) and `state_reg` (`000`), forcing the FSM immediately into **`S_IDLE`** from any state (including `S_ERROR`) with all weather alert LEDs turned OFF and `idle_led = 1`. Both the Logisim register `R` pins and the Verilog RTL (`always @(posedge clk or posedge rst)`) share identical asynchronous reset semantics.

## 6. Logisim Implementation
- **Logisim version:** Logisim-evolution (Version 26)
- **Circuit file:** `02_FSM_Logisim/` (`.circ` source file and exported schematic `THE LOGISIM D9A_B_GROUP31.pdf`)
- **Test cases and expected/observed behaviour:**
  All five FSM states (`Idle`, `Calm`, `Breezy`, `Storm`, and `Error`) along with `START`, `ACK`, and `RST` transitions were verified interactively using the Poke tool and manual clock pulses:

| Case | Wind Switches (`W3 W2 W1 W0`) | `Input Register` (Hex) | `START` / `ACK` | `State Register` (Hex) | Expected Output | Observed Output | Status |
| :--- | :---: | :---: | :---: | :---: | :--- | :--- | :---: |
| **Idle (Reset)** | `0 0 0 0` (`0`) | `0` | `0 / 0` | `0` (`000`) | `Idle` LED ON (others OFF) | `Idle` LED ON (Orange) | Pass |
| **Calm (`0–2`)** | `0 0 0 1` (`1`) | `1` | `1 / 0` | `1` (`001`) | `Calm` LED ON | `Calm` LED ON (Green) | Pass |
| **Breezy (`3–5`)** | `0 1 0 1` (`5`) | `5` | `1 / 0` | `2` (`010`) | `Breezy` LED ON | `Breezy` LED ON (Yellow) | Pass |
| **Storm (`6–7`)** | `0 1 1 1` (`7`) | `7` | `1 / 0` | `3` (`011`) | `Storm` LED ON | `Strom` LED ON (Red) | Pass |
| **Error (`> 7`, H3)** | `1 0 0 0` (`8`) | `8` | `1 / 0` | `4` (`100`) | `Error` LED ON | `Error` LED ON (Cyan) | Pass |
| **Acknowledge (`ACK`)** | Any | Any | `0 / 1` | `0` (`000`) | Return to `Idle` | `Idle` LED ON; alerts OFF | Pass |

- **Issues and corrections:**
  1. **3-Bit Width Limitation for Hint H3:** The initial 3-bit input (`0–7`) could not represent `> 7`. Upgraded the input pins (`W0–W3`), splitter, `Input Register`, and comparators to **4 bits** (`0–15`).
  2. **Signed (`2's Complement`) Comparator Default:** Comparators initially defaulted to signed mode, interpreting `8–15` as negative numbers and preventing `Error` detection. Switched all comparators to **`Unsigned`**.
  3. **6-Comparator Boundary & Pin-Shift Faults:** Early prototypes using six comparators and `AND`/`OR` gates missed equality (`=`) boundaries (breaking `3, 5, 6, 7`) and entered the Priority Encoder shifted at Pin `0`. Replaced the stage with **three unsigned `>` comparators (`0x2`, `0x5`, `0x7`)** wired to `Pri` Pins `2, 3, 4` with Constant `1` on Pin `1` (`Calm`) and Constant `0` on Pins `0, 5, 6, 7`.
- **Screenshot/evidence:**
  - Circuit Schematic PDF: `02_FSM_Logisim/THE LOGISIM D9A_B_GROUP31.pdf`
  - Idle State (`0`): `path/to/image_ea0e04.png`
  - Calm State (`1`): `path/to/image_ea0e23.png`
  - Breezy State (`5`): `path/to/image_ea0e3c.png`
  - Storm State (`7`): `path/to/image_ea0e42.png`
  - Error State (`8`): `path/to/image_ea11c3.png`

## 7. Verilog HDL Implementation
- **Tool/version:** Xilinx Vivado 2018.3
- **Top module and submodules:**
  - **Top RTL Module:** `weather_alert_system` (`weather_alert_system.v`) — single self-contained RTL module structured into four clear functional blocks (no external submodules required).
  - **Testbench Module:** `tb_weather_alert_system` (`tb_weather_alert_system.v`) — drives a 100 MHz clock (`10 ns` period), asynchronous reset, and test vectors covering `w = 2` (`Calm`), `w = 4` (`Breezy`), `w = 6` (`Stormy`), and `w = 9` (`Error`) with `ACK` return-to-`Idle` cycles between each case.
- **Architecture/coding decisions:**
  - **Exact Structural Match to Logisim:** Implemented `input_reg[3:0]` (4-bit input register) and `state_reg[2:0]` (3-bit binary state register) in separate sequential `always @(posedge clk or posedge rst)` blocks, matching the Logisim dual-register datapath and asynchronous `R` clear pins.
  - **Priority Threshold Decoding:** Implemented the three unsigned threshold comparators (`> 7`, `> 5`, `> 2`) as an `if / else if / else` priority chain inside `always @(*)`, producing `encoded_state` (`3'd4` Error, `3'd3` Stormy, `3'd2` Breezy, `3'd1` Calm) with complete branch coverage.
  - **Control Priority in State Register:** Checked `if (rst)` $\rightarrow$ `else if (ack)` $\rightarrow$ `else if (start)` $\rightarrow$ `else state_reg <= state_reg`, ensuring `RST` and `ACK` always take priority over `START` while holding the active alert when both controls are low.
  - **Pure Moore Output Decoding:** Drove all five status outputs (`idle_led`, `calm_led`, `breezy_led`, `stormy_led`, `error_led`) via continuous `assign` comparisons strictly on `state_reg`.
- **Synthesizability considerations:**
  - Uses strictly synthesizable Verilog-2001 constructs: non-blocking assignments (`<=`) for sequential registers, blocking assignments (`=`) with full default `else` coverage in combinational logic (preventing unintended latches), and explicit bit widths (`4'd0`, `3'd0`–`3'd4`).
  - **Vivado 2018.3 Synthesis Verification (`synth_1`):** Synthesized cleanly with **0 inferred latches**, **16 RTL cells**, **13 I/O ports**, and **36 nets**, utilizing only **6 Slice LUTs (`0.02%`)** and **7 Slice Registers / Flip-Flops (`0.01%`)** (`4` FFs for `input_reg[3:0]` + `3` FFs for `state_reg[2:0]`).
- **RTL:** `03_Verilog_Implementation/RTL/weather_alert_system.v`
- **Testbench:** `03_Verilog_Implementation/Testbench/tb_weather_alert_system.v`

## 8. Verification and Simulation Results
| Test ID | Inputs/conditions | Expected output | Observed output | Pass/Fail |
|---|---|---|---|---|
| T01 | `rst = 1`, `w = 4'd0`, `start = 0`, `ack = 0` (`0–10 ns`), then `rst = 0` | `idle_led = 1`; all weather alert LEDs `0` | `idle_led = 1`, all alert LEDs `0` (`0–25 ns`) | Pass |
| T02 | `w = 4'd2` (`<= 2`), `start = 1` (`#20`), then `start = 0` (`#10`), `ack = 0` | `calm_led = 1` and holds state after `start` drops | `calm_led = 1` (`25–55 ns`), holds cleanly until `ack` | Pass |
| T03 | `ack = 1` (`#10`), then `ack = 0` (`#10`) after Calm alert | Return to `S_IDLE` (`idle_led = 1`, `calm_led = 0`) | `idle_led = 1` (`55–75 ns`), all alert LEDs cleared | Pass |
| T04 | `w = 4'd4` (`3–5`), `start = 1` (`#20`), then `start = 0`, followed by `ack = 1` | `breezy_led = 1`, holds state, then `ack = 1` returns to `idle_led = 1` | `breezy_led = 1` (`85–105 ns`, after 1-cycle `input_reg` pipeline), returns to `idle_led = 1` on `ack` | Pass |
| T05 | `w = 4'd6` (`6–7`), `start = 1` (`#20`), then `start = 0`, followed by `ack = 1` | `stormy_led = 1`, holds state, then `ack = 1` returns to `idle_led = 1` | `stormy_led = 1` (`135–155 ns`), returns to `idle_led = 1` on `ack` | Pass |
| T06 | `w = 4'd9` (`> 7`, Hint H3), `start = 1` (`#20`), then `start = 0`, followed by `ack = 1` | `error_led = 1`, holds state, then `ack = 1` returns to `idle_led = 1` | `error_led = 1` (`185–205 ns`), returns to `idle_led = 1` on `ack` | Pass |

- **Tool/version:** Xilinx Vivado 2018.3 (Behavioral Simulation — Functional, `sim_1`, `tb_weather_alert_system`, 100 MHz clock / `10 ns` period)
- **Number passed/failed:** 6 / 6 scenarios passed (`0` failed)
- **Waveform/log path:** `03_Verilog_Implementation/` (Vivado simulation waveform screenshot `image_ea1220.png`)

## 9. FPGA Hardware Implementation
- **FPGA board/device:** RealDigital AMD Xilinx Spartan-7 Boolean Board (`XC7S50`, 32,600 Slice LUTs / 65,200 Slice Registers)
- **Tool/version:** Xilinx Vivado 2018.3
- **Clock/constraints:** Pin assignments and I/O standards mapped via the `.xdc` constraints file under `04_FPGA_Hardware/` (on-board clock for `clk`, 4 slide switches for `w[3:0]`, pushbuttons/switches for `start`, `ack`, and `rst`, and 5 on-board LEDs for `idle_led`, `calm_led`, `breezy_led`, `stormy_led`, and `error_led`).
- **Synthesis/implementation summary:** Synthesis (`synth_1`), place-and-route implementation (`impl_1`), and bitstream generation (`.bit`) completed cleanly in Vivado 2018.3 with **6 Slice LUTs (`0.02%`)**, **7 Slice Registers / Flip-Flops (`0.01%`)** (`4` for `input_reg`, `3` for `state_reg`), **0 Latches (`0.00%`)**, **16 RTL cells**, **13 I/O ports**, and **36 nets**.
- **Programming and hardware test result:** Constraints (`.xdc`) and bitstream (`.bit`) files generated and uploaded to `04_FPGA_Hardware/`, ready for live FPGA board demonstration during evaluation.
- **Evidence path:** `04_FPGA_Hardware/` (`.xdc` constraints file, `.bit` bitstream file, utilization and RTL schematic screenshots)

*Simulation vs. hardware note:* In behavioral simulation, `w` and `start` toggle simultaneously on `10 ns` boundaries, revealing a 1-cycle (`10 ns`) pipeline transition from `input_reg` to `state_reg`. On FPGA hardware running at the board clock rate, holding the `start` input/button spans thousands of clock cycles, so the human-visible LED updates instantaneously to the classified weather state.

## 10. Challenges, Debugging and Improvements
| Issue | Root cause | Correction | Outcome |
|---|---|---|---|
| Out-of-range wind values (`> 7`) could not be represented for Hint H3 | Base 3-bit input bus (`000–111`) saturates at decimal `7` | Expanded input switches, splitter, `input_reg`, and comparators to **4 bits** (`0–15`) and `state_reg` to **3 bits** | Invalid readings `8–15` cleanly trigger `S_ERROR` (`100`) |
| `Error` LED failed to trigger for `w = 8–15` in Logisim | Logisim comparators defaulted to 2's complement (`Signed`), treating `1000–1111` as `-8` to `-1` | Switched all three 4-bit comparators to **`Unsigned`** mode | `8–15` evaluate properly as `> 7`, asserting `Error` |
| Boundary values (`3, 5, 6, 7`) misclassified in early 6-comparator Logisim circuit | Missing equality (`=`) paths and shifted pin wiring into Priority Encoder Pin `0` | Replaced 6 comparators + logic gates with **3 unsigned `>` comparators (`0x2, 0x5, 0x7`)** feeding `Pri` Pins `2, 3, 4` with Pin `1` tied HIGH | Zero boundary bugs, lower component count, and cleaner routing |
| Brief 1-cycle (`10 ns`) previous-LED pulse seen in Vivado waveform before new alert | Two-stage synchronous pipeline (`input_reg` $\rightarrow$ `state_reg`) latches `w` on cycle 1 and classifies on cycle 2 | Held `start = 1` for 2 clock cycles (`#20`) in `tb_weather_alert_system.v` and documented pipeline latency | Every test category settles accurately to its expected LED |
| Reset-type and port-name mismatch between early docs and synthesized RTL | Early draft listed synchronous reset and `wind_in`/`reset`, while RTL and Logisim used async `rst` and `w` | Aligned `README.md` Sections 2–5 with asynchronous active-high `rst`, `w`, and `stormy_led` | 100% parity across Logisim, Verilog RTL, diagrams, and documentation |

- **Future improvements:** Add hardware pushbutton debouncers and edge detectors on `start` and `ack` for single-press board operation, drive a 7-segment display to show the live numeric wind value alongside the alert LEDs, and optionally add an audible buzzer output tied to `stormy_led` and `error_led`.

## 11. Task Allocation and Individual Contribution
| Student | Assigned responsibility | Actual contribution/evidence |
|---|---|---|
| **Aditya Parab** (Group leader) | Brainstorming, GitHub repository management, pull request coordination, and technical documentation | Led problem analysis (7H3) and architecture brainstorming; set up and maintained fork/repository structure, managed all commits and merges into Open `PR #10` (zero conflicts), integrated diagrams/evidence, and authored `README.md`, `STATUS.md`, and the Final Project Report PDF. |
| **Harika Darbha** (Member 2) | Brainstorming, Logisim circuit implementation, and Vivado RTL/FPGA development | Contributed to 5-state Moore FSM and 3-comparator + Priority Encoder architecture brainstorming; built and verified the Logisim v26 schematic (`02_FSM_Logisim/`); co-developed Verilog RTL, testbench simulation, `.xdc` constraints, and bitstream generation in Vivado 2018.3. |
| **Shravan Kotian** (Member 3) | Brainstorming, Logisim design/testing, and project presentation (PPT) | Participated in system architecture and H3 edge-case brainstorming; collaborated on Logisim v26 schematic design and 5-state functional verification; created and finalized the 2-slide project presentation (Complete Implementation and Results). |
| **Siddharth Gupta** (Member 4) | Brainstorming, Logisim schematic design, and Vivado RTL/FPGA verification | Participated in datapath and FSM brainstorming; collaborated on Logisim v26 schematic debugging (unsigned comparator & threshold fixes); co-developed and verified `weather_alert_system.v`, `tb_weather_alert_system.v`, synthesis reports, `.xdc` pin constraints, and bitstream in Vivado 2018.3. |

Every student must be ready to explain the complete design.

## 12. Progress Log
Maintain time-wise updates in `STATUS.md`.

## 13. Final Results and Conclusion
- **Requirements Met:** All functional requirements for **Problem 7H3 (Weather Alert System with Hint H3 `ERROR` State)** were successfully achieved. The system classifies 4-bit unsigned wind inputs into `S_CALM` (`0–2`), `S_BREEZY` (`3–5`), `S_STORM` (`6–7`), and out-of-range `S_ERROR` (`8–15`), holds active alerts safely, prioritizes `ACK` over `START`, and supports immediate asynchronous reset (`RST`) back to `S_IDLE`.
- **Verification & Measured Results:**
  - **Logisim-evolution (v26):** All 5 states (`Idle`, `Calm`, `Breezy`, `Storm`, `Error`) and `START`/`ACK`/`RST` transitions passed interactive simulation (`w = 0, 1, 5, 7, 8`).
  - **Xilinx Vivado 2018.3 Simulation:** All 6/6 behavioral testbench scenarios (`T01–T06`) passed with zero functional errors across `w = 2, 4, 6, 9` at `100 MHz` (`10 ns` period).
  - **Synthesis & FPGA Implementation:** Synthesized cleanly with **6 Slice LUTs (`0.02%`)**, **7 Slice Registers / Flip-Flops (`0.01%`)**, **0 inferred latches (`0.00%`)**, **16 RTL cells**, **13 I/O ports**, and **36 nets**, followed by `.xdc` pin constraint mapping and successful `.bit` bitstream generation for the Spartan-7 Boolean Board.
  - **Documentation & Deliverables:** Complete `README.md`, `STATUS.md`, Final Project Report PDF, and 2-slide project presentation uploaded and synced to Pull Request `#10` with zero merge conflicts.
- **Limitations:** The two-stage register pipeline (`input_reg` $\rightarrow$ `state_reg`) introduces a 1-clock-cycle latency when `w` and `start` change on the exact same cycle in simulation, and physical pushbuttons are currently wired without dedicated hardware debouncers.
- **Conclusion:** By combining a 4-bit unsigned datapath, a compact 3-comparator + Priority Encoder classifier, and a 5-state Moore FSM with exact structural parity between Logisim and Verilog RTL, the team delivered a minimal-area, glitch-free, and fully synthesizable Weather Alert System ready for FPGA demonstration and evaluation.

## 14. Team Reflection
- **What the team learned:**
  - Designing from first principles revealed why **4-bit unsigned representation** and **3-bit state encoding** are mathematically required once Hint H3 (`> 7` error detection) is added.
  - Replacing discrete multi-comparator gate networks with **three unsigned `>` comparators and a Priority Encoder** dramatically simplified both schematic routing and Vivado LUT utilization while eliminating boundary bugs.
  - Debugging the 1-cycle pipeline pulse in Vivado waveforms deepened our understanding of synchronous register-to-register timing (`<=` vs. `=`), asynchronous reset parity (`RTL_REG_ASYNC`), and clean latch-free RTL coding.
  - Coordinating parallel work across Logisim, Vivado, PPT creation, Final Report compilation, and GitHub Pull Requests taught us the importance of consistent signal naming (`w`, `rst`, `stormy_led`) and disciplined version control.
- **What we would improve:**
  - Establish a strict naming convention and folder/image path structure before uploading the first commit to avoid cleanup commits later.
  - Add hardware switch debouncing, rising-edge pulse detectors for `START`/`ACK`, and a 7-segment display readout for live wind speed monitoring on the FPGA board.

## 15. Final Submission Checklist
- [x] Team details and problem analysis complete.
- [x] Architecture/block diagram included.
- [x] FSM diagram/table or justified alternative included.
- [x] Logisim source and simulation evidence uploaded.
- [x] Verilog RTL and testbench uploaded.
- [x] Simulation results and test cases documented.
- [x] FPGA implementation (`.xdc` constraints and `.bit` bitstream) uploaded (ready for live board demo).
- [x] Results, challenges, task allocation, team reflection, and conclusion documented.
- [x] Presentation (2-slide PPT) and Final Project Report PDF uploaded.
- [x] `STATUS.md` is up to date.
- [x] Final Pull Request created and URL recorded (`PR #10`).