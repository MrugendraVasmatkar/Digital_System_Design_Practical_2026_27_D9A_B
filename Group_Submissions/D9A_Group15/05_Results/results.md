# Results – Game Score Categorizer (Moore FSM + H4 Category Counters)

Expected versus observed behaviour in Logisim, Verilog simulation (Vivado 2018.3) and on the Real Digital Boolean Board (xc7s50csga324-1).

## Expected versus observed

| Case | Expected | Logisim | Verilog simulation | FPGA board |
|---|---|---|---|---|
| LOW | state 1, green LED, LOW count + 1 | Pass (score 3) | Pass (scores 0 to 4) | Pass (score 1: display 1 1 0 1) |
| MEDIUM | state 2, yellow LED, MEDIUM count + 1 | Pass (score 5) | Pass (scores 5 to 10) | Pass (score 5: display 2 1 1 1) |
| HIGH | state 3, red LED, HIGH count + 1 | Pass (score 12) | Pass (scores 11 to 15) | Pass (score 15: display 3 0 0 1) |
| Hold | score and START ignored until ACK | Pass | Pass | Pass (display unchanged in the video) |
| Count once | START held counts once | Pass | Pass | not tested separately (single-pulse buttons) |
| Reset | state and all counts 0 | Pass | Pass | Pass (display 0 0 0 0) |

The Logisim circuit, the Verilog simulation and the hardware gave the same states and counter values in every case tested.

## Measured results

| Item | Result |
|---|---|
| Logisim tests | 14 of 14 passed |
| Verilog testbench | 88 checks, 0 errors, TEST PASSED (finished at 1760 ns) |
| Slice LUTs | 92 of 32,600 (< 1 %) |
| Flip-flops | 118 of 65,200 (< 1 %) |
| CARRY4 | 20 |
| Block RAM, DSP | 0, 0 |
| Timing at 100 MHz (10 ns clock) | WNS 5.534 ns, WHS 0.173 ns, WPWS 4.500 ns; all user specified timing constraints met |

## Evidence

- Logisim: `02_FSM_Logisim/simulation/simulation_results.md` and the screenshots `sim_01` to `sim_15`.
- Verilog simulation: `03_Verilog_Implementation/Simulation_Results/simulation_results.md`, the console screenshot and two waveform screenshots.
- Implementation: `04_FPGA_Hardware/fpga_results.md`, `utilization_report.png`, `timing_summary.png`.
- Hardware: `04_FPGA_Hardware/hardware_photo_board_score5_medium.jpg`, `hardware_photo_display_score5_closeup.jpg` and the demonstration video (link in `04_FPGA_Hardware/fpga_results.md`).

## Conclusion

The design classifies scores 0 to 15 into LOW (0 to 4), MEDIUM (5 to 10) and HIGH (11 to 15) correctly, holds the category until ACK, counts each detection exactly once and clears everything on reset. All three levels of verification agree, and the implementation meets timing at 100 MHz with a comfortable margin.

## Limitations

- The 4-bit counters wrap from 15 to 0.
- There is no error state, because every 4-bit score is valid.
- On the board, the count-once case was not tested separately, because the START button gives a single debounced pulse.
- Not every boundary score was tested on the board; the board test used scores 1, 5 and 15. The boundary scores 4, 5, 10 and 11 were tested in Logisim and in the Verilog simulation.
