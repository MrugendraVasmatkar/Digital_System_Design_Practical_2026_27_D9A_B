# Results and Analysis – Forbidden Zone Rejector (6H1)

**Group ID:** D9_Group03  
**Setup:** N = 4. Ranges tested: [6, 9] (default), [4, 7], [8, 11]. All ranges inclusive.  
**Tools:** Logisim-evolution v3.9.0, Xilinx Vivado Simulator, FPGA board

## 1. Test-Case Table (all 16 inputs)
Rule: X is forbidden if L ≤ X ≤ H. Forbidden → REJECT (Y = 0). Otherwise → ACCEPT (Y = 1).

| X (dec) | X (bin) | Expected | Observed (Logisim) | Observed (Verilog) | Pass/Fail |
|---:|---|---|---|---|---|
| 0 | 0000 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 1 | 0001 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 2 | 0010 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 3 | 0011 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 4 | 0100 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 5 | 0101 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 6 | 0110 | REJECT | REJECT | REJECT | Pass |
| 7 | 0111 | REJECT | REJECT | REJECT | Pass |
| 8 | 1000 | REJECT | REJECT | REJECT | Pass |
| 9 | 1001 | REJECT | REJECT | REJECT | Pass |
| 10 | 1010 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 11 | 1011 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 12 | 1100 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 13 | 1101 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 14 | 1110 | ACCEPT | ACCEPT | ACCEPT | Pass |
| 15 | 1111 | ACCEPT | ACCEPT | ACCEPT | Pass |

## 2. Other Ranges (all 16 inputs)
Same testbench, only `` `L `` and `` `H `` changed. Observed output is from the Verilog simulation.

| X (dec) | X (bin) | Expected [4, 7] | Observed [4, 7] | Expected [8, 11] | Observed [8, 11] |
|---:|---|---|---|---|---|
| 0 | 0000 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 1 | 0001 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 2 | 0010 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 3 | 0011 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 4 | 0100 | REJECT | REJECT | ACCEPT | ACCEPT |
| 5 | 0101 | REJECT | REJECT | ACCEPT | ACCEPT |
| 6 | 0110 | REJECT | REJECT | ACCEPT | ACCEPT |
| 7 | 0111 | REJECT | REJECT | ACCEPT | ACCEPT |
| 8 | 1000 | ACCEPT | ACCEPT | REJECT | REJECT |
| 9 | 1001 | ACCEPT | ACCEPT | REJECT | REJECT |
| 10 | 1010 | ACCEPT | ACCEPT | REJECT | REJECT |
| 11 | 1011 | ACCEPT | ACCEPT | REJECT | REJECT |
| 12 | 1100 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 13 | 1101 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 14 | 1110 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |
| 15 | 1111 | ACCEPT | ACCEPT | ACCEPT | ACCEPT |

All 32 checks passed (16 per range). Boundaries L and H are rejected in both ranges. The inputs just below L and just above H are accepted.

## 3. Other Checks
| Test | Condition | Expected | Observed | Pass/Fail |
|---|---|---|---|---|
| Reset | reset = 1 at start | State = IDLE, accept = 1, reject = 0, x_reg = 0 | Same as expected | Pass |
| Lower boundary | X = L = 6 | REJECT | REJECT | Pass |
| Upper boundary | X = H = 9 | REJECT | REJECT | Pass |
| Just below L | X = 5 | ACCEPT | ACCEPT | Pass |
| Just above H | X = 10 | ACCEPT | ACCEPT | Pass |

## 4. Verilog Testbench Summary
- Testbench: `tb_fz_rejector.v`
- Flow per input: put X on the input, pulse `start`, wait 2 clock cycles, then check `x_reg`, state, accept_led and reject_led.
- Clock: 10 ns period.
- Checks run: 17 per range (1 reset + 16 inputs), 51 in total for 3 ranges.
- Result: 51 passed, 0 failed. Message printed: `ALL TESTS PASSED for N=4, Range=[L, H]!`
- Waveform config: `tb_fz_rejector_behav.wcfg`
- Ranges run: [6, 9], [4, 7], [8, 11]. To change the range, edit `` `L `` and `` `H `` at the top of the testbench.

## 5. Hardware Result
- FPGA board: [Board name / part number]
- Inputs: switches for `x`, buttons for `start` and `ack`. Outputs: ACCEPT and REJECT LEDs.
- Default range [6, 9]: REJECT LED on for X = 6 to 9, ACCEPT LED on for all other X.
- `ack` takes the FSM back to IDLE.
- Hardware output matches the simulation.

## 6. Accuracy / Correctness Analysis
- **Accuracy:** 16 of 16 inputs give the correct output in Logisim and Verilog for [6, 9]. Verilog is also 16 of 16 for [4, 7] and [8, 11]. 100% match, and hardware agrees with simulation.
- **Boundaries:** L (6) and H (9) are both rejected. This confirms the range is inclusive.
- **Coverage:** Exhaustive. All 2^4 = 16 inputs are tested, so no input is left unchecked.
- **Logisim vs Verilog:** Both give the same accept/reject result for every input.
- **Timing (Verilog):** The result appears 2 clock cycles after `start` (1 cycle to store X, 1 cycle for the FSM to update).
- **Why it generalizes:** The forbidden-zone logic uses comparators with parameters N, L and H. Only the parameters change for a new range. No new Boolean equation is needed.

## 7. Known Limitations
1. The result is ready 2 clock cycles after `start`, not immediately.
2. The Logisim version uses an asynchronous ripple counter. It has cumulative delay, which is fine only because it is just test stimulus.
3. On hardware, push buttons for `start` and `ack` need debouncing.

## 8. Conclusion
- The Forbidden Zone Rejector works correctly for N = 4 in Logisim, Verilog (ranges [6, 9], [4, 7], [8, 11]) and on the FPGA.
- Two comparators and a gate network replace the fixed Boolean expression, so L and H can be changed easily (H1 met).
- The Moore FSM (IDLE / REJECT) holds the reject output until `ack`.
- Next steps: test larger widths and add an L ≤ H check.
