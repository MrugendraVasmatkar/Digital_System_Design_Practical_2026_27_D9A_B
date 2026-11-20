set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports clk]

set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports reset_btn]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports start_btn]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports ack_btn]

set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {sw[3]}]

set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports led_now]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports led_warn]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports led_lock]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports led_err]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]