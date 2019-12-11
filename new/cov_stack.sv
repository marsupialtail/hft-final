`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2019 07:20:05 PM
// Design Name: 
// Module Name: cov_stack
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

// TODO: trading logic requires global reset every time you want to trade. 
// seems reasonable. 
`include "constants.sv"

module update_cov(
    input clk_100mhz,
    input signed [15:0] old_p [0:N-1],
    input signed [15:0] new_p [0:N-1],
    input signed [15:0] old_moment [0:N-1][0:N-1],
    input signed [15:0] old_mean [0:N-1],
    input signed [15:0] T,
    input valid,
    input reset,
    
    output logic signed [15:0] new_moment [0:N-1][0:N-1],
    output logic signed [15:0] new_cov [0:N-1][0:N-1],
    output logic signed [15:0] new_mean [0:N-1],
    output logic ready,
    output logic overflow
    
);

    logic signed [15:0] dsp_0_a [0:N-1];
    logic signed [15:0] dsp_0_b [0:N-1];
    logic signed [15:0] dsp_0_c [0:N-1][0:N-1];
    logic signed [15:0] dsp_0_d;
    logic signed [15:0] dsp_0_e [0:N-1][0:N-1];
    logic signed [15:0] dsp_0_p2 [0:N-1][0:N-1];
    logic dsp_0_valid;
    logic [2:0] dsp_0_sel;
    logic dsp_0_overflow;
    logic dsp_0_ready;
    logic dsp_0_reset;
    
    logic signed [15:0] dsp_1_a [0:N-1];
    logic signed [15:0] dsp_1_b [0:N-1];
    logic signed [15:0] dsp_1_c [0:N-1][0:N-1];
    logic signed [15:0] dsp_1_d;
    logic signed [15:0] dsp_1_e [0:N-1][0:N-1];
    logic signed [15:0] dsp_1_p2 [0:N-1][0:N-1];
    logic dsp_1_valid;
    logic [2:0] dsp_1_sel;
    logic dsp_1_overflow;
    logic dsp_1_ready;
    logic dsp_1_reset;
    
    logic signed [15:0] dsp_2_a [0:N-1];
    logic signed [15:0] dsp_2_b [0:N-1];
    logic signed [15:0] dsp_2_d;
    logic signed [15:0] dsp_2_p1 [0:N-1];
    logic dsp_2_valid;
    logic dsp_2_overflow;
    logic dsp_2_ready;
    logic dsp_2_reset;

    logic signed [15:0] vec_div_a [0:N-1];
    logic signed [15:0] vec_div_b [0:N-1];
    logic signed [15:0] vec_div_f;
    logic signed [15:0] vec_div_p1 [0:N-1];

    logic vec_div_reset;
    logic vec_div_valid;
    logic [2:0] vec_div_sel;
    logic vec_div_ready;
    logic vec_div_scale;
    
    logic signed [15:0] sca_dividend;
    logic signed [15:0] sca_divisor;    
    logic signed [31:0] sca_div_p0;
    logic signed [15:0] sca_div_p0_clean;
    
    assign sca_div_p0_clean = treat_divider(sca_div_p0);
    
    logic sca_div_reset;
    logic sca_div_valid;
    logic sca_div_ready;
    logic [3:0] sca_div_tuser_in;
    logic [3:0] sca_div_tuser_out;

    logic signed [15:0] temp_scalar;
    logic signed [15:0] temp_vector [0:N-1];
    logic signed [15:0] returns [0:N-1];

    logic signed [15:0] temp_matrix_0 [0:N-1][0:N-1];
    logic signed [15:0] temp_matrix_1 [0:N-1][0:N-1];


    real_matrix_dsp dsp_0 (

    .clk_100mhz(clk_100mhz),
    .a(dsp_0_a), .b(dsp_0_b), .c(dsp_0_c), .d(dsp_0_d), .e(dsp_0_e),
    .reset(dsp_0_reset),.valid(dsp_0_valid),
    .sel(dsp_0_sel),
    .p2(dsp_0_p2),
    .overflow(dsp_0_overflow),
    .ready(dsp_0_ready)

    );
    
    real_matrix_dsp dsp_1 (

    .clk_100mhz(clk_100mhz),
    .a(dsp_1_a), .b(dsp_1_b), .c(dsp_1_c), .d(dsp_1_d), .e(dsp_1_e),
    .reset(dsp_1_reset),.valid(dsp_1_valid),
    .sel(dsp_1_sel),
    .p2(dsp_1_p2),
    .overflow(dsp_1_overflow),
    .ready(dsp_1_ready)

    );
    
    vector_dsp dsp_2_(

    .clk_100mhz(clk_100mhz),
    .a(dsp_2_a), .b(dsp_2_b), .d(dsp_2_d), 
    .reset(dsp_2_reset),.valid(dsp_2_valid),
    .p1(dsp_2_p1),
    .overflow(dsp_2_overflow),
    .ready(dsp_2_ready)

    );
    
    vector_division vec_divider(
    .clk_100mhz(clk_100mhz),
    .reset(vec_div_reset),
    .valid(vec_div_valid),
    .a(vec_div_a),
    .b(vec_div_b),
    .f(vec_div_f),
    .scale(vec_div_scale),
    .sel(vec_div_sel),
    .d(vec_div_p1),
    .ready(vec_div_ready)
    );
    
    div_gen_0 divider(
    .aclk(clk_100mhz),
    .s_axis_dividend_tvalid(sca_div_valid),
    .s_axis_dividend_tdata(sca_dividend),
    .s_axis_dividend_tuser(sca_div_tuser_in),
    .s_axis_divisor_tvalid(sca_div_valid),
    .s_axis_divisor_tdata(sca_divisor),
    .m_axis_dout_tdata(sca_div_p0),
    .m_axis_dout_tvalid(sca_div_ready),
    .m_axis_dout_tuser(sca_div_tuser_out)
    );

    logic signed [4:0] stage;
    always_ff @(posedge clk_100mhz) begin
        if(reset) begin
            stage <= -1;
            dsp_0_reset <= 1;
            dsp_1_reset <= 1;
            vec_div_reset <= 1;
            ready <= 0;
            overflow <= 0;
            
        end else if (valid == 1) begin
            if(stage == -1) begin
            
                if(T == 0) begin
                    new_moment <= '{default:0};
                    new_cov <= '{default:0};
                    new_mean <= '{default:0};
                    ready <= 1;
                    overflow <= 0;
                end else begin
                    vec_div_reset <= 0;
                    dsp_0_reset <= 0;
                    dsp_1_reset <= 0;
                    vec_div_sel <= 1;
                    vec_div_scale <= 1;
                    vec_div_valid <= 1;
                    
                    vec_div_a <= new_p;
                    vec_div_b <= old_p;
                    stage <= 0;
                end
            end else if (stage == 0) begin
                if(vec_div_ready == 1) begin
                    returns <= vec_div_p1;
                    vec_div_reset <= 1;
                    stage <= 1;
                end
            end else if (stage == 1) begin
                vec_div_reset <= 0;
                vec_div_a <= returns;
                vec_div_f <= (T + 1) ;
                vec_div_valid <= 1;
                vec_div_sel <= 0;
                vec_div_scale <= 0;
                
                sca_dividend <= T;
                sca_divisor <= T+1; // no need to scale both of these up
                sca_div_valid <= 1;
                
                
                stage <= 2;
            end else if (stage == 2) begin
                if(vec_div_ready && sca_div_ready) begin
                    temp_vector <= vec_div_p1;
                    temp_scalar <= sca_div_p0_clean;
                    dsp_0_reset <= 1;
                    dsp_1_reset <= 1;
                    dsp_2_reset <= 1;
                    // no need to reset the scalar divider since we only use it once
                    // we have two different protoocls going on here:
                    // one is axi and the other is reset. gotta think about this more
                    
                    stage <= 3;
                 end
            end else if (stage == 3) begin
                dsp_0_reset <= 0;
                dsp_1_reset <= 0;
                dsp_2_reset <= 0;
                
                // b * a^T
                dsp_0_a <= returns;
                dsp_0_b <= temp_vector;
                dsp_0_valid <= 1;
                dsp_0_sel <= 0; //outer product
                
                // c * d
                dsp_1_c <= old_moment;
                dsp_1_d <= temp_scalar;
                dsp_1_sel <= 1;
                dsp_1_valid <= 1;
                
                // a* d + b
                dsp_2_a <= old_mean;
                dsp_2_d <= temp_scalar;
                dsp_2_b <= temp_vector;
                dsp_2_valid <= 1;
            
                stage <= 4;
            end else if (stage == 4) begin
                if(dsp_0_overflow || dsp_1_overflow || dsp_2_overflow) begin
                    ready <= 1;
                    overflow <= 1;
                    stage <= 9;
                end if(dsp_0_ready && dsp_1_ready && dsp_2_ready) begin
                    temp_vector <= dsp_2_p1;
                    new_mean <= dsp_2_p1;
                    temp_matrix_0 <= dsp_0_p2;
                    temp_matrix_1 <= dsp_1_p2;
                    dsp_0_reset <= 1;
                    dsp_1_reset <= 1;
                    stage <= 5;
                end
            
            end else if (stage == 5) begin
                dsp_0_reset <= 0;
                dsp_1_reset <= 0;
                dsp_0_valid <= 1;
                dsp_1_valid <= 1;
                dsp_0_a <= temp_vector;
                dsp_0_b <= temp_vector;
                dsp_0_sel <= 0;
                
                dsp_1_c <= temp_matrix_0;
                dsp_1_e <= temp_matrix_1;
                dsp_1_sel <= 2;
                stage <= 6;
                
            end else if (stage == 6) begin
                if(dsp_0_overflow || dsp_1_overflow) begin
                    ready <= 1;
                    overflow <= 1;
                    stage <= 9;
                end else if(dsp_0_ready && dsp_1_ready) begin
                    temp_matrix_0 <= dsp_0_p2;
                    temp_matrix_1 <= dsp_1_p2;
                    new_moment <= dsp_1_p2;
                    dsp_0_reset <= 1;
                    stage <= 7;
                end
            
            end else if (stage == 7) begin
            
                dsp_0_reset <= 0;
                dsp_0_valid <= 1;
                dsp_0_sel <= 3;
                dsp_0_c <= temp_matrix_1;
                dsp_0_e <= temp_matrix_0;
                stage <= 8;
            
            end else if (stage == 8) begin
                if(dsp_0_overflow) begin
                    ready <= 1;
                    overflow <= 1;
                    stage <= 9;
                end else if(dsp_0_ready) begin
                    new_cov <= dsp_0_p2;
                    ready <= 1;
                    overflow <= 0;
                    stage <= 9;
                end
            
            end
        end
    end

