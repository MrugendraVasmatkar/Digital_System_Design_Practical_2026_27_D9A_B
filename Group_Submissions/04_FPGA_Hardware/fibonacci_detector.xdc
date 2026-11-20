set_property PACKAGE_PIN F14  [get_ports clk]
set_property PACKAGE_PIN J2 [get_ports reset]
set_property PACKAGE_PIN J5 [get_ports start]
set_property PACKAGE_PIN H2 [get_ports ack]
set_property PACKAGE_PIN V2 [get_ports {x[0]}]
set_property PACKAGE_PIN U2 [get_ports {x[1]}]
set_property PACKAGE_PIN U1 [get_ports {x[2]}]
set_property PACKAGE_PIN T2 [get_ports {x[3]}]
set_property PACKAGE_PIN T1 [get_ports input_valid]
set_property PACKAGE_PIN G1 [get_ports fib_led]
set_property PACKAGE_PIN G2 [get_ports nonfib_led]
set_property PACKAGE_PIN F1 [get_ports error_led]

set_property IOSTANDARD LVCMOS33 [get_ports {clk reset start ack input_valid x[0] x[1] x[2] x[3] fib_led nonfib_led error_led}]

create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]