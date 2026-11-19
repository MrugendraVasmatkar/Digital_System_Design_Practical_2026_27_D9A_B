## =====================================================================
## Constraints for gray_code_top_arty - Digilent Arty S7-50 (XC7S50-CSGA324-1)
## sw[3:0] = data X, btn[0] = START, btn[1] = ACK, btn[2] = RESET
## =====================================================================

## Clock signal (100 MHz)
set_property -dict { PACKAGE_PIN R2 IOSTANDARD SSTL135 } [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches sw[3:0]  (data input X)
set_property -dict { PACKAGE_PIN H14 IOSTANDARD LVCMOS33 } [get_ports {sw[0]}]
set_property -dict { PACKAGE_PIN H18 IOSTANDARD LVCMOS33 } [get_ports {sw[1]}]
set_property -dict { PACKAGE_PIN G18 IOSTANDARD LVCMOS33 } [get_ports {sw[2]}]
set_property -dict { PACKAGE_PIN M5  IOSTANDARD SSTL135  } [get_ports {sw[3]}]

## Push buttons
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports {btn[0]}]   ;# START
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports {btn[1]}]   ;# ACK
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33 } [get_ports {btn[2]}]   ;# RESET

## LEDs
##   led[0] VALID, led[1] INVALID, led[2] IDLE, led[3] V
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports {led[0]}]
set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33 } [get_ports {led[1]}]
set_property -dict { PACKAGE_PIN E13 IOSTANDARD LVCMOS33 } [get_ports {led[2]}]
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports {led[3]}]

## Configuration options
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
