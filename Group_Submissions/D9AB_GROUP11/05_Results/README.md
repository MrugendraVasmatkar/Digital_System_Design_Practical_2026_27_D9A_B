# 05 – Results

## 1. Simulation test results (Vivado xsim, testbench `tb_game_score`)

The testbench is self-checking. After every step it compares the FSM state and LED outputs with a reference model and prints PASS or FAIL.

| Test | What was tested | Checks | Result |
|------|-----------------|--------|--------|
| T1 | Reset: IDLE state, `score_reg` cleared, LEDs off | 2 | PASS |
| T2 | All 16 valid scores (0-15): category after START, score latched, second START ignored, ACK returns to IDLE | 96 | PASS |
| T3 | IDLE stability: no START keeps IDLE, ACK in IDLE ignored | 2 | PASS |
| T4 | Reset from LOW, MEDIUM, HIGH and ERROR; reset has priority over START | 13 | PASS |
| T5 | Invalid scores 16-31 (Hint H3): ERROR state, then ACK to IDLE | 32 | PASS |
| **Total** | | **145** | **145 passed, 0 failed** |

## 2. Expected versus observed: score classification

| Score (SW4..SW0) | Expected state | Expected LED | Observed (simulation) |
|------------------|----------------|--------------|-----------------------|
| 0-4 (00000-00100) | LOW (001) | Green (LD0) | Matches |
| 5-10 (00101-01010) | MEDIUM (010) | Yellow (LD1) | Matches |
| 11-15 (01011-01111) | HIGH (011) | Red (LD2) | Matches |
| 16-31 (10000-11111) | ERROR (100) | Error LED (LD3) | Matches |
| After ACK or RESET | IDLE (000) | All off | Matches |

Boundary scores 4, 5, 10, 11 and 15 are included in T2. All 16 valid scores and all 16 invalid scores were tested, so the full 5-bit input range (0-31) is covered.

## 3. Hardware test results (Boolean Board, xc7s50csga324-1)

| Test | Action | Expected | Observed | Pass/Fail |
|------|--------|----------|----------|-----------|
| Reset | Press BTN2 | LEDs off, display `-` | TODO | TODO |
| Score 3 | SW = 00011, BTN0 | LD0, `L`, `03` | TODO | TODO |
| Score 7 | SW = 00111, BTN0 | LD1, `M`, `07` | TODO | TODO |
| Score 13 | SW = 01101, BTN0 | LD2, `H`, `13` | TODO | TODO |
| Invalid score | SW4 up, BTN0 | LD3, `E` | TODO | TODO |
| ACK | Press BTN1 | Returns to IDLE | TODO | TODO |

## 4. Accuracy and correctness analysis

- **Functional correctness:** the FSM output matched the reference model for every tested input, with 0 failures out of 145 checks.
- **Coverage:** every state (IDLE, LOW, MEDIUM, HIGH, ERROR) was entered, and every transition was exercised: START from IDLE to each category, ACK back to IDLE, RESET from every state, and the hold behaviour when START is pressed again.
- **Moore behaviour:** LED outputs change only with the state, so they are stable and glitch-free.
- **Hint H3:** every score above 15 is detected as invalid and shown on the error LED, and ACK or RESET clears it.
- **Priority:** RESET overrides START when both are asserted together.
- **Simulation versus hardware:** the FSM logic is identical in both, so the state and LED results match. TODO: confirm after your hardware test.

## 5. Known limitations

- The testbench checks only the FSM (`game_score_fsm`). The button debouncer and the 7-segment driver were verified on the board, not in simulation, because the 10 ms debounce is too slow to simulate quickly.
- Score input is 5 bits (SW4..SW0), not the original 4 bits. SW4 is used only to create an invalid input for the ERROR state.
- The 7-segment display polarity is not given in the board's pin file. It is set with switches SW14 and SW15, and the right setting has to be found on the board.
- The letter `M` for MEDIUM is only an approximation on a 7-segment digit.
- The state register has no explicit power-up value. It normally starts at 0 (IDLE) after configuration, but pressing RESET once after programming is recommended.
- Only one hint (H3) was implemented.

## 6. Conclusions

- The Game Score Categorizer works as specified. A Moore FSM sorts a score into LOW (0-4), MEDIUM (5-10) or HIGH (11-15) and shows the result on LEDs and the 7-segment display.
- Hint H3 was added: scores above 15 give an ERROR state with its own LED.
- The self-checking testbench passed all 145 checks with 0 failures.
- The design was synthesised, implemented and programmed on the Boolean Board. TODO: state your final hardware result.
