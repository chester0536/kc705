// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Sun Mar 18 15:28:41 2018
// Host        : dell-PC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ coregen_buffer_mem16_stub.v
// Design      : coregen_buffer_mem16
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_3_6,Vivado 2017.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[5:0],dina[15:0],douta[15:0],clkb,web[0:0],addrb[5:0],dinb[15:0],doutb[15:0]" */;
  input clka;
  input [0:0]wea;
  input [5:0]addra;
  input [15:0]dina;
  output [15:0]douta;
  input clkb;
  input [0:0]web;
  input [5:0]addrb;
  input [15:0]dinb;
  output [15:0]doutb;
endmodule
