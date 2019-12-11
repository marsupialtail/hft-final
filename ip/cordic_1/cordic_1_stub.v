// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.2 (lin64) Build 2615518 Fri Aug  9 15:53:29 MDT 2019
// Date        : Sun Dec  8 14:27:42 2019
// Host        : EECS-DIGITAL-41 running 64-bit Ubuntu 16.04.6 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top cordic_1 -prefix
//               cordic_1_ cordic_1_stub.v
// Design      : cordic_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cordic_v6_0_15,Vivado 2019.1.2" *)
module cordic_1(aclk, s_axis_cartesian_tvalid, 
  s_axis_cartesian_tuser, s_axis_cartesian_tdata, m_axis_dout_tvalid, m_axis_dout_tuser, 
  m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_cartesian_tvalid,s_axis_cartesian_tuser[3:0],s_axis_cartesian_tdata[31:0],m_axis_dout_tvalid,m_axis_dout_tuser[3:0],m_axis_dout_tdata[15:0]" */;
  input aclk;
  input s_axis_cartesian_tvalid;
  input [3:0]s_axis_cartesian_tuser;
  input [31:0]s_axis_cartesian_tdata;
  output m_axis_dout_tvalid;
  output [3:0]m_axis_dout_tuser;
  output [15:0]m_axis_dout_tdata;
endmodule
