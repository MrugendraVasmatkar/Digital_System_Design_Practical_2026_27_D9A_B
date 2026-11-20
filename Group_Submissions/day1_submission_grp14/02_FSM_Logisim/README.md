# 02 – FSM and Logisim

| File | Contents |
|---|---|
| `Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` | **Final Logisim source.** One 4-bit `SCORE` input, two comparators (SCORE < 5 gives LOW, SCORE > 10 gives HIGH, otherwise MEDIUM), two D flip-flops (`Q1_FF`, `Q0_FF`) and gate-level next-state and output logic |
| `circuit_overview_v2_comparators.png` | Screenshot of the final circuit |
| `Game_Score_Categorizer_H2_Mealy_Machine.circ` | Earlier version: four separate score pins S3–S0 with gate-level range logic (kept for reference) |
| `circuit_overview.png` | Screenshot of the earlier version |
| `sim_score13_high.png` | Logisim simulation screenshot: SCORE = 1101 (13), HIGH LED lit, LOW and MEDIUM off |
| `low.png`, `medium.png`, `high.png`, `idle.png` | Logisim simulation screenshots (by Siddharth and Deven): SCORE = 3 gives LOW, SCORE = 5 gives MEDIUM, SCORE = 13 gives HIGH, IDLE shows all LEDs off |
| `logisim_test_plan.md` | Step-by-step plan and expected-results table for verifying all 16 scores, ACK and RESET in Logisim (observed column to be filled) |
| `fsm_state_diagram.png` | FSM state diagram (IDLE, LOW, MEDIUM, HIGH; transitions labelled input / output) |
| `block_diagram.png` | Block diagram: score switches, range decoder, next-state logic, state register, state decoder, Mealy output logic, controls and LEDs |

The state table is in the group `README.md`, section 5.

**Simulation evidence so far** (screenshots by Siddharth and Deven): `low.png` (SCORE = 3, LOW LED), `medium.png` (SCORE = 5, MEDIUM LED), `high.png` and `sim_score13_high.png` (SCORE = 13, HIGH LED), `idle.png` (IDLE, all LEDs off).

**Still to add:** ACK, RESET, the boundary scores 4, 10 and 11, and the remaining scores 0-15 (see `logisim_test_plan.md`).
