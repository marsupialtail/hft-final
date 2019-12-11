// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.2 (lin64) Build 2615518 Fri Aug  9 15:53:29 MDT 2019
// Date        : Thu Dec  5 11:14:56 2019
// Host        : EECS-DIGITAL-41 running 64-bit Ubuntu 16.04.6 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top div_gen_0 -prefix
//               div_gen_0_ div_gen_0_stub.v
// Design      : div_gen_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_15,Vivado 2019.1.2" *)
module div_gen_0(aclk, s_axis_divisor_tvalid, 
  s_axis_divisor_tdata, s_axis_dividend_tvalid, s_axis_dividend_tuser, 
  s_axis_dividend_tdata, m_axis_dout_tvalid, m_axis_dout_tuser, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_divisor_tvalid,s_axis_divisor_tdata[15:0],s_axis_dividend_tvalid,s_axis_dividend_tuser[3:0],s_axis_dividend_tdata[15:0],m_axis_dout_tvalid,m_axis_dout_tuser[3:0],m_axis_dout_tdata[31:0]" */;
  input aclk;
  input s_axis_divisor_tvalid;
  input [15:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  input [3:0]s_axis_dividend_tuser;
  input [15:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [3:0]m_axis_dout_tuser;
  output [31:0]m_axis_dout_tdata;
endmodule
