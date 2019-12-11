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


module dsp_tb;

logic clk;
logic signed [15:0] a;
logic signed [15:0] b;
logic signed [15:0] c;
logic signed [32:0] p;
logic signed [15:0] result;
logic [1:0] sel;
logic mult_overflow;
logic add_overflow;

initial begin
    clk = 0;
    a = 0;
    b = 0;
    c = 0;
    sel = 0;
end

always #5 clk = ~clk;

initial begin
#10;
a <= 10 * $signed(2**8);
b <= 10 * $signed(2**8);
c <= 10 * $signed(2**8);
sel = 1;
//tphase <= 16'b1100_1101_1100_0000;
#10;
//tdata <= 31'b0011_0111_0000_0000_0001_0101_0000_0000;
//result <= p / $signed(2**8);
result <= p ;

mult_overflow <= dsp_mult_overflow(p);
add_overflow <= dsp_add_overflow(p);
end


xbip_dsp48_macro_0 dut(
    .a(a),
    .b(b),
    .c(c),
    .p(p),
    .sel(sel)
);

 
endmodule