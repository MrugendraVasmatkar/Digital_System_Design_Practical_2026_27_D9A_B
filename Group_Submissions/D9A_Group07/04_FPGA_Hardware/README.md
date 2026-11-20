# 04 – FPGA Hardware

## Board and Device
- Board: Real Digital Boolean
- FPGA: Xilinx Spartan-7, part xc7s50csga324-1
- Tool: Vivado v2018.3 (win64)
- Top-level design: `FRZ`

## Constraints
File: `FRZ.xdc`

| Signal | Board resource | Pin |
|---|---|---|
| CLK | 100 MHz onboard oscillator | F14 |
| X3 | Slide switch SW2 | U1 |
| X2 | Slide switch SW1 | U2 |
| X1 | Slide switch SW0 | V2 |
| ACK | Push button BTN0 | J2 |
| Y (ACCEPT) | LED LD0 | G1 |
| Y_bar (REJECT) | LED LD1 | G2 |

- IO standard: LVCMOS33
- Configuration: CFGBVS VCCO, CONFIG_VOLTAGE 3.3
- Clock: the onboard 100 MHz oscillator drives CLK, constrained with `create_clock -period 10.00` (clock name `sys_clk_pin`).
- Unused hardware: the eight-digit displays are not driven by this design, so their segments appear lit. This is expected.

## Synthesis and Implementation Summary

### Utilization (from `FRZ_utilization_placed.rpt`)
Device 7s50csga324-1, design state: fully placed.

| Resource | Used | Available | Util % |
|---|---|---|---|
| Slice LUTs | 1 | 32,600 | <0.01 |
| Slice registers (flip-flops) | 1 | 65,200 | <0.01 |
| Slices | 2 | 8,150 | 0.02 |
| Bonded IOs | 7 | 210 | 3.33 |
| BUFG | 1 | 32 | 3.13 |
| Block RAM / DSP | 0 | 75 / 120 | 0.00 |

Primitives: 5 IBUF (CLK, X1, X2, X3, ACK), 2 OBUF (Y, Y_bar), 2 LUT4, 1 FDCE (the state register `Q_reg`), 1 BUFG.
The design is very small: a single state flip-flop with asynchronous clear plus a little combinational logic.

### Timing (from `FRZ_timing_summary_routed.rpt`)
Result: **All user specified timing constraints are met.**

| Check | Worst slack | Failing endpoints |
|---|---|---|
| Setup (WNS) | 6.982 ns | 0 |
| Hold (WHS) | 1.028 ns | 0 |
| Pulse width (WPWS) | 4.500 ns | 0 |

- Clock: `sys_clk_pin`, 10.000 ns period, 100 MHz.
- Worst setup path: `Q_reg` back to `Q_reg`, data path delay 2.916 ns through one LUT4.
- `check_timing` notes: 4 input ports (X1, X2, X3, ACK) have no input delay and 2 output ports (Y, Y_bar) have no output delay. These are human-operated switches, a button and LEDs, so no external timing relationship exists. I did not add I/O delay constraints.
- No combinational loops, no unclocked registers, no multiple-clock registers.

### Files
- Bitstream: `FRZ.bit`
- Reports in this folder: `FRZ_utilization_placed.rpt`, `FRZ_timing_summary_routed.rpt`

## Programming
1. Connected the Boolean to the PC by USB and switched it on.
2. In Vivado: Open Hardware Manager, Open Target, Auto Connect.
3. Program Device, selected the `.bit` file, and clicked Program.
4. The DONE LED lit, which confirms the FPGA was configured.

## Hardware Test Cases
Switches are written SW2 SW1 SW0 (1 = up). LD0 = ACCEPT (Y), LD1 = REJECT (Y_bar). Exactly one of the two LEDs is on at any time. Fill the Observed column from the real board.

| # | Action | Expected | Observed |
|---|---|---|---|
| 1 | Switches 000, press and release BTN0 | LD0 on, LD1 off | [ ] |
| 2 | 001, 010, 101, 110, 111 | LD0 on, LD1 off | [ ] |
| 3 | 011 (values 6, 7) | LD0 off, LD1 on, immediately | [ ] |
| 4 | Back to 000 | LD1 stays on (latched) | [ ] |
| 5 | Press BTN0 | LD0 on, LD1 off | [ ] |
| 6 | 100 (values 8, 9) | LD0 off, LD1 on, immediately | [ ] |
| 7 | Back to 000 | LD1 stays on (latched) | [ ] |
| 8 | Press BTN0 | LD0 on, LD1 off | [ ] |

Tests 4 and 7 show that the REJECT state is remembered until ACK. The CLK is the 100 MHz oscillator, so the state updates automatically; no manual clock is needed.

## Evidence
- Photos / video of the board tests: `Hardware Implementation `

## Simulation vs Hardware
Simulation matched with the Hardware implemented.
