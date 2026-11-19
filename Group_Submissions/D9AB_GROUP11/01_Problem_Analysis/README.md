# 01 – Problem Analysis

Upload the problem statement, requirements, assumptions, input/output definitions, constraints and proposed solution explanation here.

## 1. Problem requirements

Function. The system reads a 4-bit game score (0–15) from switches S3–S0 and classifies it into one of three categories. It shows the result on indicator LEDs through a Moore FSM controller.

| Score (dec) | Score[3:0] | Category | LED |
| :-: | :-: | :-: | :-: |
| 0–4 | 0000–0100 | LOW | Green |
| 5–10 | 0101–1010 | MEDIUM | Yellow |
| 11–15 | 1011–1111 | HIGH | Red |

Architecture (from the block diagram).

- 4-bit input register: holds the score when START is pressed.
- Range decoder (combinational): compares the stored score against 4 and 10 to produce LOW, MEDIUM and HIGH.
- Moore FSM controller: has a state register, next-state logic and output logic.
- Indicator outputs: LOW LED, MEDIUM LED and HIGH LED.

FSM behaviour (Moore).

- States and encoding: IDLE = 00 (all LEDs off), LOW = 01, MEDIUM = 10, HIGH = 11.
- IDLE goes to LOW, MEDIUM or HIGH when START is applied, according to the score range.
- Any category state returns to IDLE when ACK = 1. It holds its state while ACK = 0.
- RESET forces the FSM to IDLE.
- Outputs depend only on the current state, which is what makes it a Moore machine.

Deliverables.

- Q1: a Logisim design with the input register, range decoder, state register, next-state logic and output logic, verified on all 16 inputs.
- Q2: the Moore state diagram with state encoding and state outputs.
- Q3: a Verilog testbench that covers all 16 scores, reset, START/ACK, expected-result comparison and pass/fail messages.
- Modification: one of H1–H5 (select any 1).

## 2. Modification chosen

Your Vivado design uses H3, the ERROR state for invalid input. If the input is outside 0–15, an error LED is asserted. The FSM returns to IDLE after RESET or ACK.

## 3. Assumptions

1. Clocking: All state and register updates happen on the rising clock edge. START, ACK and RESET are sampled synchronously, and RESET is active-high.
2. Button handling: START and ACK are used as single-cycle pulses. In Vivado the `btn_cond` blocks debounce the buttons and generate the pulse. Logisim has no debouncer, so the clock is stepped manually and the button is held for one tick.
3. Score capture: The score is sampled only when START is applied in IDLE. Changing the switches afterwards does not change the category.
4. Input width: The score input is 5 bits, `sw[4:0]`. Bits 3:0 hold the score and bit 4 marks an out-of-range value (16 or more), which leads to the ERROR state.
5. Thresholds: LOW is 4 or less, MEDIUM is 5–10 and HIGH is 11–15.
6. Priority: RESET has priority over ACK, and ACK has priority over START.
7. START outside IDLE: START is ignored in any state other than IDLE, so the result stays latched until ACK or RESET.
8. State encoding: The base design uses 2 bits (00, 01, 10, 11). Adding ERROR needs 3 bits, so the extended encoding is IDLE = 000, LOW = 001, MEDIUM = 010, HIGH = 011 and ERROR = 100.
9. Outputs: Exactly one LED is on in a category state, and none are on in IDLE. The ERROR LED is on only in the ERROR state.
10. Initial state: The FSM starts in IDLE after power-up or reset.
11. Display: The 7-segment display in the Vivado design is extra. It shows the stored score and state, and it is not part of the required Logisim circuit.
## 4. Proposed solution explanation

Overview. The system implements a synchronous Moore Finite State Machine (FSM) that samples a 5-bit score input on a start pulse, decodes its range combinationally, and latches the corresponding category on indicator LEDs until acknowledged or reset.

Datapath and control breakdown.

- Input conditioning (`btn_cond`): Synchronizes asynchronous pushbuttons (`START` and `ACK`) to the system clock, debounces mechanical bounce, and outputs a clean single-cycle pulse.
- Input register: A 5-bit D flip-flop register with synchronous enable (`START_pulse && current_state == IDLE`). It captures `sw[4:0]` only when starting a new classification so mid-cycle switch changes do not corrupt the active result.
- Range decoder (combinational): Evaluates the registered 5-bit value `reg_score[4:0]` into four mutually exclusive flags:
  - `is_err`: `reg_score[4] == 1` (values 16–31)
  - `is_low`: `!reg_score[4] && (reg_score[3:0] <= 4'd4)` (values 0–4)
  - `is_med`: `!reg_score[4] && (reg_score[3:0] >= 4'd5) && (reg_score[3:0] <= 4'd10)` (values 5–10)
  - `is_high`: `!reg_score[4] && (reg_score[3:0] >= 4'd11)` (values 11–15)
- Moore FSM controller: Uses a 3-bit state register updated on the rising clock edge. Because it is a Moore machine, output LEDs are decoded strictly from `current_state` without combinational paths from inputs.

State encoding and outputs.

| State | Encoding | Green (LOW) | Yellow (MEDIUM) | Red (HIGH) | Error LED |
| :-: | :-: | :-: | :-: | :-: | :-: |
| IDLE | 000 | 0 | 0 | 0 | 0 |
| LOW | 001 | 1 | 0 | 0 | 0 |
| MEDIUM | 010 | 0 | 1 | 0 | 0 |
| HIGH | 011 | 0 | 0 | 1 | 0 |
| ERROR | 100 | 0 | 0 | 0 | 1 |

State transition flow.

1. Reset (`RESET = 1`): Overrides all inputs and forces the state register to `IDLE (000)` on the rising clock edge.
2. From `IDLE (000)`: When `START_pulse = 1`, the FSM transitions to `LOW`, `MEDIUM`, `HIGH`, or `ERROR` based on the range decoder flags. Otherwise, it remains in `IDLE`.
3. From `LOW`, `MEDIUM`, `HIGH`, or `ERROR`: The FSM ignores `START_pulse` and holds its current state while `ACK_pulse = 0`. When `ACK_pulse = 1`, it returns to `IDLE (000)`.

Verification strategy.

- Logisim simulation: Step through all 16 valid switch combinations (`0000` to `1111`), verify single-tick `START` latching, confirm switch immunity while latched, and verify `ACK` and `RESET` transitions.
- Verilog testbench: Automates exhaustive testing across all 32 input combinations (`0–31`, covering both valid scores and the `H3` out-of-range `ERROR` condition), checks expected LED outputs against actual outputs, and logs pass/fail status per test case.

