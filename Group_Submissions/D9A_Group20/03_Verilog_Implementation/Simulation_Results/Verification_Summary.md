# Verification Summary – gaming_xp_decoder

| Item | Value |
|---|---|
| DUT | `RTL/gaming_xp_decoder.v` (top module `gaming_xp_decoder`, no submodules) |
| Testbench | `Testbench/tb_gaming_xp_decoder.v` (self-checking, Moore outputs checked every time) |
| Simulators | Vivado 2018.3 XSim (behavioural) and Icarus Verilog 12.0 (`iverilog -g2005`), both on 19 Nov 2026 |
| Result (both simulators) | **81 checks, 0 failures – "ALL TESTS PASSED"** |
| Vivado evidence | `vivado_tcl_all_tests_passed.png` (Tcl console), `vivado_waveform_0-850ns.png` (reset, directed tests, start of sweep), `vivado_waveform_350-900ns.png` (EXP/ERR tests and sweep, state names in ASCII) |
| Icarus log | `sim_log_iverilog.txt` (testbench v3, 20 Nov 2026) |
| Waveform configuration | `tb_gaming_xp_decoder_behav.wcfg` (open in Vivado to restore the wave view) |

## What the testbench covers
| Group | Checks |
|---|---|
| Reset after power-up | 1 |
| Nine directed XP values (0, 3, 4, 7, 10, 11, 15, 16, 31), each: IDLE before START → level after START → held while XP changes and START is pulsed → IDLE after ACK | 36 |
| Exhaustive sweep XP = 0..31 | 32 |
| ACK in IDLE with no START | 1 |
| RESET + START together | 1 |
| RESET while in EXPERT | 2 |
| Forced illegal states 101, 110, 111: LEDs off, then recover to IDLE | 6 |
| One-clock delay demonstration | 2 |

## Fault-injection check (is the testbench able to fail?)
Each change was made to a copy of the RTL and the testbench was re-run:

| Change to RTL | Testbench result |
|---|---|
| `xp_reg > 15` → `> 16` | FAILS (3 errors) |
| `xp_reg < 4` → `< 5` | FAILS (3 errors) |
| `xp_reg > 10` → `> 11` | FAILS (3 errors) |
| XP_REG enable `s_idle` → always load | **Still passes** |

## Gaps found in the testbench and the design
1. **XP_REG enable is not tested.** No test applies START in the first IDLE cycle after ACK, so removing the IDLE enable is not detected.
2. **Known limitation (design):** XP_REG is frozen while a level is held, so for one clock after ACK it still holds the XP from before the previous START.
   Reproduced in simulation: level BEG held, XP changed to 12, ACK, then START in the very next cycle → machine goes to **BEG (stale)** instead of **EXP**.
   If XP is stable for at least one full clock in IDLE before START (as the RTL header comment requires), the result is correct.
3. The `check` task's `name` argument is `[255:0]` (32 characters), so long test names are cut at the front in the log. This is cosmetic.

Suggested extra test (not added to the group's testbench): hold level BEG, change XP to 12, ACK, START immediately, expect the behaviour the group decides is correct (document it either way).
