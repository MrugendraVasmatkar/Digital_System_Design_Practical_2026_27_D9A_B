## Weather Alert System - RealDigital Boolean Board (Spartan-7 XC7S50-CSGA324-1)
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Clock (100 MHz)
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk_100MHz]
create_clock -period 10.000 -name sys_clk [get_ports clk_100MHz]

## Wind switches sw0..sw2
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {wind_in_0[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {wind_in_0[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {wind_in_0[2]}]

## Buttons: BTN0 = RESET, BTN1 = START, BTN2 = ACK
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports ext_reset_in_0]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports start_0]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports ack_0]

## Category LEDs: led0..led4
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports calm_led_0]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports breezy_led_0]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports warning_led_0]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports storm_led_0]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports buzzer_0]

## Registered wind value: led8..led10
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {wind_reg_out_0[0]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {wind_reg_out_0[1]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {wind_reg_out_0[2]}]

## FSM state: led13..led15
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {state_out_0[0]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {state_out_0[1]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {state_out_0[2]}]

## Reset-block outputs on spare LEDs (led5, led6, led7, led11)
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports mb_reset_0]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {bus_struct_reset_0[0]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {peripheral_reset_0[0]}]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {interconnect_aresetn_0[0]}]