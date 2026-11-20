# FPGA Implementation – Boolean Board (Spartan-7 xc7s50csga324-1)

## Files
| File | Purpose |
|---|---|
| `03_Verilog_Implementation/RTL/gaming_xp_decoder.v` | The FSM (unchanged, verified 81/81) |
| `03_Verilog_Implementation/RTL/gaming_xp_top.v` | Board top level: 2-FF synchronizers on switches and buttons, then the FSM |
| `04_FPGA_Hardware/boolean_gaming_xp.xdc` | Pin and clock constraints |

## Board mapping
| Signal | Board part | FPGA pin |
|---|---|---|
| clk | 100 MHz oscillator | F14 |
| XP[0]..XP[3] | SW0..SW3 | V2, U2, U1, T2 |
| XP[4] (MSB) | SW5 – SW4 on our board is faulty (always reads 1), so XP bit 4 is wired to SW5 | R2 |
| START | BTN0 | J2 |
| ACK | BTN1 | J5 |
| RESET | BTN2 | H2 |
| BEGINNER | LD0 | G1 |
| INTERMEDIATE | LD1 | G2 |
| EXPERT | LD2 | F1 |
| ERROR | LD3 | F2 |
| Debug: XP bit 4 | LD5 | E2 |

## Steps in Vivado 2018.3
1. **Add the wrapper.** Add Sources → Add or create design sources → add `gaming_xp_top.v` (tick "Copy sources into project").
2. **Add the constraints.** Add Sources → Add or create constraints → add `boolean_gaming_xp.xdc`.
3. **Set the top module.** In Sources, right-click `gaming_xp_top` → Set as Top. Check Settings → General shows top = `gaming_xp_top`, part = `xc7s50csga324-1`. Keep `tb_gaming_xp_decoder` as the simulation top.
4. **Run Synthesis.** It should finish with no critical warnings. If you see "port not found" warnings, a port name in the XDC does not match the Verilog.
5. **Run Implementation.**
6. **Collect reports** (screenshot or Reports menu → save):
   - Report Utilization: LUT, FF, IO, BUFG. Actual result: 8 LUTs, 25 FFs, 14 IOs, 1 BUFG, no BRAM/DSP.
   - Report Timing Summary: WNS must be positive. Actual result: WNS +7.172 ns, 0 failing endpoints.

**Status (19 Nov 2026):** steps 1–7 done; reports in `reports/`, bitstream `gaming_xp_top.bit` in this folder. Steps 8–10 wait for a board.
7. **Generate Bitstream.**
8. **Program the board.** Plug in the Boolean Board by USB, power it on → Open Hardware Manager → Open Target → Auto Connect → Program Device → select `gaming_xp_top.bit`.
9. **Hardware test** (record a video):
   1. Press BTN2 (RESET): all four LEDs off.
   2. Set SW5, SW3..SW0 = 0 0010 (XP 2), press BTN0 (START): LD0 on (BEGINNER).
   3. Change the switches: LD0 stays on (level held). Press BTN1 (ACK): all off.
   4. Repeat with XP 4 (00100) → LD1, XP 10 (01010) → LD1, XP 11 (01011) → LD2, XP 15 (01111) → LD2, XP 16 (10000) → LD3, XP 31 (11111) → LD3. The first digit is SW5; LD5 lights whenever it is 1.
   5. Press RESET while a level is shown: all off.
   6. Fill the FPGA column of `05_Results/Results_and_Conclusion.md` with what you saw.
10. **Upload to this folder:** utilization and timing screenshots (or `.rpt` files), board photos, the demo video (or a link if it is too large).

## If something goes wrong
| Symptom | Likely cause |
|---|---|
| LEDs on when nothing is pressed, or buttons act inverted | Board buttons are active-low on your board revision: invert `btn` in `gaming_xp_top.v` |
| Bitstream error "unconstrained ports" | Top module not set to `gaming_xp_top`, or a port name mismatch |
| Programming fails / no device found | USB cable, board power switch, or cable drivers not installed |
