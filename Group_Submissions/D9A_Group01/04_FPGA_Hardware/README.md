# 04 – FPGA Hardware

## Board and tools
- **Device:** Xilinx Spartan-7 `XC7S50-CSGA324-1`
- **Board:** to be confirmed – the supplied constraints use a clock on pin F14, which is not the Arty S7 clock pin (R2)
- **Tool/version:** Vivado – version to be recorded when implemented
- **Top module:** `gray_code_nbit` (N = 4)

## Files
| File | Purpose |
|---|---|
| `gray_code_nbit.xdc` | Pin assignments and I/O standards for `gray_code_nbit` (N = 4) |
| `../03_Verilog_Implementation/RTL/gray_code_nbit.v` | Design / top module |

## Pin mapping (`gray_code_nbit.xdc`)
All ports use `LVCMOS33`.

| Port | Function | Pin |
|---|---|---|
| `clk` | Clock | F14 |
| `rst` | Reset (synchronous, active-high) | J2 |
| `start` | START – take a sample | J5 |
| `ack` | ACK – return to IDLE | H2 |
| `x[0]` | Data bit 0 | V2 |
| `x[1]` | Data bit 1 | U2 |
| `x[2]` | Data bit 2 | U1 |
| `x[3]` | Data bit 3 | T2 |
| `valid_led` | VALID LED | G1 |
| `invalid_led` | INVALID LED | G2 |

Notes: the file has no `create_clock` constraint (timing is unconstrained) and the buttons are used without debouncing.

## Hardware test procedure
1. Press `rst`. Both LEDs are off (IDLE).
2. Set `x[3:0]` and press `start`. A one-bit change from the previous sample lights `valid_led`; zero or more than one changed bit lights `invalid_led`.
3. Press `ack` to return to IDLE, then repeat.

## Implementation results
Pending – record synthesis/implementation utilisation and timing reports, bitstream generation and hardware photos/video here.
