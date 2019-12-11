`timescale 1ns / 1ps



module linear_solver_tb;

logic clk;
logic reset;
logic [15:0] matrix [0:3][0:3];
logic [15:0] x [0:3];
logic ready;
logic valid;

initial begin
    clk = 0;
end

always #5 clk = ~clk;

initial begin
#10;
//for(int i =0; i < 4;i ++) begin
//    for(int j=0;j < 4;j ++) begin
//        //matrix[i][j] <= 16'b10101010_10101010;
//        matrix[i][j] <= 16'b00100000_00000000;

//    end
//end
matrix[0][0] <= 16'b1110000010000111;
matrix[0][1] <= 16'b0000010010101110;
matrix[0][2] <= 16'b1110011100110010;
matrix[0][3] <= 16'b0000111001010111;
matrix[1][0] <= 16'b0000100111111011;
matrix[1][1] <= 16'b0000001111010110;
matrix[1][2] <= 16'b0000110001010110;
matrix[1][3] <= 16'b0001000000001000;
matrix[2][0] <= 16'b0000001001101011;
matrix[2][1] <= 16'b0001111001000111;
matrix[2][2] <= 16'b1111111010110110;
matrix[2][3] <= 16'b0000101100111000;
matrix[3][0] <= 16'b0001000000101000;
matrix[3][1] <= 16'b0000011100010100;
matrix[3][2] <= 16'b1110001100001100;
matrix[3][3] <= 16'b0001101110010111;




#10;
reset <= 1;
#10;
reset <= 0;
valid <= 1;
end

linear_solver dut(
    .clk_100mhz(clk),
    .reset(reset),
    .valid(valid),
    .cov(matrix),
    .x(x),
    .ready(ready)
);




endmodule