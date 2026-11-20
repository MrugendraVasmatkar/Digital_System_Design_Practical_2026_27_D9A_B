## 100 MHz System Clock (Spartan-7 XC7S50 Boolean Board)
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports {clk}]
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]

## Bank 0 Configuration Voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## XP Input -> Slide Switches sw[3:0]
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {xp[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {xp[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {xp[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {xp[3]}]

## Control Inputs -> Push Buttons btn[2:0]
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {start}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {ack}]

## Status Outputs -> Discrete LEDs led[2:0]
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {green}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {yellow}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {red}]