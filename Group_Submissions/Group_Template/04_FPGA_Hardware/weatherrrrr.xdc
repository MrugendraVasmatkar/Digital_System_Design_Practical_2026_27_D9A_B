## =====================================================
## weather_alert_H4_boolean.xdc
## Real Digital Boolean Board (Spartan-7 xc7s50csga324-1)
## =====================================================

## ---------- Clock: 100 MHz ----------
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0 5} [get_ports clk]

## ---------- Switches: Wind[2:0] = SW0, SW1, SW2 ----------
set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {Wind[0]}]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {Wind[1]}]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {Wind[2]}]

## ---------- Buttons: reset = BTN0, START = BTN1, ACK = BTN2 ----------
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports START]
set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports ACK]

## ---------- Calm_LED[3:0] = LD0..LD3 ----------
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {Calm_LED[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {Calm_LED[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {Calm_LED[2]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {Calm_LED[3]}]

## ---------- Breezy_LED[3:0] = LD4..LD7 ----------
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {Breezy_LED[0]}]
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {Breezy_LED[1]}]
set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {Breezy_LED[2]}]
set_property -dict {PACKAGE_PIN E5 IOSTANDARD LVCMOS33} [get_ports {Breezy_LED[3]}]

## ---------- Storm_LED[3:0] = LD8..LD11 ----------
set_property -dict {PACKAGE_PIN E6 IOSTANDARD LVCMOS33} [get_ports {Storm_LED[0]}]
set_property -dict {PACKAGE_PIN C3 IOSTANDARD LVCMOS33} [get_ports {Storm_LED[1]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {Storm_LED[2]}]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {Storm_LED[3]}]

## ---------- state[1:0] = LD12, LD13 ----------
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {state[0]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {state[1]}]

## ---------- Buzzer = LD15 ----------
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports Buzzer]

## ---------- Count ports (no pins left on the board LEDs) ----------
## Same values are already shown on the *_LED outputs above.
set_property IOSTANDARD LVCMOS33 [get_ports {Calm_Count[*] Breezy_Count[*] Storm_Count[*]}]
set_property SEVERITY {Warning} [get_drc_checks UCIO-1]
set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

## ---------- Configuration ----------
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]