# Results and Conclusion – Gaming XP Level Decoder (H3)

## 1. Test cases: expected vs observed (simulation)
Observed values are from the Vivado 2018.3 XSim run (screenshots in `03_Verilog_Implementation/Simulation_Results/`), with the same 81/81 result in Icarus Verilog (`sim_log_iverilog.txt`).
Logisim column: from the Logisim run in `02_FSM_Logisim/` ("not run" = case not tested in Logisim; XP = 2, 13 and 20 were tested there instead, all passed). FPGA column: board demonstration not yet done.

| ID | Condition | Expected | Observed (sim) | Logisim | FPGA board |
|---|---|---|---|---|---|
| T01 | Power-up RESET | IDLE, all LEDs off | IDLE, 0000 – Pass | Pass | not done |
| T02 | XP=0, START | BEG, BEGINNER LED | Pass | not run | not done |
| T03 | XP=3, START | BEG | Pass | not run | not done |
| T04 | XP=4, START | INT, INTERMEDIATE LED | Pass | not run | not done |
| T05 | XP=7, START | INT | Pass | Pass | not done |
| T06 | XP=10, START | INT | Pass | not run | not done |
| T07 | XP=11, START | EXP, EXPERT LED | Pass | not run | not done |
| T08 | XP=15, START | EXP | Pass | not run | not done |
| T09 | XP=16, START | ERR, ERROR LED | Pass | not run | not done |
| T10 | XP=31, START | ERR | Pass | not run | not done |
| T11 | Level held, XP changed, START pulsed again | State unchanged | Pass | Pass | not done |
| T12 | ACK in a level state | IDLE | Pass | Pass | not done |
| T13 | ACK in IDLE, no START | Stays IDLE | Pass | not run | not done |
| T14 | RESET and START together | IDLE | Pass | not run | not done |
| T15 | RESET in EXPERT | IDLE | Pass | not run | not done |
| T16 | Forced states 101/110/111 | All LEDs off, then IDLE | Pass | n/a | n/a |
| T17 | Exhaustive sweep XP = 0..31 | Correct level for all 32 | 32/32 Pass | not run | not done |

**Totals (simulation):** 81 checks, 81 passed, 0 failed.

## 2. Correctness analysis
- All four range boundaries (3/4, 10/11, 15/16) and every one of the 32 XP values give the expected level.
- Outputs change only with the state (Moore), checked after every transition.
- RESET has priority over START; illegal state codes recover to IDLE.
- The Verilog follows the Logisim circuit block for block (same comparators, same CODE equations, same three-multiplexer next-state logic). Their behaviour was compared by reading both; the Logisim circuit has not been run automatically.

## 3. FPGA utilization and hardware results
Target: Boolean Board, Spartan-7 xc7s50csga324-1, Vivado 2018.3, top `gaming_xp_top`. Reports in `04_FPGA_Hardware/reports/`.

| Resource | Used | Available | Util % |
|---|---:|---:|---:|
| Slice LUTs | 8 | 32,600 | 0.02 |
| Flip-flops | 24 | 65,200 | 0.04 |
| Bonded IOB | 13 | 210 | 6.19 |
| BUFG | 1 | 32 | 3.13 |
| CARRY4, Block RAM, DSP | 0 | – | 0 |

The 24 flip-flops are 3 (STATE) + 5 (XP_REG) in the FSM and 16 in the 2-FF synchronizers (2 × 5 switch bits + 2 × 3 button bits). The comparators against constants are absorbed into LUTs, so no CARRY4 is used.

Timing at 100 MHz: WNS +7.656 ns, WHS +0.173 ns, 0 failing endpoints. DRC and methodology checks: 0 violations. Power estimate: 0.073 W total (0.001 W dynamic).

**Hardware demonstration: not yet performed (board not available).** The FPGA column in Section 1 stays empty until the board test is done.

## 4. Limitations
- **One-clock input delay.** The level is decided from XP sampled on the previous clock. If START arrives in the first IDLE cycle after ACK (before XP_REG has reloaded), the level can be decided from a stale XP. Keeping XP stable for one clock before START avoids it.
- The FSM module itself has no input synchronizer; the board top `gaming_xp_top` adds 2-FF synchronizers. There is no debouncer, which is safe for this FSM because START and ACK are each ignored in the state they lead to.
- XP values 16–31 are treated as invalid; there is no separate "overflow" handling beyond the ERROR state.

## 5. Conclusion
The design meets requirements R1–R9 in simulation: five Moore states with 3-bit encoding, correct level classification for all 32 XP values, a held level until ACK, a synchronous reset with top priority, and safe recovery from unused state codes.
On the FPGA the design synthesizes and implements cleanly on the Spartan-7 (8 LUTs, 24 FFs, timing met at 100 MHz with 7.656 ns slack). Hardware conclusion: pending the board demonstration.

## 6. Future improvements
- Load XP_REG every clock (or add a one-cycle guard after ACK) to remove the stale-XP case.
- Add a test for START in the first IDLE cycle after ACK.