endmodule


module vector_dsp(

    input clk_100mhz,
    input signed [15:0] a [0:N-1],
    input signed [15:0] b [0:N-1],
    input signed [15:0] d,
    input reset,
    input valid,
    output logic signed [15:0] p1 [0:N-1],
    output logic overflow,
    output logic ready

);

    always_ff @(posedge clk_100mhz) begin // vector multiply add d * a + b
       
        if(reset) begin
            ready <= 0;
            overflow <= 0;
            p1 <= '{default:0};
        end else if (valid == 1) begin
            for(int i = 0; i < N; i ++) begin
                p1[i] <= d * a[i] / $signed(2**14) + b[i];
                overflow <= mult_overflow(d,a[i]) || add_overflow(d*a[i] / $signed(2**14),b[i]);
                ready <= 1;
            end
        end
    end

endmodule

function automatic dsp_mult_overflow;
    input signed [32:0] c;
    if(c > $signed(2**30-1) || c < $signed(-(2**30))) begin
        $display("Multiplication Result: %b",c);
        $display("Range: %b",$signed(2**30-1) );
        dsp_mult_overflow = 1;
    end else begin
        dsp_mult_overflow = 0;
    end
endfunction

function automatic dsp_add_overflow;
    input signed [32:0] c;
    if(c > $signed(2**16-1) || c < $signed(-(2**16))) begin
        $display("Addition Result: %b",c);
        $display("Range: %b",$signed(2**16-1) );
        dsp_add_overflow = 1;
    end else begin
        dsp_add_overflow = 0;
    end
