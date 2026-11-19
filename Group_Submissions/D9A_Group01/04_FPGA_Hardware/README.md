# 04 – FPGA Hardware

## Board and tools
- **Board:** Digilent Arty S7-50
- **Device:** Xilinx Spartan-7 `XC7S50-CSGA324-1`
- **Tool/version:** Vivado – version to be recorded when implemented
- **Clock:** 100 MHz on pin R2, constrained with a 10 ns period

## Files
| File | Purpose |
|---|---|
| `arty_s7_50_gray_code.xdc` | Pin assignments and clock constraint for `gray_code_top_arty` |
| `../03_Verilog_Implementation/RTL/gray_code_top_arty_s7.v` | FPGA top-level module |

## Pin mapping (N = 4)
| Signal | Board resource | Pin |
|---|---|---|
| `clk` | 100 MHz clock | R2 |
| `sw[0]` … `sw[3]` | Switches SW0–SW3 (data X) | H14, H18, G18, M5 |
| `btn[0]` | BTN0 – START (load sample) | G15 |
| `btn[1]` | BTN1 – ACK (return to IDLE) | K16 |
| `btn[2]` | BTN2 – RESET | J16 |
| `led[0]` | LD0 – VALID | E18 |
| `led[1]` | LD1 – INVALID | F13 |
| `led[2]` | LD2 – IDLE | E13 |
| `led[3]` | LD3 – V (detector output) | H15 |

The board has only four switches, so the FPGA demo uses N = 4 (the original problem size). The core RTL is parameterised (the testbench instantiates N = 4 and N = 8).

**Note:** pin numbers must be checked against Digilent's `Arty-S7-50-Master.xdc` before programming.

## Hardware test procedure
1. Press BTN2 (RESET). All LEDs except IDLE (LD2) are off.
2. Set SW3..SW0, press BTN0 (START). One-bit change from the previous sample → LD0 (VALID); otherwise LD1 (INVALID).
3. Press BTN1 (ACK) to return to IDLE.

## Implementation results
Pending – record synthesis/implementation utilisation and timing reports, bitstream generation and hardware photos/video here.
