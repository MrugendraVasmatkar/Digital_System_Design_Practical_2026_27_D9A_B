## Clock Signal (3.3V LVCMOS33 - avoids Bank 34 VREF conflict)
set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVCMOS33 } [get_ports { clk }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clk }];
## 4-Bit XP Input Switches (SW0 - SW3)
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { xp_in[0] }];
set_property -dict { PACKAGE_PIN H18   IOSTANDARD LVCMOS33 } [get_ports { xp_in[1] }];
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { xp_in[2] }];
set_property -dict { PACKAGE_PIN M5    IOSTANDARD LVCMOS33 } [get_ports { xp_in[3] }];

## Control Pushbuttons (BTN0 - BTN2)
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { reset }];
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { start }];
set_property -dict { PACKAGE_PIN J16   IOSTANDARD LVCMOS33 } [get_ports { ack }];

## Output Level LEDs (LD0 - LD3)
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { led_beginner }];
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { led_intermediate }];
set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVCMOS33 } [get_ports { led_expert }];
set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { led_master }];