endfunction

module real_matrix_dsp(

    input clk_100mhz,
    input signed [15:0] a [0:N-1],
    input signed [15:0] b [0:N-1],
    input signed [15:0] c [0:N-1][0:N-1],
    input signed [15:0] d,
    input signed [15:0] e [0:N-1][0:N-1],
    input reset,
    input valid,
    input [2:0] tuser_in,
    input [2:0] sel,
    output logic signed [15:0] p2 [0:N-1][0:N-1],
    output logic overflow,
    output logic ready,
    output logic [2:0] tuser_out

);

    
    logic [1:0] dsp_sels [0:N-1][0:N-1];
    logic signed [15:0] dsp_a [0:N-1][0:N-1];
    logic signed [15:0] dsp_b [0:N-1][0:N-1];
    logic signed [15:0] dsp_c [0:N-1][0:N-1];
    logic signed [32:0] dsp_p [0:N-1][0:N-1];
    logic [0:N-1][0:N-1] mult_overflow ;
    logic [0:N-1][0:N-1] add_overflow ;
    
    wire any_mult_overflow;
    wire any_add_overflow; // also detects subtraction as well.
    // we register all the inputs and outputs of the DSP grid
    // as such we turn off all internal pipelining
    // how high are we going to crank the clock anyways on this -3 sg chip
    logic [1:0] state;

    genvar i,j;
    generate 
        for(i = 0; i < N; i ++) begin
            for(j = 0; j < N; j++) begin
                xbip_dsp48_macro_0 dut(
                    .A(dsp_a[i][j]),
                    .B(dsp_b[i][j]),
                    .C(dsp_c[i][j]),
                    .P(dsp_p[i][j]),
                    .SEL(dsp_sels[i][j])
                );
                // need to do this stuff because I (and Joe) can't find the overflow port
                // on the DSP wizard lol
                assign mult_overflow[i][j] = dsp_mult_overflow(dsp_p[i][j]);
                assign add_overflow[i][j] = dsp_add_overflow(dsp_p[i][j]);
                
            end
        end
            
    endgenerate

    
    assign any_mult_overflow = |mult_overflow;
    assign any_add_overflow = |add_overflow;
    

    always_ff @(posedge clk_100mhz) begin
    
        if(reset) begin
            ready <= 0;
            overflow <= 0;
            state <= 0;
            p2 <= '{default:0};
        end else begin
            if(state == 0) begin
                if(valid == 1) begin
                    case(sel)
                    0: begin // vector outer product a[i] * b[j]
                        for(int i = 0; i < N; i++) begin
                            for(int j = 0; j < N; j ++) begin
                                dsp_a[i][j] <= a[i];
                                dsp_b[i][j] <= b[j];
                                dsp_sels[i][j] <= 0;
                                // who produced our results here
                            end
                        end
                    end
                    1: begin // matrix element wise multiplication by scalar
                        for(int i = 0; i < N; i++) begin
                            for(int j = 0; j < N; j ++) begin
                                dsp_a[i][j] <= c[i][j];
                                dsp_b[i][j] <= d;
                                dsp_sels[i][j] <= 0;
                            end
                        end
                    end
                    2: begin // matrix element wise addition
                        for(int i = 0; i < N; i++) begin
                            for(int j = 0; j < N; j ++) begin
                                dsp_a[i][j] <= c[i][j];
                                dsp_c[i][j] <= e[i][j];
                                dsp_sels[i][j] <= 1;
                            end
                        end
                    end
                    3: begin // matrix element wise subtraction
                        for(int i = 0; i < N; i++) begin
                            for(int j = 0; j < N; j ++) begin
                                dsp_a[i][j] <= c[i][j];
                                dsp_c[i][j] <= e[i][j];
                                dsp_sels[i][j] <= 2;
                            end
                        end
                    end
                    
                    default: begin
                        overflow <= 1;
                        ready <= 0;
                    end
                    endcase
                    state <= 1;
                end
            
            end else if (state == 1) begin
                case(sel)
                    0: begin // vector outer product a[i] * b[j]
                        overflow <= any_mult_overflow;
                        for(int i = 0; i < N; i ++) begin
                            for(int j =0; j < N; j++) begin
                                p2[i][j] <= dsp_p[i][j] / $signed(2**14);
                            end
                        end

                    end
                    1: begin // matrix element wise multiplication by scalar
                        overflow <= any_mult_overflow;
                        for(int i = 0; i < N; i ++) begin
                            for(int j =0; j < N; j++) begin
                                p2[i][j] <= dsp_p[i][j] / $signed(2**14);
                            end
                        end

                    end
                    2: begin // matrix element wise addition
                        overflow <= any_add_overflow;
                        for(int i = 0; i < N; i ++) begin
                            for(int j =0; j < N; j++) begin
                                p2[i][j] <= dsp_p[i][j];
                            end
                        end
                    end
                    3: begin // matrix element wise subtraction
                        overflow <= any_add_overflow;
                        for(int i = 0; i < N; i ++) begin
                            for(int j =0; j < N; j++) begin
                                p2[i][j] <= dsp_p[i][j];
                            end
                        end
                    end
                    
                    default: begin
                        overflow <= 1;
                        ready <= 0;
                    end
                endcase
                ready <= 1;
                state <= 2; //need to be reset before accepting new computation. 
            end
            
       end
    
    end

