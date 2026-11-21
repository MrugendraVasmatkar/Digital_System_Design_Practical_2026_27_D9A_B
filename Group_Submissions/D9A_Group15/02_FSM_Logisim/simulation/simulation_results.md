# Logisim Simulation Results – Game Score Categorizer (H4)

Circuit: `../Game_Score_Categorizer_H4.circ`. Screenshots were taken in Logisim simulation mode with the Poke tool; live pin values, LEDs and counts are visible in each image. State registers `STATE_Q1`/`STATE_Q0` give the state code (IDLE 00, LOW 01, MEDIUM 10, HIGH 11).

## Tests completed

| Test | Inputs | Expected | Observed | Result | Evidence |
|---|---|---|---|---|---|
| T1 Reset / IDLE | `RESET`=1 | State IDLE (00), all LEDs off, all counts 0 | Q1/Q0 = 0/0, all LEDs off, `LOW_COUNT`=`MEDIUM_COUNT`=`HIGH_COUNT`=0000 | Pass | `sim_01_reset_idle.png` |
| T2 LOW category | `Score`=0011 (3), `START`=1 | State LOW (01), `LOW_LED` on, `LOW_COUNT`=1 | Q1/Q0 = 0/1, `LOW_LED` lit (green), `LOW_COUNT`=0001, `MEDIUM_COUNT`=0000, `HIGH_COUNT`=0000 | Pass | `sim_02_low_score3.png` |
| T3 MEDIUM category | `Score`=0111 (7), `START`=1 | State MEDIUM (10), `MEDIUM_LED` on, `MEDIUM_COUNT` +1 | Q1/Q0 = 1/0, `MEDIUM_LED` lit (yellow), `LOW_COUNT`=0001, `MEDIUM_COUNT`=0001, `HIGH_COUNT`=0000 | Pass | `sim_03_medium_score7.png` |
| T4 HIGH category | `Score`=1100 (12), `START`=1 | State HIGH (11), `HIGH_LED` on, `HIGH_COUNT` +1 | Q1/Q0 = 1/1, `HIGH_LED` lit (red), counts LOW/MEDIUM/HIGH = 0001/0001/0001 | Pass | `sim_04_high_score12.png` |
| T5 ACK returns to IDLE | `ACK`=1 after a category detection (`START` still 1, `Score`=1100) | State IDLE (00), LEDs off, counts unchanged | Q1/Q0 = 0/0, all LEDs off, counts still 0001/0001/0001 | Pass | `sim_05_ack_return_idle.png` |
| T6 State holds | In HIGH after a score-12 detection, no ACK; then Score changed to 0001 (1) with START=1 | State stays HIGH, no counter changes, even though score 1 would be LOW | Q1/Q0 = 1/1, HIGH_LED still lit (red), counts LOW/MEDIUM/HIGH = 0000/0000/0001; GO = 0 | Pass | `sim_06_hold_state.png` |
| T7 Boundary score 4 | `Score`=0100 (4), `START`=1 | LOW | Q1/Q0 = 0/1, `LOW_LED` lit (green), counts LOW/MEDIUM/HIGH = 0001/0000/0001 | Pass | `sim_07_score4_low.png` |
| T8 Boundary score 5 | `Score`=0101 (5), `START`=1 | MEDIUM | Q1/Q0 = 1/0, `MEDIUM_LED` lit (yellow), counts 0001/0001/0001 | Pass | `sim_08_score5_medium.png` |
| T9 Score 9 (mid MEDIUM) | `Score`=1001 (9), `START`=1 | MEDIUM | Q1/Q0 = 1/0, `MEDIUM_LED` lit (yellow), counts 0001/0010/0001 | Pass | `sim_09_score9_medium.png` |
| T10 Boundary score 11 | `Score`=1011 (11), `START`=1 | HIGH | Q1/Q0 = 1/1, `HIGH_LED` lit (red), counts 0001/0010/0010 | Pass | `sim_10_score11_high.png` |
| T11 Boundary score 10 | `Score`=1010 (10), `START`=1 | MEDIUM | Q1/Q0 = 1/0, `MEDIUM_LED` lit (yellow), counts LOW/MEDIUM/HIGH = 0001/0011/0010 | Pass | `sim_11_score10_medium.png` |
| T12 Count once | After a reset: `Score`=0011 (3), `START` held at 1 for several clock ticks | LOW, `LOW_COUNT` stays 1 | Q1/Q0 = 0/1, `LOW_LED` lit, `LOW_COUNT`=0001 (not 0010 or more) | Pass | `sim_12_start_held_counts_once.png` |
| T13 Repeated detections | LOW detected three times, `ACK` between detections | `LOW_COUNT` = 1, 2, 3 | `LOW_COUNT` = 0001, 0010, 0011; MEDIUM and HIGH counts stay 0000 | Pass | `sim_12_start_held_counts_once.png`, `sim_13_repeat_low_count2.png`, `sim_14_repeat_low_count3_before_reset.png` |
| T14 Reset clears counters | From `LOW_COUNT`=3 (before reset), `RESET`=1 | State IDLE, all counts 0, LEDs off | Q1/Q0 = 0/0, all LEDs off, counts 0000/0000/0000 | Pass | `sim_14_repeat_low_count3_before_reset.png` (before), `sim_15_after_reset.png` (after) |

The counts rise 1/0/0, 1/1/0, 1/1/1 across T2, T3 and T4, showing each detection increments only its own category counter.

## Summary

All 14 planned Logisim tests passed: reset, LOW (3, 4), MEDIUM (5, 7, 9, 10), HIGH (11, 12), ACK, state hold, count-once, repeated detections and reset clearing non-zero counters.
