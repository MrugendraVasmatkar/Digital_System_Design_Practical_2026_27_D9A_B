# 05 – Results

## 1. Test-Case Table & Expected vs. Observed Comparison

Verified using Xilinx Vivado 2018.3 behavioral simulation (`tb_gaming_xp.v`, `10 ns` clock period) and Logisim functional testing:

| Test Case | Time Window | Input (`xp_in`) | Control Inputs | Expected Output (`LED` & `State`) | Expected Counts (`Beg, Int, Exp`) | Observed Result | Status |
|---:|:---:|:---:|---|---|---|---|---|
| 1 | `0–20 ns` | `0` (`0000`) | `reset = 1` | `IDLE (00)`, all LEDs `0` | `0, 0, 0` | `IDLE`, all LEDs `0`, counts `0, 0, 0` | PASS |
| 2 | `35–65 ns` | `2` (`0010`) | `start = 1`, `ack = 0` | `BEG (01)`, `led_beg = 1` | `1, 0, 0` | `led_beg = 1`, `beg_count = 1` | PASS |
| 3 | `65–95 ns` | `2` (`0010`) | `start = 0`, `ack = 1` | `IDLE (00)`, all LEDs `0` | `1, 0, 0` | `led_beg = 0`, `beg_count` held at `1` | PASS |
| 4 | `95–155 ns` | `7` (`0111`) | `start = 1` → `ack = 1` | `INT (10)` → `IDLE (00)` | `1, 1, 0` | `led_int` active until `ack`, `int_count = 1` | PASS |
| 5 | `155–215 ns` | `14` (`1110`) | `start = 1` → `ack = 1` | `EXP (11)` → `IDLE (00)` | `1, 1, 1` | `led_exp` active until `ack`, `exp_count = 1` | PASS |
| 6 | `215–270 ns` | `1` (`0001`) | `start = 1` → `ack = 1` | `BEG (01)` → `IDLE (00)` | `2, 1, 1` | `led_beg` active until `ack`, `beg_count = 2` | PASS |

## 2. Full 4-Bit Input Sweep (`0–15`) Verification

Across all 16 possible unsigned 4-bit XP values (`0000` to `1111`):

| Skill Tier | XP Range | Total Valid Inputs | Expected Counter Value | Observed Counter Value | Status |
|---|---:|---:|---:|---:|---|
| Beginner | `0–3` | `4` (`0, 1, 2, 3`) | `4` (`0100`) | `4` (`0100`) | PASS |
| Intermediate | `4–10` | `7` (`4, 5, 6, 7, 8, 9, 10`) | `7` (`0111`) | `7` (`0111`) | PASS |
| Expert | `11–15` | `5` (`11, 12, 13, 14, 15`) | `5` (`0101`) | `5` (`0101`) | PASS |

## 3. Accuracy & Correctness Analysis
- **100% Classification Accuracy:** Unsigned magnitude comparators (`<= 3`, `4–10`, `>= 11`) produce mutually exclusive one-hot tier flags across all 16 input combinations with zero boundary overlap.
- **Zero Double-Counting:** Gating counter enables with `start && (state == IDLE)` ensures each transaction increments its tier counter by exactly `+1` on the rising clock edge, even if `start` remains asserted across multiple cycles.
- **Rollover Prevention (H4 Requirement):** Using 4-bit counters (`0–15` range) prevents overflow during a complete 16-value test sweep where Intermediate reaches `7` (`0111`).
- **Glitch-Free Moore Outputs:** Level indicator LEDs depend strictly on the registered FSM state (`IDLE`, `BEG`, `INT`, `EXP`), preventing combinational hazards when `xp_in` switches change mid-round.

## 4. Known Limitations & Future Scope
- **4-Bit Counter Ceiling (`15` Detections):** Each tier counter saturates/rolls over after `15` detections in the same tier; extending counter width to 8 bits would support longer gaming sessions.
- **Synchronous `ack` Handshake:** Requires a manual `ack` pulse to return from an active LED state to `IDLE`; a configurable auto-timeout counter could be added for hands-free operation.

## 5. Conclusion
The Gaming XP Level Decoder (Problem Statement 8 — Hint H4) was successfully designed, simulated, and verified across Logisim and Xilinx Vivado (`xc7s25csga324-1`). All functional requirements—including range classification, `start`/`ack` handshaking, synchronous reset, and cumulative 4-bit tier counting—performed with 100% accuracy.
