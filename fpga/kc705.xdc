
create_clock -period 5.000 -name clk200M [get_nets clk200M]

create_clock -period 500.000 -name clk2M [get_nets clk2M]

create_clock -period 500.000 -name clk2M_1 [get_nets rec_adc_packet_ins/CLK2M]

create_clock -period 500.000 -name cnvclk -waveform {0.000 100.000} [get_nets cnvclk]
create_clock -period 500.000 -name clk_div [get_nets clk_div]
create_clock -period 5.000 -name sysclk_p [get_ports sysclk_p]

#create_clock -period 500.000 -name cnvclk [get_nets rec_adc_packet_ins/CNVCLK]
#create_clock -period 500.000 -name cnvclk -waveform {0.000 100.000} [get_nets rec_adc_packet_ins/CNVCLK]
#set_false_path -to [get_clocks cnvclk]



















set_property PACKAGE_PIN AF20 [get_ports BUSY_p]
set_property PACKAGE_PIN AH21 [get_ports TRIGGER_CLOCK_p]
set_property PACKAGE_PIN L25 [get_ports TRIGGER_TTL]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 131072 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list sysclk_ins_test/inst/clk_out3]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {trigger_cnt[0]} {trigger_cnt[1]} {trigger_cnt[2]} {trigger_cnt[3]} {trigger_cnt[4]} {trigger_cnt[5]} {trigger_cnt[6]} {trigger_cnt[7]} {trigger_cnt[8]} {trigger_cnt[9]} {trigger_cnt[10]} {trigger_cnt[11]} {trigger_cnt[12]} {trigger_cnt[13]} {trigger_cnt[14]} {trigger_cnt[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list tlu_handshake_inst/busy]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list clk2M]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list tlu_handshake_inst/trigger]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list tlu_handshake_inst/trigger_clock]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list tlu_handshake_inst/trigger_clock_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list trigger_cnt_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list trigger_valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk100M_2]
