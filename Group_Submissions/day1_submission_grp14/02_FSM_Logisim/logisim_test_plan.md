# Logisim test plan (all 16 inputs) - problem 3H2

Circuit: `Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` (Logisim). The handout (Q1) asks to verify all 16 input combinations (0 to 15).

## How to run each test (Poke tool)
1. Click **RESET** to 1, tick the clock once (Ctrl+T), then set RESET back to 0. The circuit is now in IDLE and all LEDs are off.
2. Click the **SCORE** pin and set the value from the table.
3. Set **START** to 1. The expected LED lights immediately (Mealy output), before the clock ticks. Take screenshot **A** here.
4. Tick the clock once (Ctrl+T), then set **START** back to 0. The LED stays on (state held). Take screenshot **B** if wanted.
5. Set **ACK** to 1. The LED turns off. Tick the clock once, then set ACK back to 0. The circuit is back in IDLE.

Screenshot with Windows + Shift + S on the Logisim window (not File > Export image). The screenshot must show the SCORE value, START, and the lit LED. Name files `sim_score<N>_<low|med|high>.png`.

## Expected results (fill the last column from the simulation)

| Score (dec) | SCORE (bin) | Expected LED | Observed LED | Screenshot |
|---:|---|---|---|---|
| 0 | 0000 | LOW | | |
| 1 | 0001 | LOW | | |
| 2 | 0010 | LOW | | |
| 3 | 0011 | LOW | LOW lit | `low.png` |
| 4 | 0100 | LOW | | |
| 5 | 0101 | MEDIUM | MEDIUM lit | `medium.png` |
| 6 | 0110 | MEDIUM | | |
| 7 | 0111 | MEDIUM | | |
| 8 | 1000 | MEDIUM | | |
| 9 | 1001 | MEDIUM | | |
| 10 | 1010 | MEDIUM | | |
| 11 | 1011 | HIGH | | |
| 12 | 1100 | HIGH | | |
| 13 | 1101 | HIGH | `sim_score13_high.png` shows HIGH lit | `high.png`, `sim_score13_high.png` |
| 14 | 1110 | HIGH | | |
| 15 | 1111 | HIGH | | |

Probe pins for a quick check: `LOWc` = 1 for scores 0-4, `MEDc` = 1 for 5-10, `HIGHc` = 1 for 11-15.

## Extra cases (state and control behaviour)

| Test | Steps | Expected |
|---|---|---|
| ACK clears the result | After any START above, set ACK = 1 | All LEDs off immediately; IDLE after the next clock |
| ACK ignored in IDLE | In IDLE (START = 0), set ACK = 1, tick | All LEDs stay off |
| START ignored in a result state | While LOW is shown, set SCORE to 13 and START = 1, tick | LOW LED stays on (score is not re-read) |
| RESET from a result state | While any LED is on, set RESET = 1, tick once, set RESET = 0 | LEDs off, back in IDLE |

## Minimum set if time is short
Scores 0, 4, 5, 10, 11, 15 (the boundaries and extremes), plus one ACK and one RESET screenshot. Together with the existing score 13 screenshot this exercises every state and every threshold.
