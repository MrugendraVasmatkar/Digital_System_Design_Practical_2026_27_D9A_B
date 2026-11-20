# 04 – FPGA Hardware

**Group:** Group 08 | **Board:** RealDigital Boolean Board | **Device:** Xilinx Spartan-7 `xc7s50csga324-1` (Speed Grade `-1`, CSGA324) | **Tool:** Xilinx Vivado

## 1. Hardware Platform & Top-Level Wrapper (`boolean_top_h4.v`)

The verified core module `forbidden_zone_rejector_h4.v` is wrapped inside `boolean_top_h4.v` for physical hardware deployment without modifying any Stage 2 RTL logic:
* **10 ms Pushbutton Debouncers (`debounce_10ms`):** Condition `BTN0` (`START`) and `BTN1` (`ACK`) at `100 MHz` (`1,000,000` cycles) to eliminate mechanical contact bounce and prevent multi-counting.
* **Dual Hex 7-Segment Decoders (`hex_to_7seg`):** Drive common-anode (active-low) displays `D0` (`ACCEPT_COUNT`, Hex `0`–`F`) and `D1` (`REJECT_COUNT`, Hex `0`–`F`) simultaneously on Digit 0 (`D0_a = 4'b1110`, `D1_a = 4'b1110`) with zero multiplexing flicker.
* **Redundant Visual Indicators:** Standard LEDs (`LD0`–`LD9`) and Green/Red RGB LEDs (`RGB0_G`, `RGB1_R`) mirror both FSM state and binary counter values simultaneously.

## 2. Verified Pin Mapping (`boolean_h4.xdc`, `LVCMOS33`)

| Signal | Boolean Board Peripheral | `PACKAGE_PIN` | I/O Standard / Notes |
| :--- | :--- | :--- | :--- |
| `mclk` | 100 MHz Onboard Oscillator | `F14` | `LVCMOS33`; `create_clock -period 10.000` |
| `sw[3:0]` | Slide Switches `SW3..SW0` (`X3..X0`) | `T2, U1, U2, V2` | `LVCMOS33` |
| `btn[0]` | Pushbutton `BTN0` (`START`) | `J2` | `LVCMOS33` (10 ms debounced) |
| `btn[1]` | Pushbutton `BTN1` (`ACK`) | `J5` | `LVCMOS33` (10 ms debounced) |
| `btn[2]` | Pushbutton `BTN2` (`RESET`) | `H2` | `LVCMOS33` (Synchronous active-high) |
| `led[0]`, `rgb0_g` | `LD0` + Green RGB0 (`ACCEPT_LED`) | `G1`, `V4` | `LVCMOS33` |
| `led[1]`, `rgb1_r` | `LD1` + Red RGB1 (`REJECT_LED`) | `G2`, `U3` | `LVCMOS33` |
| `led[5:2]` | `LD5..LD2` (`ACCEPT_COUNT[3:0]`) | `E2, E1, F2, F1` | `LVCMOS33` (Binary display) |
| `led[9:6]` | `LD9..LD6` (`REJECT_COUNT[3:0]`) | `C3, E6, E5, E3` | `LVCMOS33` (Binary display) |
| `D0_a[3:0]`, `D0_seg[7:0]` | 7-Segment Display 0 (`ACCEPT_COUNT`) | `A8, C7, C4, D5` / `A6..D7` | `LVCMOS33` (Active-low Hex `0`–`F`) |
| `D1_a[3:0]`, `D1_seg[7:0]` | 7-Segment Display 1 (`REJECT_COUNT`) | `E4, F3, J4, H3` / `C1..F4` | `LVCMOS33` (Active-low Hex `0`–`F`) |
| Bank 0 Config | `CFGBVS = VCCO`, `CONFIG_VOLTAGE = 3.3` | Bank 0 | Matches 3.3 V Boolean Board I/O bank |

## 3. Post-Implementation & Bitstream Results (`impl_1`)

| Metric | Core RTL Only (`forbidden_zone_rejector_h4`) | Full Board Top (`boolean_top_h4`) | Status |
| :--- | :---: | :---: | :--- |
| **LUTs Used** | `9` (`0.03%`) | **`34`** (`0.10%`) | Pass |
| **Flip-Flops (`FDRE`)** | `17` (`0.03%`) | **`62`** (`0.10%`) | Pass |
| **BRAM / DSP** | `0` / `0` | **`0` / `0`** | Pass |
| **Worst Negative Slack (`WNS`)** | — | **`+5.209 ns`** (`TNS = 0.000 ns`) | Timing Met (100 MHz) |
| **Worst Hold Slack (`WHS`)** | — | **`+0.216 ns`** (`THS = 0.000 ns`) | Timing Met |
| **Failed Routes** | — | **`0`** | Clean Routing |
| **Total On-Chip Power** | — | **`0.083 W`** (`83 mW`) | Low Power |
| **Bitstream Status** | — | **`write_bitstream Complete!`** | Ready to Program |

* **Methodology Note:** The `35` `TIMING-18` warnings (`missing input/output delay relative to sys_clk_pin`) are expected and harmless for asynchronous human I/O (`sw`, `btn`, `led`, `rgb`, `D0_seg`, `D1_seg`).

## 4. Hardware Programming & Demo Procedure

1. Connect micro-USB to **`PROG UART`**, verify `EXTP` jumper is on **`USB`**, and turn the top-left power switch **ON**.
2. Open Vivado **Hardware Manager** → **Open Target** → **Auto Connect** → right-click **`xc7s50_0`** → **Program Device** → select `boolean_top_h4.bit` → **Program**.
3. Verify live: `BTN2` (`RESET`) → `BTN0` (`START`) on allowed (`0–5`, `10–15`) and forbidden (`6–9`) inputs → `BTN1` (`ACK`) to clear `REJECT`.
