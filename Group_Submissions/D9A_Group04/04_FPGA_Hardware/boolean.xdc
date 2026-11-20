## Clock: 100 MHz oscillator (port name must be "Clock")
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {Clock}]
create_clock -period 10.000 -name sys_clk [get_ports {Clock}]

## Bank 0 voltage
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Score[3:0] -> slide switches SW0..SW3
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {Score[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {Score[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {Score[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {Score[3]}]

## Control inputs -> push buttons
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {START}]   ;# BTN0
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {ACK}]     ;# BTN1
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {Reset}]   ;# BTN2

## Category outputs -> on-board LEDs LD0..LD3
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {LED_LOW}]        ;# LD0
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {LED_MEDIUM}]     ;# LD1
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {LED_HIGH}]       ;# LD2
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {LED_EXCELLENT}]  ;# LD3
