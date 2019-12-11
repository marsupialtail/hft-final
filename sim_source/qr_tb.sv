`timescale 1ns / 1ps



module qr_tb;

logic clk;
logic reset;
logic [15:0] matrix [0:3][0:3];
logic [15:0] r [0:3][0:3];

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
matrix[0][0] <= 16'b0001000100001111;
matrix[0][1] <= 16'b1111100000001110;
matrix[0][2] <= 16'b0001000111100010;
matrix[0][3] <= 16'b1110101001001010;
matrix[1][0] <= 16'b0000110110000011;
matrix[1][1] <= 16'b1110110101101100;
matrix[1][2] <= 16'b1111110000111010;
matrix[1][3] <= 16'b1111111110001111;
matrix[2][0] <= 16'b1111000101110100;
matrix[2][1] <= 16'b1110001101100010;
matrix[2][2] <= 16'b0000110001000100;
matrix[2][3] <= 16'b0001100000011010;
matrix[3][0] <= 16'b0001100100011010;
matrix[3][1] <= 16'b1111001000000100;
matrix[3][2] <= 16'b1111101110001011;
matrix[3][3] <= 16'b0000011110011001;




#10;
reset <= 1;
#10;
reset <= 0;
end

qr dut(
.clk_100mhz(clk),
.reset(reset),
.matrix(matrix),
.r(r)
    );




endmodule