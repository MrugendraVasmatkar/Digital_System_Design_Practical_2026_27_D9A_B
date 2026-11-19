# 04 – FPGA Hardware

| File | Contents |
|---|---|
| `constraints.xdc` | Pin and I/O standard constraints (LVCMOS33) for the 11 ports |
| `synthesized_design_io_ports.png` | Vivado 2018.3: synthesized design for `xc7s50csga324-1`, I/O Ports view, status "write_bitstream Complete" |
| `implemented_design.png` | Vivado 2018.3: implemented design (24 cells, 11 I/O ports, 32 nets) with placed schematic and I/O Ports view |
| `utilization_report.png` | Vivado 2018.3 utilization report (hierarchy view): 6 LUTs, 4 registers, 2 slices, 11 bonded IOBs, 1 BUFGCTRL |
| `power_report.png` | Vivado 2018.3 power report (estimate): 3.43 W total, 41.9 °C junction temperature |

**Still to add:** timing summary report, the generated `.bit` file (if allowed), and hardware demonstration photos/video with expected vs observed results.
