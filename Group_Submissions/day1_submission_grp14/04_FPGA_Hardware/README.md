# 04 – FPGA Hardware

| File | Contents |
|---|---|
| `constraints.xdc` | Pin and I/O standard constraints (LVCMOS33) for the 11 ports |
| `implemented_design.png` | Vivado 2018.3: implemented design (24 cells, 11 I/O ports, 32 nets) with placed schematic and I/O Ports view |
| `utilization_report.png` | Vivado 2018.3 utilization report (hierarchy view): 6 LUTs, 4 registers, 2 slices, 11 bonded IOBs, 1 BUFGCTRL |
| `power_report.png` | Vivado 2018.3 power report (estimate): 3.43 W total, 41.9 °C junction temperature |
| `timing_summary.png` | Vivado 2018.3 Design Timing Summary: no user timing constraints (WNS/WHS = inf, 15 endpoints) |
| `constraints_with_clock.png` | Vivado 2018.3: constraints file `game_dsd.xdc` with `create_clock -period 10.000 [get_ports clk]` on line 1 |
| `bitstream_generation_completed.png` | Vivado 2018.3: "Bitstream Generation successfully completed" after the clock constraint was added |

**Still to add:** a refreshed timing summary (reload the implemented design, then Report Timing Summary), the generated `.bit` file (if allowed), and hardware demonstration photos/video with expected vs observed results.
