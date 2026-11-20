# 01 – Problem Analysis

## Problem statement
**Game Score Categorizer – Modification H1 (Four-Category Score Categorizer, Excellent added).**

A 4-bit game score (0 to 15) is set on four switches S3–S0. When the player presses START, the score is sampled and classified into one of four categories. A Moore FSM holds the result and lights one indicator LED until ACK is pressed, after which the system returns to IDLE and waits for the next score. RESET returns the system to IDLE at any time.

## Requirements
| ID | Requirement |
|---|---|
| R1 | Accept a 4-bit unsigned score `Score[3:0]` (0–15) from switches. |
| R2 | Store the score in a 4-bit input register. |
| R3 | Classify the stored score: **Low 0–4, Medium 5–8, High 9–12, Excellent 13–15** (H1). |
| R4 | Use a **Moore** FSM: outputs depend only on the present state. |
| R5 | States: IDLE, LOW, MEDIUM, HIGH, EXCELLENT (5 states, 3-bit binary encoding). |
| R6 | IDLE → category state when START = 1. |
| R7 | Category state → IDLE when ACK = 1. |
| R8 | RESET is synchronous and active-high; it forces IDLE. |
| R9 | One LED per category: Low = Green, Medium = Yellow, High = Red, Excellent = Blue. All LEDs off in IDLE. |
| R10 | Verify all 16 score values in Logisim and in a self-checking Verilog testbench. |

## Category table (H1)
| Score (Dec) | Score[3:0] (Bin) | Category | LED |
|---|---|---|---|
| 0 – 4 | 0000 – 0100 | LOW | Green |
| 5 – 8 | 0101 – 1000 | MEDIUM | Yellow |
| 9 – 12 | 1001 – 1100 | HIGH | Red |
| 13 – 15 | 1101 – 1111 | EXCELLENT | Blue |

## Inputs and outputs
| Signal | Direction | Width | Description |
|---|---|---|---|
| `clk` | Input | 1 | System clock (100 MHz on the board) |
| `reset` | Input | 1 | Synchronous, active-high reset to IDLE |
| `start` | Input | 1 | Sample the score and leave IDLE |
| `ack` | Input | 1 | Acknowledge the result and return to IDLE |
| `score[3:0]` | Input | 4 | Score from switches S3–S0 |
| `led_low` | Output | 1 | Green LED, LOW state |
| `led_medium` | Output | 1 | Yellow LED, MEDIUM state |
| `led_high` | Output | 1 | Red LED, HIGH state |
| `led_excellent` | Output | 1 | Blue LED, EXCELLENT state |

## Assumptions
1. Score is an unsigned 4-bit number, so every input 0–15 is valid; no error state is needed (that is H3, not ours).
2. The input register loads the switches on every clock while the FSM is in IDLE, and holds its value in every other state. The FSM reads the registered score.
3. In a category state, START and switch changes are ignored; only ACK (or RESET) leaves the state.
4. In IDLE, ACK has no effect.
5. RESET has the highest priority, then ACK/START as per the present state.
6. Unused state codes 101, 110, 111 go to IDLE on the next clock (safe recovery).
7. On the FPGA, START and ACK come from push buttons. A press lasts many clock cycles, but START is ignored outside IDLE and ACK is ignored in IDLE, so one press gives exactly one transition.

## Proposed solution
The design is split into a datapath and a controller:

1. **Input register (4-bit):** holds `Score[3:0]`; load enable = (present state is IDLE).
2. **Range decoder (comparators):** three 4-bit comparators (> 4, > 8, > 12) and a few gates produce one-hot `LOW, MEDIUM, HIGH, EXCELLENT` from the registered score.
3. **Moore FSM controller:** state register (3 D flip-flops) + next-state logic + output logic.
4. **Output logic:** drives the four category LEDs.

Range decoder using three 4-bit unsigned comparators (verified for all 16 inputs). Each comparator compares the registered score with a constant:

| Comparator | Compares | Output |
|---|---|---|
| C1 | Score > 4 | GT4 |
| C2 | Score > 8 | GT8 |
| C3 | Score > 12 | GT12 |

- LOW = GT4'  (Score ≤ 4)
- MEDIUM = GT4 · GT8'  (5 ≤ Score ≤ 8)
- HIGH = GT8 · GT12'  (9 ≤ Score ≤ 12)
- EXCELLENT = GT12  (Score ≥ 13)

## Distinctive feature (minimal)
Optimised Logisim implementation: the input register is a single 4-bit Register component and the outputs come from one 3-to-8 decoder on the state, reducing the circuit from 43 gates and 7 flip-flops to 23 gates, 3 flip-flops, one register and one decoder. Unused state codes 101, 110 and 111 return to IDLE on the next clock.

## Edge cases checked
| Case | Expected behaviour |
|---|---|
| Boundary scores 4/5, 8/9, 12/13 | Fall in the correct category |
| START held for many clocks | Moves once to the category, then stays until ACK |
| ACK while in IDLE | Stays in IDLE |
| Switches changed while showing a result | LED does not change until ACK |
| RESET in any state | IDLE, all LEDs off |
