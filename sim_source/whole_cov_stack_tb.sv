`timescale 1ns / 1ps



module whole_cov_stack_tb;

logic clk;
logic signed [15:0] old_p [0:3];
logic signed [15:0] new_p [0:3];
logic signed [15:0] old_moment [0:3][0:3];
logic signed [15:0] old_mean [0:3];
logic signed [15:0] T;
logic valid;
logic reset;

logic signed [15:0] new_moment [0:3][0:3];
logic signed [15:0] new_cov [0:3][0:3];
logic signed [15:0] new_mean [0:3];
logic ready;
logic overflow;

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

T = 4;
old_moment[0][0] = 0.717633319446991 * 2 **8;
old_moment[0][1] = -0.3271801943148872 * 2 **8;
old_moment[0][2] = 1.2591225269124793 * 2 **8;
old_moment[0][3] = 2.0170592305161157 * 2 **8;
old_moment[1][0] = -0.09913770989654722 * 2 **8;
old_moment[1][1] = -1.63709625087061 * 2 **8;
old_moment[1][2] = -0.8044388635382993 * 2 **8;
old_moment[1][3] = -0.9566742863157225 * 2 **8;
old_moment[2][0] = -0.4216799461581625 * 2 **8;
old_moment[2][1] = 0.14768393591531861 * 2 **8;
old_moment[2][2] = 0.8545624181086902 * 2 **8;
old_moment[2][3] = 1.109282700780922 * 2 **8;
old_moment[3][0] = 1.5796455149268127 * 2 **8;
old_moment[3][1] = -0.548569716852451 * 2 **8;
old_moment[3][2] = -0.9764926608813304 * 2 **8;
old_moment[3][3] = -0.2572141435781018 * 2 **8;
old_mean[0] = 1.6644986605004701 * 2 ** 8;
old_mean[1] = -1.6427649866878022 * 2 ** 8;
old_mean[2] = 0.9549394601902133 * 2 ** 8;
old_mean[3] = 0.9193770715921893 * 2 ** 8;
old_p[0] = 0.2520841042329205 * 2 ** 8;
old_p[1] = 0.8123208254212738 * 2 ** 8;
old_p[2] = -1.2657204021755537 * 2 ** 8;
old_p[3] = 0.4224730182155406 * 2 ** 8;
new_p[0] = 0.43472141966280337 * 2 ** 8;
new_p[1] = 0.2616644553595842 * 2 ** 8;
new_p[2] = -0.9928315393023806 * 2 ** 8;
new_p[3] = 0.6529689367705677 * 2 ** 8;


end


update_cov dut(
    .clk_100mhz(clk),
    .old_p(old_p),
    .new_p(new_p),
    .old_moment(old_moment),
    .old_mean(old_mean),
    .T(T),
    .valid,
    .reset,
    
    .new_moment(new_moment),
    .new_cov(new_cov),
    .new_mean(new_mean),
    .ready,
    .overflow
    
);



endmodule