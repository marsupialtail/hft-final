// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.2 (lin64) Build 2615518 Fri Aug  9 15:53:29 MDT 2019
// Date        : Sun Dec  1 15:28:13 2019
// Host        : EECS-DIGITAL-41 running 64-bit Ubuntu 16.04.6 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top xbip_dsp48_macro_0 -prefix
//               xbip_dsp48_macro_0_ xbip_dsp48_macro_0_stub.v
// Design      : xbip_dsp48_macro_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2019.1.2" *)
module xbip_dsp48_macro_0(SEL, A, B, C, P)
/* synthesis syn_black_box black_box_pad_pin="SEL[1:0],A[15:0],B[15:0],C[15:0],P[32:0]" */;
  input [1:0]SEL;
  input [15:0]A;
  input [15:0]B;
  input [15:0]C;
  output [32:0]P;
endmodule