endmodule

module matrix_dsp(

    input clk_100mhz,
    input signed [15:0] a [0:N-1],
    input signed [15:0] b [0:N-1],
    input signed [15:0] c [0:N-1][0:N-1],
    input signed [15:0] d,
    input signed [15:0] e [0:N-1][0:N-1],
    input reset,
    input valid,
    input [2:0] tuser_in,
    input [2:0] sel,
    output logic signed [15:0] p2 [0:N-1][0:N-1],
    output logic overflow,
    output logic ready,
    output logic [2:0] tuser_out

);


    // to be replaced by genvar of DSP array if required
    always_ff @(posedge clk_100mhz) begin
    
        if(reset) begin
            ready <= 0;
            overflow <= 0;
            p2 <= '{default:0};
        end else if (valid == 1) begin
            case(sel)
                0: begin // vector outer product a[i] * b[j]
                    for(int i = 0; i < N; i++) begin
                        for(int j = 0; j < N; j ++) begin
                            p2[i][j] <= a[i] * b[j] / $signed(2**14);
                            
                            // VERY DANGEROUS logic, just for simulation. 
                            
                            overflow <= mult_overflow(a[i],b[j]);
                            ready <= 1;
                            tuser_out <= tuser_in; // no need to keep track of
                            // who produced our results here
                        end
                    end
                end
                1: begin // matrix element wise multiplication by scalar
                    for(int i = 0; i < N; i++) begin
                        for(int j = 0; j < N; j ++) begin
                            p2[i][j] <= c[i][j] * d / $signed(2**14);
                            overflow <= mult_overflow(c[i][j], d);
                            ready <= 1;
                            tuser_out <= tuser_in;
                        end
                    end
                end
                2: begin // matrix element wise addition
                    for(int i = 0; i < N; i++) begin
                        for(int j = 0; j < N; j ++) begin
                            p2[i][j] <= c[i][j] + e[i][j];
                            overflow <= add_overflow(c[i][j], e[i][j]);
                            ready <= 1;
                            tuser_out <= tuser_in;
                        end
                    end
                end
                3: begin // matrix element wise subtraction
                    for(int i = 0; i < N; i++) begin
                        for(int j = 0; j < N; j ++) begin
                            p2[i][j] <= c[i][j] - e[i][j];
                            overflow <= add_overflow(c[i][j], -e[i][j]);
                            ready <= 1;
                            tuser_out <= tuser_in;
                        end
                    end
                end
                
                default: begin
                    overflow <= 1;
                    ready <= 0;
                end
            endcase
       end
    
    end

