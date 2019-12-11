//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1.2 (lin64) Build 2615518 Fri Aug  9 15:53:29 MDT 2019
//Date        : Tue Nov  5 11:22:02 2019
//Host        : eecs-digital-32 running 64-bit Ubuntu 14.04.6 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (sys_clock);
  input sys_clock;

  wire sys_clock;

  design_1 design_1_i
       (.sys_clock(sys_clock));
endmodule
