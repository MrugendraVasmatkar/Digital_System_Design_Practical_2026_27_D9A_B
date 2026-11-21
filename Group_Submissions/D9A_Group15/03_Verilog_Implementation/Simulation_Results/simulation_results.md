# Verilog Simulation Results – Game Score Categorizer (H4)

**Tool:** Vivado 2018.3, Behavioral Simulation (XSim), top module `tb_game_score_categorizer`.
**Design under test:** `game_score_categorizer` (`../RTL/game_score_categorizer.v`). **Testbench:** `../Testbench/tb_game_score_categorizer.v` (self-checking).

## Result

The simulation ran to `$finish` at 1760 ns with:

```
Checks run: 88   Errors: 0
TEST PASSED
```

Evidence: `sim_console_test_passed.png`.

## What the testbench checks

| Test | Description | Checks |
|---|---|---|
| 1 | Every score 0 to 15 gives the correct category (LOW 0-4, MEDIUM 5-10, HIGH 11-15), is counted once, holds when `START` is pressed again with a different score, and `ACK` returns to IDLE | 49 |
| 2 | `START` held for 3 clocks counts only once; `ACK` returns to IDLE | 2 |
| 3 | No `START`: stays IDLE even if the score changes or `ACK` is pressed | 2 |
| 4 | 16 LOW detections wrap the 4-bit counter back to its old value | 32 |
| 5 | Asynchronous `RESET` clears the state and all three counters | 3 |
| | **Total** | **88** |

## Waveforms

- `sim_waveform_all_16_scores.png`: first ~1000 ns (Test 1). `low_count` rises 1 to 5 for scores 0-4, `med_count` rises to 6 for scores 5-10, `high_count` rises to 5 for scores 11-15, and `state_out` alternates between IDLE and the category state.
- `sim_waveform_zoom_detections.png`: zoomed view of 350-700 ns showing the START/ACK pulses, `state_out` moving between 0 and 2, and `med_count` rising 1 to 6.

The waveforms cover Test 1 only; Tests 2 to 5 are verified by the self-checking log above.