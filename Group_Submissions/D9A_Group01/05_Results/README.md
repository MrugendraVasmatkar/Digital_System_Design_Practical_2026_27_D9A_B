# 05 – Results

## 1. Summary
| Item | Tool | Result | Evidence |
|---|---|---|---|
| Logisim H1 circuit (N = 5) | Logisim | 31/31 steps passed in the headless run recorded in `STATUS.md` | `../02_FSM_Logisim/H1_N5_test_vector.txt` |
| Logisim H1 circuit (N-bit) | Logisim-evolution v5.0.0 | Circuit built and opened; step-by-step results of the sheet's sequence still to be recorded | `../02_FSM_Logisim/screenshots/` |
| Verilog behavioural simulation (N = 4 and N = 5) | Vivado 2018.3 | Design output matches the expected value in 12 of 12 steps; the testbench reports 11 passed / 1 failed because of one wrong expected value | `../03_Verilog_Implementation/Simulation_Results/gray_code_nbit_tb_waveform.png` |
| Synthesis, implementation, bitstream | Vivado 2018.3, `xc7s50csga324-1` | Completed; 8 LUTs, 7 registers, 3 slices, 10 IOBs | `../04_FPGA_Hardware/` |
| Timing | Vivado 2018.3 | Not evaluated: no clock constraint, all values NA | `../04_FPGA_Hardware/vivado_timing_summary.png` |
| Hardware demonstration | FPGA board | Not done yet | – |

## 2. Test cases: expected versus observed (Verilog simulation)
`V = 1` means exactly one bit of `D = X xor P` is 1. The first sample of each instance is compared with `P = 0`.

| No. | N | Previous P | Input X | D = X xor P | Expected | Observed (waveform) | Testbench report |
|---:|---:|---|---|---|---|---|---|
| 1 | 4 | 0000 | 0001 | 0001 | VALID | VALID | Pass |
| 2 | 4 | 0001 | 0011 | 0010 | VALID | VALID | Pass |
| 3 | 4 | 0011 | 0111 | 0100 | VALID | VALID | Pass |
| 4 | 4 | 0111 | 0101 | 0010 | VALID | VALID | Pass |
| 5 | 4 | 0101 | 1101 | 1000 | VALID | VALID | Pass |
| 6 | 4 | 1101 | 1100 | 0001 | VALID | VALID | Pass |
| 7 | 4 | 1100 | 1111 | 0011 | INVALID (two bits; sheet gives V = 0) | INVALID | **Fail** – testbench expects VALID (wrong expected value) |
| 8 | 4 | 1111 | 1111 | 0000 | INVALID (no change) | INVALID | Pass |
| 9 | 4 | 1111 | 1001 | 0110 | INVALID (two bits) | INVALID | Pass |
| 10 | 5 | 00000 | 00010 | 00010 | VALID | VALID | Pass |
| 11 | 5 | 00010 | 10010 | 10000 | VALID | VALID | Pass |
| 12 | 5 | 10010 | 10111 | 00101 | INVALID (two bits) | INVALID | Pass |

Testbench totals (waveform counters): **11 passed, 1 failed**. Test 7 is the only failure; the design output for it matches the problem sheet's example table (`1100 -> 1111`, V = 0). After correcting the expected value in `run_step_4bit(4'b1111, 1'b1)` to `1'b0`, all 12 steps are expected to pass; re-run and replace this table's last column and the waveform to confirm.

Waveform: `../03_Verilog_Implementation/Simulation_Results/gray_code_nbit_tb_waveform.png`

## 3. Logisim results
- **N = 5 circuit:** 31/31 steps of `H1_N5_test_vector.txt` passed in the headless run (5 required tests, reset and sample gating).
- **N-bit circuit (`Gray_Code_Transition_Detector_H1.circ`):** screenshots of the circuit are uploaded. Add a table of the sheet's sequence (`0000 -> 0001 -> 0011 -> 0111 -> 0101 -> 1101 -> 1100 -> 1111`) with the VALID/INVALID LED state observed after each step.

## 4. FPGA implementation results (`xc7s50csga324-1`, Vivado 2018.3)
| Resource | Used | Available |
|---|---:|---:|
| Slice LUTs | 8 | 32600 |
| Slice registers | 7 | 65200 |
| Slices | 3 | 8150 |
| Bonded IOB | 10 | 210 |
| BUFGCTRL | 1 | 32 |

- Vivado re-encoded the 2-bit state into one-hot (3 state flip-flops) plus 4 flip-flops for the previous input.
- The bitstream was generated ("write_bitstream Complete").
- Timing: "There are no user specified timing constraints" – setup, hold and pulse-width values are NA until a clock constraint (`create_clock -period 10.000 [get_ports clk]`) is added.

## 5. Correctness analysis
- The one-bit-change detector `V = (|D) & ~|(D & (D - 1))` is true exactly when `D` has a single 1, which is the sheet's condition `(ΣDᵢ)·~(Σ_{i<j}DᵢDⱼ)` for any width N.
- In all 12 simulated steps (N = 4 and N = 5) the LED outputs follow the Moore state: VALID for a one-bit change, INVALID for no change or two bits changed, both off in IDLE.
- The N = 5 instance shows that the same RTL works for another width (H1); N = 8 has not been simulated.

## 6. Known limitations
- One testbench expected value is wrong (test 7); the testbench therefore shows 11/12 although the design output is correct.
- Only 12 directed steps were simulated; reset, `start` ignored outside IDLE, `ack` and random inputs are not yet covered.
- Timing is unconstrained (no clock constraint), so no slack or maximum frequency is available.
- The push buttons are not debounced on the FPGA; `start` is accepted only in IDLE and `ack` is needed after each sample.
- The FPGA demonstration uses N = 4 only, and the hardware test has not been done yet.
- The Logisim circuit and the Verilog differ in detail (for example how the first sample and `start`/`ack` are handled); the sheet's sequence gives the same VALID/INVALID outcome in both.

## 7. Conclusion
The H1 N-bit Gray code transition detector was implemented in Logisim and Verilog. The simulation matches the problem sheet's example sequence and the additional no-change and two-bit cases for N = 4 and N = 5, and the design synthesizes and implements for `xc7s50csga324-1` using 8 LUTs and 7 registers. Remaining work: fix and re-run the testbench, add a clock constraint and timing results, record the Logisim step table, and demonstrate the design on the board.
