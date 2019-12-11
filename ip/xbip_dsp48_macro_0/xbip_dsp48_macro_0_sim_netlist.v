// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1.2 (lin64) Build 2615518 Fri Aug  9 15:53:29 MDT 2019
// Date        : Sun Dec  1 15:28:13 2019
// Host        : EECS-DIGITAL-41 running 64-bit Ubuntu 16.04.6 LTS
// Command     : write_verilog -force -mode funcsim -rename_top xbip_dsp48_macro_0 -prefix
//               xbip_dsp48_macro_0_ xbip_dsp48_macro_0_sim_netlist.v
// Design      : xbip_dsp48_macro_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "xbip_dsp48_macro_0,xbip_dsp48_macro_v3_0_17,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "xbip_dsp48_macro_v3_0_17,Vivado 2019.1.2" *) 
(* NotValidForBitStream *)
module xbip_dsp48_macro_0
   (SEL,
    A,
    B,
    C,
    P);
  (* x_interface_info = "xilinx.com:signal:data:1.0 sel_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME sel_intf, LAYERED_METADATA undef" *) input [1:0]SEL;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [15:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [15:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 c_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME c_intf, LAYERED_METADATA undef" *) input [15:0]C;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [32:0]P;

  wire [15:0]A;
  wire [15:0]B;
  wire [15:0]C;
  wire [32:0]P;
  wire [1:0]SEL;
  wire NLW_U0_CARRYCASCOUT_UNCONNECTED;
  wire NLW_U0_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_U0_ACOUT_UNCONNECTED;
  wire [17:0]NLW_U0_BCOUT_UNCONNECTED;
  wire [47:0]NLW_U0_PCOUT_UNCONNECTED;

  (* C_A_WIDTH = "16" *) 
  (* C_B_WIDTH = "16" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "16" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "1" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "64" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000100100000010100000000,000000000011010100000001,000100100011010100000001" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "32" *) 
  (* C_REG_CONFIG = "00000000000000000000000000000000" *) 
  (* C_SEL_WIDTH = "2" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17 U0
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_U0_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_U0_BCOUT_UNCONNECTED[17:0]),
        .C(C),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_U0_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_U0_CARRYOUT_UNCONNECTED),
        .CE(1'b1),
        .CEA(1'b1),
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEA3(1'b1),
        .CEA4(1'b1),
        .CEB(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEB3(1'b1),
        .CEB4(1'b1),
        .CEC(1'b1),
        .CEC1(1'b1),
        .CEC2(1'b1),
        .CEC3(1'b1),
        .CEC4(1'b1),
        .CEC5(1'b1),
        .CECONCAT(1'b1),
        .CECONCAT3(1'b1),
        .CECONCAT4(1'b1),
        .CECONCAT5(1'b1),
        .CED(1'b1),
        .CED1(1'b1),
        .CED2(1'b1),
        .CED3(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),
        .CESEL(1'b1),
        .CESEL1(1'b1),
        .CESEL2(1'b1),
        .CESEL3(1'b1),
        .CESEL4(1'b1),
        .CESEL5(1'b1),
        .CLK(1'b1),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_U0_PCOUT_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(SEL));
endmodule

(* C_A_WIDTH = "16" *) (* C_B_WIDTH = "16" *) (* C_CONCAT_WIDTH = "48" *) 
(* C_CONSTANT_1 = "1" *) (* C_C_WIDTH = "16" *) (* C_D_WIDTH = "18" *) 
(* C_HAS_A = "1" *) (* C_HAS_ACIN = "0" *) (* C_HAS_ACOUT = "0" *) 
(* C_HAS_B = "1" *) (* C_HAS_BCIN = "0" *) (* C_HAS_BCOUT = "0" *) 
(* C_HAS_C = "1" *) (* C_HAS_CARRYCASCIN = "0" *) (* C_HAS_CARRYCASCOUT = "0" *) 
(* C_HAS_CARRYIN = "0" *) (* C_HAS_CARRYOUT = "0" *) (* C_HAS_CE = "0" *) 
(* C_HAS_CEA = "0" *) (* C_HAS_CEB = "0" *) (* C_HAS_CEC = "0" *) 
(* C_HAS_CECONCAT = "0" *) (* C_HAS_CED = "0" *) (* C_HAS_CEM = "0" *) 
(* C_HAS_CEP = "0" *) (* C_HAS_CESEL = "0" *) (* C_HAS_CONCAT = "0" *) 
(* C_HAS_D = "0" *) (* C_HAS_INDEP_CE = "0" *) (* C_HAS_INDEP_SCLR = "0" *) 
(* C_HAS_PCIN = "0" *) (* C_HAS_PCOUT = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_SCLRA = "0" *) (* C_HAS_SCLRB = "0" *) (* C_HAS_SCLRC = "0" *) 
(* C_HAS_SCLRCONCAT = "0" *) (* C_HAS_SCLRD = "0" *) (* C_HAS_SCLRM = "0" *) 
(* C_HAS_SCLRP = "0" *) (* C_HAS_SCLRSEL = "0" *) (* C_LATENCY = "64" *) 
(* C_MODEL_TYPE = "0" *) (* C_OPMODES = "000100100000010100000000,000000000011010100000001,000100100011010100000001" *) (* C_P_LSB = "0" *) 
(* C_P_MSB = "32" *) (* C_REG_CONFIG = "00000000000000000000000000000000" *) (* C_SEL_WIDTH = "2" *) 
(* C_TEST_CORE = "0" *) (* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17
   (CLK,
    CE,
    SCLR,
    SEL,
    CARRYCASCIN,
    CARRYIN,
    PCIN,
    ACIN,
    BCIN,
    A,
    B,
    C,
    D,
    CONCAT,
    ACOUT,
    BCOUT,
    CARRYOUT,
    CARRYCASCOUT,
    PCOUT,
    P,
    CED,
    CED1,
    CED2,
    CED3,
    CEA,
    CEA1,
    CEA2,
    CEA3,
    CEA4,
    CEB,
    CEB1,
    CEB2,
    CEB3,
    CEB4,
    CECONCAT,
    CECONCAT3,
    CECONCAT4,
    CECONCAT5,
    CEC,
    CEC1,
    CEC2,
    CEC3,
    CEC4,
    CEC5,
    CEM,
    CEP,
    CESEL,
    CESEL1,
    CESEL2,
    CESEL3,
    CESEL4,
    CESEL5,
    SCLRD,
    SCLRA,
    SCLRB,
    SCLRCONCAT,
    SCLRC,
    SCLRM,
    SCLRP,
    SCLRSEL);
  input CLK;
  input CE;
  input SCLR;
  input [1:0]SEL;
  input CARRYCASCIN;
  input CARRYIN;
  input [47:0]PCIN;
  input [29:0]ACIN;
  input [17:0]BCIN;
  input [15:0]A;
  input [15:0]B;
  input [15:0]C;
  input [17:0]D;
  input [47:0]CONCAT;
  output [29:0]ACOUT;
  output [17:0]BCOUT;
  output CARRYOUT;
  output CARRYCASCOUT;
  output [47:0]PCOUT;
  output [32:0]P;
  input CED;
  input CED1;
  input CED2;
  input CED3;
  input CEA;
  input CEA1;
  input CEA2;
  input CEA3;
  input CEA4;
  input CEB;
  input CEB1;
  input CEB2;
  input CEB3;
  input CEB4;
  input CECONCAT;
  input CECONCAT3;
  input CECONCAT4;
  input CECONCAT5;
  input CEC;
  input CEC1;
  input CEC2;
  input CEC3;
  input CEC4;
  input CEC5;
  input CEM;
  input CEP;
  input CESEL;
  input CESEL1;
  input CESEL2;
  input CESEL3;
  input CESEL4;
  input CESEL5;
  input SCLRD;
  input SCLRA;
  input SCLRB;
  input SCLRCONCAT;
  input SCLRC;
  input SCLRM;
  input SCLRP;
  input SCLRSEL;

  wire \<const0> ;
  wire [15:0]A;
  wire [15:0]B;
  wire [15:0]C;
  wire [32:0]P;
  wire [1:0]SEL;
  wire NLW_i_synth_CARRYCASCOUT_UNCONNECTED;
  wire NLW_i_synth_CARRYOUT_UNCONNECTED;
  wire [29:0]NLW_i_synth_ACOUT_UNCONNECTED;
  wire [17:0]NLW_i_synth_BCOUT_UNCONNECTED;
  wire [47:0]NLW_i_synth_PCOUT_UNCONNECTED;

  assign ACOUT[29] = \<const0> ;
  assign ACOUT[28] = \<const0> ;
  assign ACOUT[27] = \<const0> ;
  assign ACOUT[26] = \<const0> ;
  assign ACOUT[25] = \<const0> ;
  assign ACOUT[24] = \<const0> ;
  assign ACOUT[23] = \<const0> ;
  assign ACOUT[22] = \<const0> ;
  assign ACOUT[21] = \<const0> ;
  assign ACOUT[20] = \<const0> ;
  assign ACOUT[19] = \<const0> ;
  assign ACOUT[18] = \<const0> ;
  assign ACOUT[17] = \<const0> ;
  assign ACOUT[16] = \<const0> ;
  assign ACOUT[15] = \<const0> ;
  assign ACOUT[14] = \<const0> ;
  assign ACOUT[13] = \<const0> ;
  assign ACOUT[12] = \<const0> ;
  assign ACOUT[11] = \<const0> ;
  assign ACOUT[10] = \<const0> ;
  assign ACOUT[9] = \<const0> ;
  assign ACOUT[8] = \<const0> ;
  assign ACOUT[7] = \<const0> ;
  assign ACOUT[6] = \<const0> ;
  assign ACOUT[5] = \<const0> ;
  assign ACOUT[4] = \<const0> ;
  assign ACOUT[3] = \<const0> ;
  assign ACOUT[2] = \<const0> ;
  assign ACOUT[1] = \<const0> ;
  assign ACOUT[0] = \<const0> ;
  assign BCOUT[17] = \<const0> ;
  assign BCOUT[16] = \<const0> ;
  assign BCOUT[15] = \<const0> ;
  assign BCOUT[14] = \<const0> ;
  assign BCOUT[13] = \<const0> ;
  assign BCOUT[12] = \<const0> ;
  assign BCOUT[11] = \<const0> ;
  assign BCOUT[10] = \<const0> ;
  assign BCOUT[9] = \<const0> ;
  assign BCOUT[8] = \<const0> ;
  assign BCOUT[7] = \<const0> ;
  assign BCOUT[6] = \<const0> ;
  assign BCOUT[5] = \<const0> ;
  assign BCOUT[4] = \<const0> ;
  assign BCOUT[3] = \<const0> ;
  assign BCOUT[2] = \<const0> ;
  assign BCOUT[1] = \<const0> ;
  assign BCOUT[0] = \<const0> ;
  assign CARRYCASCOUT = \<const0> ;
  assign CARRYOUT = \<const0> ;
  assign PCOUT[47] = \<const0> ;
  assign PCOUT[46] = \<const0> ;
  assign PCOUT[45] = \<const0> ;
  assign PCOUT[44] = \<const0> ;
  assign PCOUT[43] = \<const0> ;
  assign PCOUT[42] = \<const0> ;
  assign PCOUT[41] = \<const0> ;
  assign PCOUT[40] = \<const0> ;
  assign PCOUT[39] = \<const0> ;
  assign PCOUT[38] = \<const0> ;
  assign PCOUT[37] = \<const0> ;
  assign PCOUT[36] = \<const0> ;
  assign PCOUT[35] = \<const0> ;
  assign PCOUT[34] = \<const0> ;
  assign PCOUT[33] = \<const0> ;
  assign PCOUT[32] = \<const0> ;
  assign PCOUT[31] = \<const0> ;
  assign PCOUT[30] = \<const0> ;
  assign PCOUT[29] = \<const0> ;
  assign PCOUT[28] = \<const0> ;
  assign PCOUT[27] = \<const0> ;
  assign PCOUT[26] = \<const0> ;
  assign PCOUT[25] = \<const0> ;
  assign PCOUT[24] = \<const0> ;
  assign PCOUT[23] = \<const0> ;
  assign PCOUT[22] = \<const0> ;
  assign PCOUT[21] = \<const0> ;
  assign PCOUT[20] = \<const0> ;
  assign PCOUT[19] = \<const0> ;
  assign PCOUT[18] = \<const0> ;
  assign PCOUT[17] = \<const0> ;
  assign PCOUT[16] = \<const0> ;
  assign PCOUT[15] = \<const0> ;
  assign PCOUT[14] = \<const0> ;
  assign PCOUT[13] = \<const0> ;
  assign PCOUT[12] = \<const0> ;
  assign PCOUT[11] = \<const0> ;
  assign PCOUT[10] = \<const0> ;
  assign PCOUT[9] = \<const0> ;
  assign PCOUT[8] = \<const0> ;
  assign PCOUT[7] = \<const0> ;
  assign PCOUT[6] = \<const0> ;
  assign PCOUT[5] = \<const0> ;
  assign PCOUT[4] = \<const0> ;
  assign PCOUT[3] = \<const0> ;
  assign PCOUT[2] = \<const0> ;
  assign PCOUT[1] = \<const0> ;
  assign PCOUT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_WIDTH = "16" *) 
  (* C_B_WIDTH = "16" *) 
  (* C_CONCAT_WIDTH = "48" *) 
  (* C_CONSTANT_1 = "1" *) 
  (* C_C_WIDTH = "16" *) 
  (* C_D_WIDTH = "18" *) 
  (* C_HAS_A = "1" *) 
  (* C_HAS_ACIN = "0" *) 
  (* C_HAS_ACOUT = "0" *) 
  (* C_HAS_B = "1" *) 
  (* C_HAS_BCIN = "0" *) 
  (* C_HAS_BCOUT = "0" *) 
  (* C_HAS_C = "1" *) 
  (* C_HAS_CARRYCASCIN = "0" *) 
  (* C_HAS_CARRYCASCOUT = "0" *) 
  (* C_HAS_CARRYIN = "0" *) 
  (* C_HAS_CARRYOUT = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_CEA = "0" *) 
  (* C_HAS_CEB = "0" *) 
  (* C_HAS_CEC = "0" *) 
  (* C_HAS_CECONCAT = "0" *) 
  (* C_HAS_CED = "0" *) 
  (* C_HAS_CEM = "0" *) 
  (* C_HAS_CEP = "0" *) 
  (* C_HAS_CESEL = "0" *) 
  (* C_HAS_CONCAT = "0" *) 
  (* C_HAS_D = "0" *) 
  (* C_HAS_INDEP_CE = "0" *) 
  (* C_HAS_INDEP_SCLR = "0" *) 
  (* C_HAS_PCIN = "0" *) 
  (* C_HAS_PCOUT = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_SCLRA = "0" *) 
  (* C_HAS_SCLRB = "0" *) 
  (* C_HAS_SCLRC = "0" *) 
  (* C_HAS_SCLRCONCAT = "0" *) 
  (* C_HAS_SCLRD = "0" *) 
  (* C_HAS_SCLRM = "0" *) 
  (* C_HAS_SCLRP = "0" *) 
  (* C_HAS_SCLRSEL = "0" *) 
  (* C_LATENCY = "64" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_OPMODES = "000100100000010100000000,000000000011010100000001,000100100011010100000001" *) 
  (* C_P_LSB = "0" *) 
  (* C_P_MSB = "32" *) 
  (* C_REG_CONFIG = "00000000000000000000000000000000" *) 
  (* C_SEL_WIDTH = "2" *) 
  (* C_TEST_CORE = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  xbip_dsp48_macro_0_xbip_dsp48_macro_v3_0_17_viv i_synth
       (.A(A),
        .ACIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .ACOUT(NLW_i_synth_ACOUT_UNCONNECTED[29:0]),
        .B(B),
        .BCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .BCOUT(NLW_i_synth_BCOUT_UNCONNECTED[17:0]),
        .C(C),
        .CARRYCASCIN(1'b0),
        .CARRYCASCOUT(NLW_i_synth_CARRYCASCOUT_UNCONNECTED),
        .CARRYIN(1'b0),
        .CARRYOUT(NLW_i_synth_CARRYOUT_UNCONNECTED),
        .CE(1'b0),
        .CEA(1'b0),
        .CEA1(1'b0),
        .CEA2(1'b0),
        .CEA3(1'b0),
        .CEA4(1'b0),
        .CEB(1'b0),
        .CEB1(1'b0),
        .CEB2(1'b0),
        .CEB3(1'b0),
        .CEB4(1'b0),
        .CEC(1'b0),
        .CEC1(1'b0),
        .CEC2(1'b0),
        .CEC3(1'b0),
        .CEC4(1'b0),
        .CEC5(1'b0),
        .CECONCAT(1'b0),
        .CECONCAT3(1'b0),
        .CECONCAT4(1'b0),
        .CECONCAT5(1'b0),
        .CED(1'b0),
        .CED1(1'b0),
        .CED2(1'b0),
        .CED3(1'b0),
        .CEM(1'b0),
        .CEP(1'b0),
        .CESEL(1'b0),
        .CESEL1(1'b0),
        .CESEL2(1'b0),
        .CESEL3(1'b0),
        .CESEL4(1'b0),
        .CESEL5(1'b0),
        .CLK(1'b1),
        .CONCAT({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .D({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .P(P),
        .PCIN({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .PCOUT(NLW_i_synth_PCOUT_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .SCLRA(1'b0),
        .SCLRB(1'b0),
        .SCLRC(1'b0),
        .SCLRCONCAT(1'b0),
        .SCLRD(1'b0),
        .SCLRM(1'b0),
        .SCLRP(1'b0),
        .SCLRSEL(1'b0),
        .SEL(SEL));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
A6Gm/t9CORdy7TJLqFUqsr6HqLU4CrdMZh8iCIZNonsJwqgaySthej1JPs0KNkLWfbMwXDxTNHKS
feuo2pfc8Q==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
DePAE6b0MAWn2lnMMooeQwVQqJbgLk0BhfejC+13rd/5gdjNzKPr4sTWr1XmDVZiWlH8L3ND2u+2
852UFZzpRygs159WD5jhawuTogtgc0BAaoAz86N6wCodZmNoKPQWhp56S6dbNlp8a4pkTJMbqhUb
YC+LR/dXFVFkYOnnNsY=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gI3isD6zIlc8GPtLeT+WJYz9/3N79hI8O3zkT1q3aZhWKdVcWGfdg9YipMbvsag1m6D7nyDcxcjq
HBTbjv7ICq9Wa1uIxT6xIrH54P0zqLS9FUT7Ct1hegzk8yTgyDDvLPKoTTdAJ0CS+LnlRYghdBNU
tjxZ5Oo3taYCehJIfUHxG7F2+zey7tYmGvQBvw6zvq6zgR5PbKomwXPVF5poUbUi3uDGuQ9YZeqM
A60ZGqti4OisRjpxZjfIwDnN6fjLwGNgmXnSqj2Tq+bvoDC23L5G7INQkdP0tH49VvNxYGm2nfYy
u4w/LRrTV/mwjpXNy6RTh1VP/xGEz6i3MnUS8A==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VO6NGPHNGUXRsH/Xitso5iNPf9sVcfV84QnCLZhdeuGVojOyH5PP0VpiK8yIeEC6Cnjcqh0qp08E
N15a0zCE4a0X8a9R3rePTsCuoL28UkpnDOj7NukD+dlO2Pn7XjyJrQm501RrUN11KGdzr9uI6aiB
YMRXQSISq2JIhfYx/qgnqtFwAzn2OzcGO2dCrPeJOUOO6+B0HRYA1vMOrRn9ql7b96L/QJUuAq9T
6BKJiXyVg6DazMTn4WBXIsaBktPste+EVAy912e2zmRXjfFjk4N+I0gQxqkLmmfjKPPssyqsPdKZ
xUdEZEn8PDxBEr2kV99jlqThNTqBpSlY8JPJ8A==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
EWhj7H3+jNO/piTibTz5QZTo/Ru6kRWkqebTYPs1RSt2sWHJ7SzAJJIehQgBKktr+ykRXMxyUW4e
YkzMS14Bic8jCU3eBM6ZA1btQuPPEBggp/u+/fhCMoMNeDszEdZI6/VLdUJkOLIm0hPpriQlqjyV
B4/RSfblYMuvl03dvxwjosldsoP5/uZAs0LH0EDs0SVWaiAIFd9KQE8jKlwqYftWdQ7vV6OU5cXF
dEj8VIwAc+4/QEyylKrS2+tIHGOrwOlz2rhX94Uk5G05EtTBv4CfWjWORDThPwwEaJqH6PYpgUlI
duqtU0B7BLM0sXoAGQlzVcU+zvUScDVnSRBrhg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
b8lk17DNszbLmhJXP7O51stx3Hgb2sQkHDaCRtDhUp3rKIkGlNtR9naQhOb0WEZnH7b0sSq9k2JW
O2PFW1Mjqd14gJ2jiinZdcy+dNywOFQyJgNbedkLoOIg7iy/nYMmF+LtJkalk0Vi/3P0HkySvoGz
YBbLbt9mfy2r0TcrJwk=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YshRnKWka2f0wV4oNrUtUpOfMX6uSYAAlSe3YoHDIuA6xGjAESnYOVcIeFUSat0Y8lo6HxPPSKls
5Ot6F3XDzQwmb0fZKK1skCYmFSoI47O3Stn7ARxxv97dHAJg8vsusGStUGRB0n+QynDrzMvgVvaq
sgk6JcsY6H/pqpknHyXSIXxBZV8P+9NCuVC3NUhr/uCYFDWtaE3T6Uy1WK28PK9ZB3p8fDwGHCmy
JVEMBN4mOaFyNM2pBAbdMsFxE4ahd8yfLwrQJkVZEwvh3pTeMbr3v60m1vC2Pyr26c1EgIB7aQac
z3jtJQVCQFFR08cwO8FNjm8u0Gz3twIShZBwzg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
oGVOk5Lf143U8wiv/Dvht3eNqAjpL9DdlvBclduKCSrowAwT5bR3KPXN7ujBV8nBTx7HgO8kUy/+
sf+O8J4Gz48WgwKzbPthw328SdNef1Z5JTwtrtyFI77sdUFn+jQtRT49nBgUwMms9wwUCNGiIwiK
RAIPbjocLrO5jie4J/YauYJDhYwkCpZqftAqIOWKXAYzw5jiC4hQwJ9slsPWjs3qIaTBTtSw305Q
FgIc9AT2yPwDYEtJQYxXxk9O5yrUjbIPD9J2QP4fiiE30MFBFwDb4mrL3frj76caBY95tSxPKb0I
PVb+gTwzOvsIb++NibKwMLpLnq78/uMiQ+fCDw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
4nZQAP79f2YTJ85+Nx7N7jIWr6dv6cpe7VrEJY7EbCZbUVi7/wlt5tO/VjNOEaDjDYc2xu3L5+PW
ejWgxk9UXKv+MJQVvCzmyNexAOi2nDB9zEvT7voqXQyfmNZ0daqfHwj81BVVrnz39BE26+sP/O/P
6ayicLkYc99b/znGaP50/dlRzRfzbjXVOvSVZC7kdVwR+y7I/LH7agXmh9O5SeCK93Wj8ibFASS6
/mgyC6ycwKsMT8ZqCRcZnHLELbWWNg5gblGsI6D1dOUs1QkAcwnq6X+9vYGcdUgjWEtRtRIjxXUL
cv9kqWE61gz9OJ+VfpCC9LSu+3sJsDsxyI6Bmw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 18416)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
