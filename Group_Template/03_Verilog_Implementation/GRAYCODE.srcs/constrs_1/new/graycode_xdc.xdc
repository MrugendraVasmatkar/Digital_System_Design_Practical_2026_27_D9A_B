## 1. Clock Constraint (100 MHz)
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## 2. Set I/O Standard for All Ports
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports ack]
set_property IOSTANDARD LVCMOS33 [get_ports {x[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports valid]
set_property IOSTANDARD LVCMOS33 [get_ports invalid]

## 3. Allow Bitstream Generation with Auto-Placed Pins (Prevents UCIO-1 DRC Error)
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