endmodule


module vector_division(
    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] a [0:N-1],
    input signed [15:0] b [0:N-1],
    input signed [15:0] f,
    input scale,
    input [2:0] sel,
    input [2:0] vec_tuser_in,
    output logic signed [15:0] d [0:N-1],
    output logic ready,
    output logic [2:0] vec_tuser_out,
    output logic overflow
);

    logic signed [15:0] dividend;
    logic signed [15:0] divisor;
    logic signed [31:0] c; 
    
    logic dividend_valid;
    logic divisor_valid;
    logic result_valid;
    logic [LOGN+1:0] tuser_in;
    logic [LOGN+1:0] tuser_out;

    
    div_gen_0 divider(
    .aclk(clk_100mhz),
    .s_axis_dividend_tvalid(dividend_valid),
    .s_axis_dividend_tdata(dividend),
    .s_axis_dividend_tuser(tuser_in),
    .s_axis_divisor_tvalid(divisor_valid),
    .s_axis_divisor_tdata(divisor),
    .m_axis_dout_tdata(c),
    .m_axis_dout_tvalid(result_valid),
    .m_axis_dout_tuser(tuser_out)
    );
    
    logic state;
    logic [LOGN+1:0] processing;
    logic [LOGN+1:0] getting;
    

    logic signed [15:0] result;
    logic signed [30:0] long_result;
    
    assign long_result = $signed(c[30:15]) * $signed(2**14) + $signed(c[14:0]);
    
    always_comb begin
        if(scale == 1) begin
