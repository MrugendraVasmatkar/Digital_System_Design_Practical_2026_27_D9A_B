# 01 – Problem Analysis: Gaming XP Level Decoder (H4)

## 1. Problem Statement
Design and implement a synchronous digital system (**Gaming XP Level Decoder – H4**) that accepts a 4-bit unsigned Experience Points (`XP[3:0]`, range `0–15`) input, classifies the player into one of three skill tiers (**Beginner**, **Intermediate**, or **Expert**), illuminates the corresponding level LED until acknowledged (`ACK`), and maintains cumulative **4-bit counts** of how many times each tier has been detected across multiple entries.

## 2. Requirements
* **Base Classification & LED Indication:**
  * **Beginner (`0–3`):** Turns ON `led_beg` (Green)
  * **Intermediate (`4–10`):** Turns ON `led_int` (Yellow)
  * **Expert (`11–15`):** Turns ON `led_exp` (Red)
* **Handshake Control (`START` / `ACK`):**
  * Latches `XP[3:0]` and transitions from `IDLE` to the detected level state on a rising clock edge when `START = 1`.
  * Holds the active LED state until `ACK = 1` returns the FSM to `IDLE` and turns all LEDs OFF.
* **H4 Extension – Cumulative Level Counters:**
  * Three independent **4-bit counters** (`beg_count[3:0]`, `int_count[3:0]`, `exp_count[3:0]`) increment by `+1` once per valid detection (`START = 1` in `IDLE`).
  * Counts persist across `ACK` cycles and clear to `0000` only when `RESET = 1`.

## 3. Input / Output Definitions
| Signal | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1-bit | System clock (positive-edge triggered) |
| `reset` | Input | 1-bit | Synchronous active-high reset (resets FSM to `IDLE` and all counters to `0`) |
| `start` | Input | 1-bit | Triggers XP sampling, level classification, and counter increment when in `IDLE` |
| `ack` | Input | 1-bit | Acknowledges active LED output and returns FSM to `IDLE` |
| `xp_in[3:0]` | Input | 4-bit | Unsigned player XP value (`0` to `15`) |
| `led_beg` | Output | 1-bit | High (`1`) when FSM is in `BEG` state (`XP` `0–3`) |
| `led_int` | Output | 1-bit | High (`1`) when FSM is in `INT` state (`XP` `4–10`) |
| `led_exp` | Output | 1-bit | High (`1`) when FSM is in `EXP` state (`XP` `11–15`) |
| `beg_count[3:0]` | Output | 4-bit | Cumulative count of Beginner detections |
| `int_count[3:0]` | Output | 4-bit | Cumulative count of Intermediate detections |
| `exp_count[3:0]` | Output | 4-bit | Cumulative count of Expert detections |

## 4. Assumptions & Constraints
* **Unsigned Arithmetic:** `XP[3:0]` is treated strictly as an unsigned binary integer (`0000` = `0` to `1111` = `15`).
* **Counter Width (4-Bit):** Across a full 16-value test sweep (`0–15`), Beginner occurs `4` times, Intermediate `7` times, and Expert `5` times; 4-bit counters (`0–15` range) prevent overflow.
* **Single-Cycle Enable Gating:** Counter increment and input latching are gated by `START && (state == IDLE)` so holding `START = 1` across multiple clock cycles never double-counts an entry.
* **Moore FSM Output:** LED outputs depend solely on the current FSM state (`IDLE = 00`, `BEG = 01`, `INT = 10`, `EXP = 11`).

## 5. Proposed Solution
1. **Input Register (`4-bit`):** Captures `xp_in[3:0]` synchronously on `START && (state == IDLE)` to isolate combinational logic from mid-cycle switch changes.
2. **XP Range Comparator:** Two 4-bit unsigned magnitude comparators (`XP <= 3` and `XP > 10`) decode the latched XP into three mutually exclusive one-hot flags (`Beg_Flag`, `Int_Flag`, `Exp_Flag`).
3. **Parallel 4-Bit Level Counters with Pass-Through:** Three 4-bit synchronous up-counters increment on `Flag && START && (state == IDLE)` while passing the 1-bit level flags directly to the FSM.
4. **4-State Moore FSM Controller:** Transitions from `IDLE` to `BEG`, `INT`, or `EXP` on `START = 1` to drive the corresponding LED, and returns to `IDLE` when `ACK = 1`.
