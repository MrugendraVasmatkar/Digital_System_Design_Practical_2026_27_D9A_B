# Problem Analysis – Game Score Categorizer (Moore FSM + H4 Category Counters)

**Class:** D9A | **Group ID:** D9A_Group15 | **Selected modification:** H4 – Category Counters

## 1. Problem summary
The Game Score Categorizer reads a 4-bit score (0–15) and sorts it into one of three categories:

| Category | Score range |
|---|---|
| LOW | 0 – 4 |
| MEDIUM | 5 – 10 |
| HIGH | 11 – 15 |

A Moore FSM holds the detected category and drives one indicator LED per category until the user acknowledges. Modification **H4** adds three counters that record how many times each category has been detected.

## 2. Objectives
- Classify every score from 0 to 15 into the correct category.
- Hold the category and its LED until `ACK` is given.
- Count each detection exactly once in the counter of its category (H4).
- Clear the state and all counters on `RESET`.
- Verify the design in Logisim, implement it in synthesizable Verilog, and demonstrate it on the Real Digital Boolean Board (xc7s50csga324-1).

## 3. Inputs and outputs

| Signal | Direction | Width | Description |
|---|---|---|---|
| `Score[3:0]` | Input | 4 | Score from the switches |
| `START` | Input | 1 | Classify and latch the score (acted on only in IDLE) |
| `ACK` | Input | 1 | Return from a category state to IDLE |
| `RESET` | Input | 1 | Clear state and counters (asynchronous, active-high) |
| `CLK` | Input | 1 | System clock |
| `LOW_LED` | Output | 1 | Indicates LOW category |
| `MEDIUM_LED` | Output | 1 | Indicates MEDIUM category |
| `HIGH_LED` | Output | 1 | Indicates HIGH category |
| `LOW_COUNT[3:0]` | Output | 4 | Number of LOW detections (H4) |
| `MEDIUM_COUNT[3:0]` | Output | 4 | Number of MEDIUM detections (H4) |
| `HIGH_COUNT[3:0]` | Output | 4 | Number of HIGH detections (H4) |

## 4. Requirements
1. The category is decided by comparing the score with two thresholds: score < 5 is LOW, score > 10 is HIGH, otherwise MEDIUM.
2. The score is read only when `START` is applied while the FSM is in IDLE.
3. The FSM stays in the detected category state until `ACK` is applied.
4. Exactly one counter is incremented per detection, on the transition from IDLE into a category state.
5. `RESET` returns the FSM to IDLE and clears all three counters.

## 5. Assumptions
- The score range is 0–15, so every 4-bit input value is valid; no error state is needed.
- On the FPGA board, `START` and `ACK` are converted into single-clock pulses after debouncing.
- Each counter is 4 bits wide and wraps from 15 back to 0.
- While the FSM is in a category state, further `START` pulses and score changes are ignored.
- `ACK` in IDLE has no effect.

## 6. Constraints
- Design style: FSM (Moore) plus a datapath of comparators and counters.
- Logisim implementation first, then synthesizable Verilog, then FPGA.
- Target board: Real Digital Boolean Board (xc7s50csga324-1), 100 MHz clock.

## 7. Edge cases considered
- Boundary scores 4, 5, 10 and 11.
- `START` held high for several clocks (must count once only).
- `START` applied again while in a category state (must be ignored).
- `ACK` applied in IDLE.
- Counter overflow after 16 detections of one category.
- `RESET` applied while in a category state.

## 8. Proposed solution
- **Range decoder:** two comparators on `Score[3:0]` (score < 5 and score > 10) produce the signals `L` (LOW), `H` (HIGH) and `M` (MEDIUM = neither).
- **Moore FSM:** 2-bit state register with encoding IDLE = 00, LOW = 01, MEDIUM = 10, HIGH = 11, and next-state logic driven by `START`, `ACK` and the range decoder.
- **Output logic:** the LEDs are decoded from the state bits only (Moore outputs).
- **H4 counters:** three 4-bit counters, each enabled by `GO · category`, where `GO = IDLE · START`, so each detection counts once.

**Distinctive features**
- Count-once behaviour: the counter enable is tied to the IDLE-to-category transition, not to the held `START` level.
- Asynchronous reset for the state register and counters.
- Board version adds button debouncing, single-pulse `START`/`ACK`, and a multiplexed 7-segment display showing the state and the three counts.

## 9. Feasibility
The design needs only two comparators, a small amount of gate logic, a 2-bit state register and three 4-bit counters (14 flip-flops in total). It is well within the resources of the Spartan-7 device at 100 MHz. Actual utilization figures (LUTs, flip-flops, Carry4) will be added from the Vivado report in `04_FPGA_Hardware/`.