//            if($signed(long_result[29:14]) > 1) begin
//                result = {$signed(1),14'b0};
//            end else if ($signed(long_result[29:14]) < -2) begin
//                result = {$signed(-2),14'b0};
//            end else begin
//                result = $signed(long_result[15:0]);
//            end
            result = $signed(long_result[15:0]);

        end else begin
            result = $signed(long_result[29:14]);
        end
    end

    
    always_ff @(posedge clk_100mhz) begin
        
        if(reset==1) begin
            dividend <= 0;
            divisor <= 0;
            tuser_in <= 0;
            state <= 0;
            processing <= 0;
            getting <= 0;
            ready <= 0;
            overflow <= 0;
            dividend_valid <= 0;
            divisor_valid <= 0;
        end else if (valid==1) begin
            if(state == 0) begin
                state <= 1;
                
                case(sel) 
                    0: begin
                        dividend <= a[processing];
                        divisor <= f;
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                    1: begin
                        dividend <= a[processing] - b[processing];
                        divisor <= b[processing];
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                    2: begin
                        dividend <= a[processing];
                        divisor <= b[processing];
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                endcase
                // tuser_in is 1 indexed. This so we not confuse 0, which is default with 0 index.
                tuser_in <= processing + 1;
                processing <= processing + 1;
            end else if (state == 1) begin
                if(processing < N) begin
                    case(sel) 
                    0: begin
                        dividend <= a[processing];
                        divisor <= f;
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                    1: begin
                        dividend <= a[processing] - b[processing];
                        divisor <= b[processing];
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                    2: begin
                        dividend <= a[processing];
                        divisor <= b[processing];
                        
                        dividend_valid <= 1;
                        divisor_valid <= 1;
                    end
                endcase
                    tuser_in <= processing + 1;
                    processing <= processing + 1;
                end
                if(tuser_out == getting + 1) begin
                    d[getting] <= result;
                    if(result == {$signed(1),14'b0} || result == {$signed(-2),14'b0}) begin
                        overflow <= 1;
                    end
                    if(getting == N-1) begin
                        state <= 2;
                        ready <= 1;
                    end else begin
                        getting <= getting + 1;
                    end
                end
                
            end else if (state == 2) begin
                ready <= 1;
                dividend_valid <= 0;
                divisor_valid <= 0;
            end
        end
    end    

endmodule

