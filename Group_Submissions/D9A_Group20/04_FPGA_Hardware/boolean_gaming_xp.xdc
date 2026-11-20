## Boolean Board (Real Digital, Spartan-7 xc7s50csga324-1)
## Top module: gaming_xp_top
## Pin numbers from Real Digital's Boolean Board constraints listing.

## 100 MHz clock
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -name sys_clk -period 10.000 [get_ports clk]

## XP[4:0] on slide switches SW0..SW3 + SW5 (SW5 = MSB)
## SW4 on this board is faulty (always reads 1), so XP bit 4 uses SW5 instead
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {sw[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {sw[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {sw[2]}]
set_property -dict {PACKAGE_PIN T2 IOSTANDARD LVCMOS33} [get_ports {sw[3]}]
set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {sw[4]}]   ;# SW5

## Buttons: BTN0 = START, BTN1 = ACK, BTN2 = RESET
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {btn[2]}]

## LEDs: LD0 = BEGINNER, LD1 = INTERMEDIATE, LD2 = EXPERT, LD3 = ERROR
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {led[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led[2]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {led[3]}]
## DEBUG: LD5 shows XP bit 4 (SW5) live
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {led[4]}]

## Switches and buttons are asynchronous to clk (handled by the 2-FF synchronizers)
set_false_path -from [get_ports {sw[*] btn[*]}]
## LEDs are viewed by eye, no output timing needed
set_false_path -to [get_ports {led[*]}]

## Bitstream settings
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
