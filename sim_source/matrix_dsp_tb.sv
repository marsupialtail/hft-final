`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 11:26:13 AM
// Design Name: 
// Module Name: cordic_tb
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

module matrix_dsp_tb;

logic clk;
logic signed [15:0] a [0:3];
logic signed [15:0] b [0:3];
logic signed [15:0] c [0:3][0:3];
logic signed [15:0] d;
logic signed [15:0] e [0:3][0:3];

logic signed [15:0] p2 [0:3][0:3];
logic [2:0] sel;
logic ready;
logic valid;
logic reset;
logic overflow;

initial begin
    clk = 0;
    a = '{0,0,0,0};
    b = '{0,0,0,0};
    sel = 0;
end

always #5 clk = ~clk;

initial begin
reset = 1;
#10;
a <= '{10 * $signed(2**8) ,10 * $signed(2**8),10 * $signed(2**8),10 * $signed(2**8)};
b <= '{10 * $signed(2**8), 10 * $signed(2**8),10 * $signed(2**8),10 * $signed(2**8)};
//c <= 10 * $signed(2**8);
valid <= 1;
reset <= 0;
sel <= 0;
//tphase <= 16'b1100_1101_1100_0000;
#10;
//tdata <= 31'b0011_0111_0000_0000_0001_0101_0000_0000;
//result <= p / $signed(2**8);


end


real_matrix_dsp dut(

    .clk_100mhz(clk),
    .a(a), .b(b), .c(c), .d(d), .e(e),
    .reset(reset), .valid(valid),
    .sel(sel),
    .p2(p2),
    .overflow(overflow),
    .ready(ready)
);

 
endmodule