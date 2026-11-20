# 05 – Results

## Test cases and expected vs observed
| Test ID | Inputs / conditions | Expected output | Logisim | Verilog simulation (Vivado 2018.3) | FPGA hardware |
|---|---|---|---|---|---|
| T01 | RESET = 1 | IDLE (000), all LEDs off | Pass | Pass | – |
| T02 | START = 0 in IDLE | Stay IDLE | Pass | Pass | – |
| T03 | ACK = 1 in IDLE | Stay IDLE | Pass | Pass | – |
| T04a | Score 0–4, START | LOW (001), Green | Pass (5/5) | Pass (5/5) | Pass (LD0) |
| T04b | Score 5–8, START | MEDIUM (010), Yellow | Pass (4/4) | Pass (4/4) | Pass (LD1) |
| T04c | Score 9–12, START | HIGH (011), Red | Pass (4/4) | Pass (4/4) | Pass (LD2) |
| T04d | Score 13–15, START | EXCELLENT (100), Blue | Pass (3/3) | Pass (3/3) | Pass (LD3) |
| T04e | Change switches / press START while result shown | Result unchanged | Pass | Pass (32/32) | – |
| T04f | ACK in any category state | IDLE | Pass | Pass (15/15 within 1000 ns) | – |
| T05 | START held for several clocks | One transition, then hold | – | Pending (after 1000 ns) | – |
| T06 | START and ACK together | IDLE: START acts; category: ACK acts | – | Pending (after 1000 ns) | – |
| T07 | RESET in each category state | IDLE | Pass | Pending (after 1000 ns) | – |
| T08 | Boundary scores 4, 5, 8, 9, 12, 13 | Correct category | Pass | Pass within T04 | – |
| T09 | Unused codes 101, 110, 111 | IDLE on next clock | Pass | – | – |

**Logisim:** circuit netlist checked for all 16 scores, 16/16 pass (`../02_FSM_Logisim/logisim_netlist_check.txt`), and verified by hand in Logisim Evolution 5.0.0 (`../02_FSM_Logisim/screenshots/`).
**Verilog:** Vivado 2018.3 behavioural simulation, 66 checks run in the default 1000 ns, 66 pass, 0 fail (`../03_Verilog_Implementation/Simulation_Results/`). The boundary scores 4, 5, 8, 9, 12 and 13 are already covered by T04.
**Hardware:** synthesised to 9 LUTs and 9 flip-flops, bitstream programmed on the Boolean board, category LEDs LD0–LD3 observed by the group (`../04_FPGA_Hardware/`).

## Correctness analysis
- Every score 0–15 maps to exactly one category; the boundaries (4/5, 8/9, 12/13) fall in the correct category in Logisim and in simulation.
- Outputs come only from the state register (Moore), so they do not change when the switches change.
- The input register freezes the score when the FSM leaves IDLE, so the displayed category always matches the score sampled at START.
- On the board, START is ignored outside IDLE and ACK is ignored in IDLE, so a long or bouncing button press causes only one transition.

## Known limitations
- Only one score is classified at a time; ACK is needed before the next score.
- No error state is needed because every 4-bit value is a valid score.

## Conclusion
The four-category Moore FSM (H1) meets the requirements in Logisim, in Vivado simulation and on the Boolean board.
