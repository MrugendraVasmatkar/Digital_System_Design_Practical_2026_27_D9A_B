# 02 – FSM and Logisim

| File | Contents |
|---|---|
| `Game_Score_Categorizer_H2_Mealy_Machine_v2_comparators.circ` | **Final Logisim source.** One 4-bit `SCORE` input, two comparators (SCORE < 5 gives LOW, SCORE > 10 gives HIGH, otherwise MEDIUM), two D flip-flops (`Q1_FF`, `Q0_FF`) and gate-level next-state and output logic |
| `circuit_overview_v2_comparators.png` | Screenshot of the final circuit |
| `Game_Score_Categorizer_H2_Mealy_Machine.circ` | Earlier version: four separate score pins S3–S0 with gate-level range logic (kept for reference) |
| `circuit_overview.png` | Screenshot of the earlier version |
| `sim_score13_high.png` | Logisim simulation screenshot: SCORE = 1101 (13), HIGH LED lit, LOW and MEDIUM off |
| `fsm_state_diagram.png` | FSM state diagram (IDLE, LOW, MEDIUM, HIGH; transitions labelled input / output) |
| `block_diagram.png` | Block diagram: score switches, range decoder, next-state logic, state register, state decoder, Mealy output logic, controls and LEDs |

The state table is in the group `README.md`, section 5.

**Simulation evidence so far:** `sim_score13_high.png` (SCORE = 13 gives the HIGH LED).

**Still to add:** simulation screenshots for LOW (e.g. score 2), MEDIUM (e.g. score 7), ACK and RESET, and the remaining scores 0-15, taken with the Poke tool.
