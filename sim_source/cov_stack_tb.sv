`timescale 1ns / 1ps



module cov_stack_tb;

logic clk;
logic reset;
logic signed [15:0] old_p [0:3];
logic signed [15:0] new_p [0:3];
logic signed [15:0] returns [0:3];
logic valid;
logic ready;

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
old_p <= '{100,200,300,400};
new_p <= '{110,210,310,410};


#10;
reset <= 1;
#10;
reset <= 0;
valid <= 1;
end

vector_division dut(
    .clk_100mhz(clk),
    .reset(reset),
    .valid(valid),
    .a(old_p),
    .b(new_p),
    .sel(1),
    .c(returns),
    .ready(ready)
);




endmodule