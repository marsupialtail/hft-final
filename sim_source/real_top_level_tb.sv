`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2019 12:05:40 PM
// Design Name: 
// Module Name: real_top_level_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module real_top_level_tb;
    logic clk, btnc,btnd,btnu,b,g;
    logic sw[15:0];

    top_level dut(
    .clk_100mhz(clk),
    .btnc(btnc),
    .btnd(btnd),
    .btnu(btnu),
    .sw(sw),
    //.ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
    //output[7:0] an,
    .led16_b(b),
    .led16_g(g)
);

initial begin
    clk = 0;
    btnc = 0;
    btnd = 0;
    btnu = 0;
end

always #5 clk = ~clk;

initial begin
#10;
sw[0]=1;
sw[15]=1;
#1000;
sw[0]=0;
sw[15] = 0;
btnu = 1;
#10;
btnu = 0;
#1000;
btnu = 0;
#100000;
btnu = 1;
#1000;
btnu = 0;
#100000;
btnu = 1;
#1000;
btnu = 0;
#100000;
btnu = 1;
#1000;
btnu = 0;
#100000;
btnu = 1;
#1000;
btnu = 0;
end

endmodule
