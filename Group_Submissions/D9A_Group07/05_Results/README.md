# 05 – Results

## 1. Overview
The FRZ ACCEPT/REJECT controller was verified in three ways: Vivado simulation with a testbench, synthesis/implementation reports (utilization and timing), and testing on the Real Digital Boolean board (xc7s50csga324-1). All results agreed with the expected behaviour.

Output meaning: Y (LED LD0) = ACCEPT, Y_bar (LED LD1) = REJECT. Exactly one of them is on at any time.
Inputs: X3 X2 X1 = switches SW2 SW1 SW0, ACK = BTN0, CLK = 100 MHz onboard oscillator.

## 2. Truth Table: Expected vs Observed (all 8 input combinations)
Expected output follows FZ = X3'.X2.X1 + X3.X2'.X1' (fault patterns 011 and 100), with REJECT stored until ACK.

| X3 X2 X1 | Expected output | Simulation | Hardware (board) |
|---|---|---|---|
| 000 | ACCEPT (LD0 on) | Matched | Matched |
| 001 | ACCEPT | Matched | Matched |
| 010 | ACCEPT | Matched | Matched |
| 011 | REJECT (LD1 on) | Matched | Matched |
| 100 | REJECT | Matched | Matched |
| 101 | ACCEPT | Matched | Matched |
| 110 | ACCEPT | Matched | Matched |
| 111 | ACCEPT | Matched | Matched |

## 3. Sequence (Latch and ACK) Test Cases on the Board
Switches are written SW2 SW1 SW0 (1 = up).

| # | Action | Expected | Observed | Result |
|---|---|---|---|---|
| 1 | Switches 000, press and release BTN0 | LD0 on, LD1 off | LD0 on, LD1 off | Pass |
| 2 | 001, 010, 101, 110, 111 | LD0 on, LD1 off | LD0 on, LD1 off | Pass |
| 3 | 011 | LD0 off, LD1 on, immediately | LD0 off, LD1 on, immediately | Pass |
| 4 | Back to 000 | LD1 stays on (latched) | LD1 stays on (latched) | Pass |
| 5 | Press BTN0 | LD0 on, LD1 off | LD0 on, LD1 off | Pass |
| 6 | 100 | LD0 off, LD1 on, immediately | LD0 off, LD1 on, immediately | Pass |
| 7 | Back to 000 | LD1 stays on (latched) | LD1 stays on (latched) | Pass |
| 8 | Press BTN0 | LD0 on, LD1 off | LD0 on, LD1 off | Pass |

Result: 8 of 8 sequence tests passed, and all 8 input combinations gave the expected output.

## 4. Simulation Results
- At the start ACK is high, which clears the state register; Y is high and Y_bar is low.
- When a fault pattern (011 or 100) is present, Y_bar goes high and Y goes low.
- Y_bar stays high after the input returns to a normal value, until ACK is applied.
- When ACK is applied, Y returns high and Y_bar goes low.
- The simulation waveform is in the project report (`FRZ_project_report.pdf`). Simulation and hardware results matched.

## 5. Resource Utilization and Timing Results
Source: `FRZ_utilization_placed.rpt` and `FRZ_timing_summary_routed.rpt` (Vivado v2018.3).

| Resource | Used | Available | Util % |
|---|---|---|---|
| Slice LUTs | 1 | 32,600 | <0.01 |
| Slice registers (flip-flops) | 1 | 65,200 | <0.01 |
| Slices | 2 | 8,150 | 0.02 |
| Bonded IOs | 7 | 210 | 3.33 |
| BUFG | 1 | 32 | 3.13 |

| Timing check | Worst slack | Failing endpoints |
|---|---|---|
| Setup (WNS) | 6.982 ns | 0 |
| Hold (WHS) | 1.028 ns | 0 |
| Pulse width (WPWS) | 4.500 ns | 0 |

All user specified timing constraints are met at 100 MHz (10 ns period). With 6.982 ns of setup slack, the design could run at a much higher clock frequency than needed.

## 6. Accuracy / Correctness Analysis
- Coverage: all 8 possible input combinations were tested in both simulation and on the board, so the fault-detection logic is checked exhaustively.
- Latch behaviour: tests 4 and 7 show that REJECT is remembered after the fault input is removed.
- Clear behaviour: tests 5 and 8 show that ACK clears the stored state.
- Agreement: simulation, the Logisim circuit and the board all give the same results, and the RTL schematic matches the intended Boolean equations.
- Result: no mismatches were observed, so the observed correctness is 100% for the tests performed.

## 7. Known Limitations
- The inputs are slide switches and a push button, which are not synchronized to the clock. No synchronizer or debouncer is used. This is fine for a demonstration, but a real system would need them.
- A fault is only stored on a rising clock edge. In simulation, a fault that disappears before the next rising edge is not stored. On the board the clock period is 10 ns, so switch movements by hand are always long enough.
- REJECT is cleared asynchronously by ACK. If a fault pattern is still on the switches when ACK is pressed, REJECT stays on, because the fault output is combinational.
- Only two fault patterns (011 and 100) are detected. The design handles a 3-bit input only.
- No input or output delay constraints were set, so the timing report warns about them. This is acceptable for switches and LEDs.
- Hardware testing was done by hand and recorded on video (`Hardware implementation.mp4`). Only the final test results were checked; no automatic hardware test was used.

## 8. Conclusion
The FRZ controller works as designed. It correctly accepts the six normal input combinations, rejects the fault patterns 011 and 100, holds the REJECT state until ACK is pressed, and clears it when ACK is pressed. The design is very small (1 LUT and 1 flip-flop) and meets timing at 100 MHz with large margin. Simulation and hardware results matched in every test.
