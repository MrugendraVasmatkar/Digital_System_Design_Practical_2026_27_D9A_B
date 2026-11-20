# 05 – Results

Problem 3H2: Game Score Categorizer using a Mealy FSM (`mealy_simple`), Spartan-7 XC7S50-CSGA324-1, Vivado 2018.3.

## 1. Test cases: expected versus observed

### Simulation (Vivado behavioral simulation, testbench `game_tb.v`)

| Test | Inputs | Expected output (low, med, high) | Observed (waveform) | Result |
|---|---|---|---|---|
| T01 | score = 2, START, then ACK | 1 0 0 while shown; 0 0 0 after ACK | `low_led` high, others low; `low_led` low after ACK | Pass |
| T02 | score = 7, START, then ACK | 0 1 0 while shown; 0 0 0 after ACK | `med_led` high, others low; `med_led` low after ACK | Pass |
| T03 | score = 13, START, then ACK | 0 0 1 while shown; 0 0 0 after ACK | `high_led` high, others low; `high_led` low after ACK | Pass |

Evidence: `03_Verilog_Implementation/Simulation_Results/behavioral_simulation_waveform.png`. Result: 3 of 3 cases pass. The results were read from the waveform; the Tcl console log is not uploaded.

### Hardware (FPGA board)

| Test | Inputs | Expected | Observed | Result |
|---|---|---|---|---|
| H01 | LOW-range score (0-4), START | LOW LED on | LOW LED (LD0, G1) lit, `04_FPGA_Hardware/hardware_low_led.jpg` | Pass |
| H02 | MEDIUM-range score (5-10), START | MEDIUM LED on | MEDIUM LED (LD1, G2) lit, `04_FPGA_Hardware/hardware_medium_led.jpg` | Pass |
| H03 | HIGH-range score (11-15), START | HIGH LED on | HIGH LED (LD2, F1) lit, `04_FPGA_Hardware/hardware_high_led.jpg` | Pass |

Hardware demonstration done on the RealDigital Boolean Board (DONE LED lit): each category LED lit correctly. The photos show the LED but not the exact score switch values, and they do not show ACK turning the LED off.

## 2. Requirements checklist

| Requirement | Status | Basis |
|---|---|---|
| Classify score as LOW (0–4), MEDIUM (5–10), HIGH (11–15) | Verified for scores 2, 7, 13 | Waveform; boundary scores 4, 5, 10, 11 not yet simulated |
| Exactly one LED on at a time | Observed in simulation | Waveform |
| Result held until ACK, then LED off | Observed in simulation | Waveform |
| Mealy outputs (respond in the same cycle as START) | Observed in simulation | Waveform; LED rises with START |
| Synchronous reset to IDLE | Not yet verified | Reset applied once at the start; reset mid-round not tested |
| Implemented on the XC7S50 | Done | Synthesis, implementation and bitstream generation completed |
| Works on hardware | Pending | Board demonstration not yet done |

## 3. Measured implementation results (Vivado 2018.3)

| Metric | Result | Evidence |
|---|---|---|
| Slice LUTs | 6 of 32,600 (under 1%) | `04_FPGA_Hardware/utilization_report.png` |
| Slice registers (flip-flops) | 4 of 65,200 (under 1%); Vivado used one-hot state encoding | `utilization_report.png`, `implemented_design.png` |
| Slices | 2 of 8,150 | `utilization_report.png` |
| Bonded IOBs | 11 of 210 | `utilization_report.png` |
| BUFGCTRL | 1 of 32 | `utilization_report.png` |
| Estimated power | 3.43 W total (3.348 W dynamic, mostly I/O; 0.082 W static); junction 41.9 °C | `04_FPGA_Hardware/power_report.png` |
| Timing (10 ns clock, `create_clock -period 10.000`) | Met: WNS 7.665 ns, WHS 0.540 ns, WPWS 4.500 ns; 0 failing endpoints; "All user specified timing constraints are met". The first run, before the constraint, showed inf slack | `04_FPGA_Hardware/timing_summary.png` |

Timing was first reported as unconstrained (inf); after adding the clock constraint, the constrained run above meets timing.

## 4. Limitations

- Simulation covers only three scores; boundary scores and reset mid-round are not tested.
- The hardware photos do not record the exact score values, or ACK and reset behaviour on the board.
- Timing is verified only at a 10 ns (100 MHz) clock constraint; the board clock frequency should be confirmed.
- START and ACK are not debounced or synchronised, so a bouncing button could misfire on hardware.
- The score is not displayed; only the category LED is shown.

## 5. Conclusion

The Mealy FSM for problem 3H2 behaves as specified for the three simulated scores: it lights the LOW, MEDIUM or HIGH LED and clears it on ACK. It implements on the XC7S50 with 6 LUTs and 4 flip-flops, and a bitstream was generated. Remaining work: boundary and reset tests in simulation, the hardware demonstration, .
