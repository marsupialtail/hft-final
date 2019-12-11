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


module cordic_tb;

logic clk;
logic signed [15:0] x;
logic signed [15:0] y;
logic [31:0] tdata;
logic tvalid;
logic [15:0] tphase;
logic [15:0] toutphase;
logic [31:0] tout;
logic signed [15:0] out_x;
logic signed [15:0] out_y;
logic ovalid;
logic o2valid;

assign tdata = {y,x};
assign out_x = tout[15:0] * 2;
assign out_y = tout[31:16] * 2;

initial begin
    clk = 0;
    x = 0;
    y = 0;
    tvalid = 0;
    tphase = 16'b0;
end

always #5 clk = ~clk;

initial begin
#10;
x <= $signed(16'b10101010_10101010) / 2;
y <= $signed(16'b10101010_10101010) / 2;

//tphase <= 16'b1100_1101_1100_0000;
tvalid <= 1;
#40;
//tdata <= 31'b0011_0111_0000_0000_0001_0101_0000_0000;

end


cordic_1 dut1(.aclk(clk),
        .s_axis_cartesian_tdata(tdata),
        .s_axis_cartesian_tvalid(tvalid),
        .m_axis_dout_tdata(toutphase),
        .m_axis_dout_tvalid(ovalid)
);

cordic_0 dut
       (.aclk(clk),
        .s_axis_cartesian_tdata(tdata),
        .s_axis_cartesian_tvalid(tvalid),
        .s_axis_phase_tdata(-toutphase),
        .s_axis_phase_tvalid(ovalid),
        .m_axis_dout_tdata(tout),
        .m_axis_dout_tvalid(o2valid));


endmodule
