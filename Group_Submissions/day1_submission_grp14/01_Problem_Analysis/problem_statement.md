# Problem Statement 3H2 and Analysis - Game Score Categorizer (Mealy FSM)

> **Note:** Problem statement number: 3H2. The official statement text from faculty is not copied here; this analysis is derived from the group's design (`mealy_simple.v`, `Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ`). Confirm the wording below against the assigned statement.

## 1. Problem summary (Problem 3H2)

Design a digital system that categorises a game score into **LOW**, **MEDIUM** or **HIGH** and shows the result on an LED. The user presents a 4-bit score and asserts `start`. The matching LED stays on until the user acknowledges with `ack`, after which the system returns to its idle state for the next round.

## 2. Objective

- Read a 4-bit score (0–15) when `start` is asserted.
- Classify the score and light exactly one of three LEDs.
- Hold the result until `ack`, then clear it and wait for a new round.
- Implement it as a **Mealy FSM**: outputs depend on the current state **and** the current inputs (`start`, `score`, `ack`).

## 3. Operating assumptions

| # | Assumption |
|---|---|
| 1 | Score is an unsigned 4-bit value, 0 to 15. |
| 2 | **LOW:** score 0–4. **MEDIUM:** score 5–10. **HIGH:** score 11–15. |
| 3 | `start` is only acted on in `IDLE`; `start` in any other state is ignored. |
| 4 | `ack` is only acted on in `LOW`, `MED` or `HIGH`; `ack` in `IDLE` is ignored. |
| 5 | The score is sampled on the clock edge on which `start` is seen in `IDLE`; later changes to `score` do not change the result of that round. |
| 6 | Reset is synchronous and active-high; it forces the FSM to `IDLE`. |
| 7 | At most one LED is on at any time; all LEDs are off in `IDLE` unless `start` is asserted (Mealy response). |

## 4. Edge cases considered

| Case | Expected behaviour |
|---|---|
| score = 4 / 5 | Boundary: 4 → LOW, 5 → MEDIUM |
| score = 10 / 11 | Boundary: 10 → MEDIUM, 11 → HIGH |
| score = 0 and score = 15 | Extremes: LOW and HIGH respectively |
| `start` held high for several cycles | Only the first edge in `IDLE` starts a round; FSM then holds its result state |
| `ack` without a result shown (`IDLE`) | Ignored |
| `ack` and `start` together while in a result state | FSM returns to `IDLE`; `start` is not reused for a new round in the same cycle |
| `reset` during a result state | FSM returns to `IDLE` |

## 5. Proposed solution

A single Mealy FSM with a 2-bit state register and combinational output logic:

| State | Code | Meaning |
|---|---|---|
| `IDLE` | 00 | Waiting for `start` |
| `LOW` | 01 | LOW result displayed |
| `MED` | 10 | MEDIUM result displayed |
| `HIGH` | 11 | HIGH result displayed |

- **Next state:** from `IDLE`, if `start`, go to `LOW`/`MED`/`HIGH` by comparing `score`; from a result state, `ack` → `IDLE`.
- **Mealy outputs:** the LED lights in the same cycle that `start` is asserted in `IDLE` (before the state register updates), then stays on from the state until `ack`.
- **Implementations:** Logisim gate-level circuit (`02_FSM_Logisim/`), Verilog RTL (`03_Verilog_Implementation/RTL/mealy_simple.v`), FPGA pins in `04_FPGA_Hardware/constraints.xdc`.

## 6. Important design note (timing)

Because the outputs are Mealy, `low_led`/`med_led`/`high_led` respond combinationally to `start`, `score` and `ack`. Inputs should be stable around the clock edge. On hardware, mechanical push-buttons/switches (`start`, `ack`) need debouncing or slow-clock stepping to avoid false multiple triggers.

## 7. Feasibility

Very small design: 2 flip-flops and a few gates; fits easily on any FPGA board. All 11 ports map to board pins (see `io_specification.md`).

## 8. Possible improvements (uniqueness / efficiency)

- Add input synchronisers and a debouncer for `start`/`ack` on hardware.
- Display the score and result on a seven-segment display.
- Make the LOW/MEDIUM thresholds parameters.
