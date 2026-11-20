# 04 – FPGA Hardware

| File | Contents |
|---|---|
| `constraints.xdc` | Pin and I/O standard constraints (LVCMOS33) for the 11 ports |
| `implemented_design.png` | Vivado 2018.3: implemented design (24 cells, 11 I/O ports, 32 nets) with placed schematic and I/O Ports view |
| `utilization_report.png` | Vivado 2018.3 utilization report (hierarchy view): 6 LUTs, 4 registers, 2 slices, 11 bonded IOBs, 1 BUFGCTRL |
| `power_report.png` | Vivado 2018.3 power report (estimate): 3.43 W total, 41.9 °C junction temperature |
| `timing_summary.png` | Vivado 2018.3 Design Timing Summary after the clock constraint: WNS 7.665 ns, WHS 0.540 ns, 0 failing endpoints, all user specified timing constraints met |
| `constraints_with_clock.png` | Vivado 2018.3: constraints file `game_dsd.xdc` with `create_clock -period 10.000 [get_ports clk]` on line 1 |
| `bitstream_generation_completed.png` | Vivado 2018.3: "Bitstream Generation successfully completed" after the clock constraint was added |
| `hardware_low_led.jpg`, `hardware_medium_led.jpg`, `hardware_high_led.jpg` | Photos of the RealDigital Boolean Board running the design: LD0 (LOW), LD1 (MEDIUM) and LD2 (HIGH) lit, DONE LED on |

**Still to add (optional):** a video or photos that show the score switches, ACK turning the LED off, and the reset behaviour; the `.bit` file if allowed.
