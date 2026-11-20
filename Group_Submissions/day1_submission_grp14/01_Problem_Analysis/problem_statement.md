# Problem Statement 3H2 and Analysis - Game Score Categorizer (Mealy FSM)

> **Problem 3H2:** the assigned task is the **Game Score Categorizer** (problem 3) with **hint H2, "Mealy FSM with immediate output"** as the group's sub-problem. The text below is transcribed from the faculty handout; a photo of the handout is saved as [`assigned_problem_statement_3H2.png`](assigned_problem_statement_3H2.png).

## 0. Assigned problem statement (from the handout)

**Base problem, Game Score Categorizer.** A 4-bit score (switches S3–S0) is classified into three categories:

| Score (dec) | Score[3:0] (bin) | Category (output) |
|---|---|---|
| 0–4 | 0000–0100 | LOW |
| 5–10 | 0101–1010 | MEDIUM |
| 11–15 | 1011–1111 | HIGH |

The base design (handout) is a Moore FSM with: a 4-bit input register, a range decoder (comparators), an FSM controller with state register, next-state and output logic, and three indicator LEDs (LOW green, MEDIUM yellow, HIGH red). Controls: START (load/sample score), ACK (return to IDLE), RESET (synchronous, active-high). States and encoding: IDLE 00 (all LEDs off), LOW 01, MEDIUM 10, HIGH 11.

**Q1, Logisim design:** design and simulate the complete FSM and datapath in Logisim (4-bit score input interface, range decoder, state register, next-state logic and output logic). Show the circuit diagram and verify all 16 input combinations (0 to 15).

**Q2, FSM state diagram:** draw the FSM state diagram and specify the state encoding and state outputs.

**Q3, Verilog testbench and verification:** write a Verilog testbench (Verilog only) to verify the design for all 16 score values (0 to 15), all four FSM states, reset, START/ACK operation and correct LED outputs. Include self-checking expected-result comparison, a test sequence and pass/fail messages.

**Hint H2, Mealy FSM with immediate output (the group's sub-problem):**
- Re-design the Game Score Categorizer using a Mealy FSM.
- Generate the score category output based on the current state and input (Score[3:0]).
- Draw the Mealy state diagram and implement it in Logisim and Verilog.

### How the group's work maps to the statement

| Requirement | Status | Where |
|---|---|---|
| Ranges LOW 0–4, MEDIUM 5–10, HIGH 11–15 | Matches the handout | RTL, Logisim (comparators), state table |
| Range decoder (comparators) | Done in Logisim v2 (SCORE < 5, SCORE > 10); in the RTL as comparisons | `02_FSM_Logisim/`, `mealy_simple.v` |
| Mealy FSM, outputs from current state and Score[3:0] (H2) | Done | `mealy_simple.v`, state table and diagram |
| Mealy state diagram, state encoding | Done | `02_FSM_Logisim/fsm_state_diagram.png`, README section 5 |
| Logisim and Verilog implementation | Done | `.circ`, `mealy_simple.v` |
| START, ACK, RESET behaviour (sync active-high reset) | Done | RTL, state table |
| 4-bit input register that START loads | **Differs:** the design has no separate 4-bit register; the score is read directly when START is seen in IDLE and the state register holds the category | RTL, block diagram |
| Logisim verified for all 16 inputs | **Pending** | simulation screenshots needed |
| Testbench for all 16 scores, all four states, reset, START/ACK | **Not yet:** the current testbench covers scores 2, 7 and 13 only | `game_tb.v` |
| Self-checking testbench with pass/fail messages | **Not yet:** the current testbench only prints values | `game_tb.v` |

---


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
