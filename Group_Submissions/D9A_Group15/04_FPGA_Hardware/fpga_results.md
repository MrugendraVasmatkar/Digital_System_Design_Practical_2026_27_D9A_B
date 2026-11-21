# FPGA Implementation Results – Game Score Categorizer (H4)

**Board / device:** Real Digital Boolean Board, xc7s50csga324-1 (Spartan-7)
**Tool:** Vivado 2018.3 (synthesis, implementation and bitstream generation completed)
**Top module:** `top_boolean`  |  **Constraints:** `boolean_board.xdc`

## Resource utilization (implemented design)

Source: `utilization_report.png` (Vivado Utilization, hierarchy view).

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs (all as logic) | 92 | 32,600 | < 1 % |
| Slice Registers (flip-flops) | 118 | 65,200 | < 1 % |
| Slices | 57 | 8,150 | about 1 % |
| Bonded IOB | 23 | 210 | 11 % |
| BUFGCTRL | 1 | 32 | 3 % |
| CARRY4 | 20 | | |
| Block RAM | 0 | | |
| DSP | 0 | | |

The CARRY4 count was read with the Tcl command `llength [get_cells -hier -filter {REF_NAME == CARRY4}]`. The Block RAM and DSP sections of the report are empty (no RAM or DSP is used).

### Utilization by module

| Module | Slice LUTs | Slices |
|---|---:|---:|
| `top_boolean` (total) | 92 | 57 |
| `u_core` (`game_score_categorizer`) | 21 | 8 |
| `u_db0` (`debounce`, START) | 23 | 15 |
| `u_db1` (`debounce_0`, ACK) | 23 | 15 |
| `u_db2` (`debounce_1`, RESET) | 22 | 14 |

The 23 bonded IOBs match the design's ports: `mclk` (1), `sw` (4), `btn` (3), `led` (3), `D0_a` (4), `D0_seg` (8).

## Timing summary (implemented design, 100 MHz clock)

Source: `timing_summary.png` (Vivado Design Timing Summary).

| Check | Worst slack | Total violation | Failing endpoints | Endpoints |
|---|---:|---:|---:|---:|
| Setup (WNS / TNS) | 5.534 ns | 0.000 ns | 0 | 212 |
| Hold (WHS / THS) | 0.173 ns | 0.000 ns | 0 | 212 |
| Pulse width (WPWS / TPWS) | 4.500 ns | 0.000 ns | 0 | 119 |

Vivado reports: **All user specified timing constraints are met.** With a 10 ns clock period and 5.534 ns of setup slack, the design has a comfortable margin at 100 MHz.

## Hardware demonstration

The bitstream was programmed on the Real Digital Boolean Board on 20/11/2026 (the board's DONE LED is lit in the photos). The group reports that the hardware demonstration was completed and recorded on video.

**Photographed case: score 5 (MEDIUM), after a reset**

| Item | Expected | Observed in the photo |
|---|---|---|
| LED | MEDIUM LED (LD1) on | LD1 lit |
| 7-segment display 0 | state 2 (MEDIUM), LOW count 0, MEDIUM count 1, HIGH count 0 | reads 2 0 1 0 |

The display digits are, left to right: state (0 IDLE, 1 LOW, 2 MEDIUM, 3 HIGH), LOW count, MEDIUM count, HIGH count. The score itself is shown only by the switches.

Evidence: `hardware_photo_board_score5_medium.jpg` (whole board) and `hardware_photo_display_score5_closeup.jpg` (display close-up).

**Demonstration video (hosted externally on Google Drive):** https://drive.google.com/drive/folders/1mQUoD12ULA3UzhSWuDmA_176wDbxy463

## Sequence seen in the demonstration video

Frames of the video (about 29 s, sampled once per second) show the following display readings on display 0 (state, LOW count, MEDIUM count, HIGH count). Scores used (reported by the group, SW3..SW0): HIGH = 1111 (15), LOW = 0001 (1), MEDIUM = 0101 (5).

| Approx. time | Display | Meaning |
|---|---|---|
| 0–4 s | 0 0 0 0 | after reset: IDLE, all counts 0 |
| ~4–5 s | 3 0 0 1 | HIGH detected (score 15, 1111): state 3, HIGH count 1 |
| ~6–11 s | 0 0 0 1 | ACK: back to IDLE, count kept |
| ~11–12 s | 1 1 0 1 | LOW detected (score 1, 0001): state 1, LOW count 1 (HIGH count still 1) |
| ~13–17 s | 0 1 0 1 | ACK: back to IDLE, counts kept |
| ~17 s | 2 1 1 1 | MEDIUM detected (score 5, 0101): state 2, MEDIUM count 1 (counts 1/1/1) |
| ~18–27 s | 2 1 1 1 | state and counts unchanged while the controls are operated (consistent with the hold behaviour) |
| ~28–29 s | 0 0 0 0 | reset: state and all counts cleared |

Each category was detected, the matching counter rose by 1 and the others stayed unchanged, ACK returned the state to IDLE without clearing the counts, and reset cleared everything. This is the same behaviour as in simulation.
## Still to add

- Group notes on any difference from simulation.
