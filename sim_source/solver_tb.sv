`timescale 1ns / 1ps



module solver_tb;

logic clk;
logic reset;
logic valid;
logic signed [15:0] r [0:3][0:4];
logic signed [15:0] x [0:3];
logic ready;

initial begin
    clk = 0;
    valid <= 0;
    for(int i =0; i < 4;i ++) begin
        for(int j=0;j < 4;j ++) begin
            //matrix[i][j] <= 16'b10101010_10101010;
            r[i][j] <= 0;

        end
    end
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
r[0][0] <= 16'b1110000001000001;
r[0][1] <= 16'b1110001001011100;
r[0][2] <= 16'b0000010101010000;
r[0][3] <= 16'b1111110011100100;
r[0][4] <= 16'b1111100100010101;
r[1][1] <= 16'b1110001001111000;
r[1][2] <= 16'b0001010011101110;
r[1][3] <= 16'b1111000000111100;
r[1][4] <= 16'b1111011010111000;
r[2][2] <= 16'b1110100011101101;
r[2][3] <= 16'b1110001100000110;
r[2][4] <= 16'b1111100010100000;
r[3][3] <= 16'b1110001010000100;
r[3][4] <= 16'b0000011111011111;


valid <= 1;



#10;
reset <= 1;
#10;
reset <= 0;
end

solve_r dut(
    .clk_100mhz(clk),
    .reset(reset),
    .valid(valid),
    .r(r),
    .x(x),
    .ready(ready)

);
    
endmodule