# 04 – FPGA Hardware

| Item | Details |
|---|---|
| Board | RealDigital Boolean board |
| FPGA | Xilinx Spartan-7 xc7s50csga324-1 |
| Tool | Vivado 2018.3 |
| Clock | 100 MHz on pin F14, used directly by the FSM |
| Top module | `Game_Score_Categorizer` (`../03_Verilog_Implementation/RTL/Game_Score_Categorizer.v`) |
| Constraints | `boolean.xdc` |

## Board I/O mapping (`boolean.xdc`)
| Board item | Pin | Signal |
|---|---|---|
| 100 MHz clock | F14 | Clock |
| SW0–SW3 | V2, U2, U1, T2 | Score[0]–Score[3] |
| BTN0 | J2 | START |
| BTN1 | J5 | ACK |
| BTN2 | H2 | Reset |
| LD0 | G1 | LED_LOW (0–4) |
| LD1 | G2 | LED_MEDIUM (5–8) |
| LD2 | F1 | LED_HIGH (9–12) |
| LD3 | F2 | LED_EXCELLENT (13–15) |

## Why the buttons work without a clock divider
A button press lasts millions of 100 MHz clock cycles. This does not cause repeated transitions because of how the FSM is built:
- In a category state START is ignored, so holding or bouncing START after the first transition has no effect.
- In IDLE ACK is ignored, so holding or bouncing ACK after returning to IDLE has no effect.

## Vivado flow used
1. RTL project for part `xc7s50csga324-1`.
2. Design source `Game_Score_Categorizer.v` (top), simulation source `tb_Game_Score_Categorizer.v`, constraints `boolean.xdc`.
3. Behavioural simulation (see `../03_Verilog_Implementation/Simulation_Results/`).
4. Synthesis, implementation and bitstream generation.
5. Hardware Manager: the xc7s50 was programmed with `Game_Score_Categorizer.bit` ("End of startup status: HIGH" in the Tcl log).

## Evidence in this folder
| File | Content |
|---|---|
| `vivado_rtl_schematic.jpg` | Elaborated RTL schematic: input register `Score_Reg`, comparators, next-state multiplexers, `Moore_State` register, LED outputs |
| `vivado_post_synthesis_schematic.jpg` | Synthesised netlist (LUTs, flip-flops, I/O buffers) |
| `vivado_utilization.jpg` | Utilization report |
| `vivado_boolean_xdc.jpg` | Constraints file as used in the project |
| `board_demo/board_demo.mp4` | Video of the programmed Boolean board responding to the switches and buttons |
| `board_demo/board_demo_frame_1–4.png` | Frames taken from the video |

## Utilization (xc7s50csga324-1)
| Resource | Used | Available | Util % |
|---|---|---|---|
| Slice LUTs (logic) | 9 | 32600 | 0.03 |
| Slice registers (flip-flops) | 9 | 65200 | 0.01 |
| F7 muxes | 1 | 16300 | < 0.01 |
| F8 muxes | 0 | 8150 | 0.00 |

## Hardware test procedure
| Step | Action | Expected |
|---|---|---|
| H1 | Press BTN2 (Reset) | All category LEDs off |
| H2 | SW3–SW0 = 0011 (3), press BTN0 | LD0 on |
| H3 | Change switches | No change |
| H4 | Press BTN1 (ACK) | All off |
| H5 | 0110 (6), BTN0 | LD1 on |
| H6 | 1010 (10), BTN0 after ACK | LD2 on |
| H7 | 1110 (14), BTN0 after ACK | LD3 on |
| H8 | Boundaries 4, 5, 8, 9, 12, 13 | Correct category each time |
| H9 | Reset while a result is shown | All off |
