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


module exp_top_tb;
    logic clk, btnc,btnd,btnu,b,g;
    logic [15:0]sw;

 test_integration dut(
 .sys_clk(clk),
 .sw(sw),
 .btnd(btnd)
    );

initial begin
    clk = 0;
    sw[0] = 0;
    sw[15] = 0;
    sw[3] = 0;
    btnd = 0;
end

always #5 clk = ~clk;

initial begin
#100000;
sw[0]=1;
sw[15]=1;
sw[3] = 1;
#100;
sw[0]=0;
sw[15]=0;
sw[3] = 0;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;
btnd = 1;
#1000;
btnd = 0;
#10000;


#100000;
end
endmodule