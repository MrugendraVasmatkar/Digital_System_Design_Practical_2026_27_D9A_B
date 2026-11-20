//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Fri Nov 20 12:56:48 2026
//Host        : DESKTOP-HSSC9M8 running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=5,numReposBlks=5,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,da_clkrst_cnt=2,synth_mode=Global}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (ack_0,
    breezy_led_0,
    bus_struct_reset_0,
    buzzer_0,
    calm_led_0,
    clk_100MHz,
    ext_reset_in_0,
    interconnect_aresetn_0,
    mb_reset_0,
    peripheral_reset_0,
    start_0,
    state_out_0,
    storm_led_0,
    warning_led_0,
    wind_in_0,
    wind_reg_out_0);
  input ack_0;
  output breezy_led_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.BUS_STRUCT_RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.BUS_STRUCT_RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) output [0:0]bus_struct_reset_0;
  output buzzer_0;
  output calm_led_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, CLK_DOMAIN design_1_clk_100MHz, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_100MHz;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.EXT_RESET_IN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.EXT_RESET_IN_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input ext_reset_in_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.INTERCONNECT_ARESETN_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.INTERCONNECT_ARESETN_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) output [0:0]interconnect_aresetn_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.MB_RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.MB_RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) output mb_reset_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.PERIPHERAL_RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.PERIPHERAL_RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) output [0:0]peripheral_reset_0;
  input start_0;
  output [2:0]state_out_0;
  output storm_led_0;
  output warning_led_0;
  input [2:0]wind_in_0;
  output [2:0]wind_reg_out_0;

  wire ack_0_1;
  wire clk_100MHz_1;
  wire ext_reset_in_0_1;
  wire [0:0]rst_clk_100MHz_100M_bus_struct_reset;
  wire [0:0]rst_clk_100MHz_100M_interconnect_aresetn;
  wire rst_clk_100MHz_100M_mb_reset;
  wire [0:0]rst_clk_100MHz_100M_peripheral_reset;
  wire start_0_1;
  wire [0:0]util_vector_logic_0_Res;
  wire weather_alert_core_0_breezy_led;
  wire weather_alert_core_0_buzzer;
  wire weather_alert_core_0_calm_led;
  wire [2:0]weather_alert_core_0_state_out;
  wire weather_alert_core_0_storm_led;
  wire weather_alert_core_0_warning_led;
  wire [2:0]weather_alert_core_0_wind_reg_out;
  wire [2:0]wind_in_0_1;
  wire [0:0]xlconstant_0_dout;
  wire [0:0]xlconstant_1_dout;

  assign ack_0_1 = ack_0;
  assign breezy_led_0 = weather_alert_core_0_breezy_led;
  assign bus_struct_reset_0[0] = rst_clk_100MHz_100M_bus_struct_reset;
  assign buzzer_0 = weather_alert_core_0_buzzer;
  assign calm_led_0 = weather_alert_core_0_calm_led;
  assign clk_100MHz_1 = clk_100MHz;
  assign ext_reset_in_0_1 = ext_reset_in_0;
  assign interconnect_aresetn_0[0] = rst_clk_100MHz_100M_interconnect_aresetn;
  assign mb_reset_0 = rst_clk_100MHz_100M_mb_reset;
  assign peripheral_reset_0[0] = rst_clk_100MHz_100M_peripheral_reset;
  assign start_0_1 = start_0;
  assign state_out_0[2:0] = weather_alert_core_0_state_out;
  assign storm_led_0 = weather_alert_core_0_storm_led;
  assign warning_led_0 = weather_alert_core_0_warning_led;
  assign wind_in_0_1 = wind_in_0[2:0];
  assign wind_reg_out_0[2:0] = weather_alert_core_0_wind_reg_out;
  design_1_rst_clk_100MHz_100M_0 rst_clk_100MHz_100M
       (.aux_reset_in(xlconstant_0_dout),
        .bus_struct_reset(rst_clk_100MHz_100M_bus_struct_reset),
        .dcm_locked(xlconstant_0_dout),
        .ext_reset_in(util_vector_logic_0_Res),
        .interconnect_aresetn(rst_clk_100MHz_100M_interconnect_aresetn),
        .mb_debug_sys_rst(xlconstant_1_dout),
        .mb_reset(rst_clk_100MHz_100M_mb_reset),
        .peripheral_reset(rst_clk_100MHz_100M_peripheral_reset),
        .slowest_sync_clk(clk_100MHz_1));
  design_1_util_vector_logic_0_0 util_vector_logic_0
       (.Op1(ext_reset_in_0_1),
        .Res(util_vector_logic_0_Res));
  design_1_weather_alert_core_0_0 weather_alert_core_0
       (.ack(ack_0_1),
        .breezy_led(weather_alert_core_0_breezy_led),
        .buzzer(weather_alert_core_0_buzzer),
        .calm_led(weather_alert_core_0_calm_led),
        .clk(clk_100MHz_1),
        .reset(rst_clk_100MHz_100M_bus_struct_reset),
        .start(start_0_1),
        .state_out(weather_alert_core_0_state_out),
        .storm_led(weather_alert_core_0_storm_led),
        .warning_led(weather_alert_core_0_warning_led),
        .wind_in(wind_in_0_1),
        .wind_reg_out(weather_alert_core_0_wind_reg_out));
  design_1_xlconstant_0_0 xlconstant_0
       (.dout(xlconstant_0_dout));
  design_1_xlconstant_1_0 xlconstant_1
       (.dout(xlconstant_1_dout));
endmodule
