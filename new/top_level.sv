`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2019 11:23:18 AM
// Design Name: 
// Module Name: top_level
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

`include "constants.sv"

function automatic signed [15:0] treat_divider;
    input [31:0] c;
    logic signed [30:0] long_result;
    
    long_result = $signed(c[30:15]) * $signed(2**14) + $signed(c[14:0]);
    
    if($signed(long_result[29:14]) > 1) begin
        treat_divider = {$signed(1),14'b0};
    end else if ($signed(long_result[29:14]) < -2) begin
        treat_divider = {$signed(-2),14'b0};
    end else begin
        treat_divider = $signed(long_result[15:0]);
    end

endfunction

function automatic mult_overflow;
    input signed [15:0] a;
    input signed [15:0] b;
    logic signed [31:0] c = a * b;
    if(c > $signed(2**30-1) || c < $signed(-(2**30))) begin
//        $display("Multiplication Result: %b",c);
//        $display("Range: %b",$signed(2**30-1) );
        mult_overflow = 1;
    end else begin
        mult_overflow = 0;
    end
endfunction

function automatic add_overflow;
    input signed [15:0] a;
    input signed [15:0] b;
    logic signed [16:0] sum = a+b;
    if(sum > $signed(2**16-1) || sum < $signed(-(2**16))) begin
        $display("Addition Result: %b",sum);
        $display("Range: %b",$signed(2**16-1) );
        add_overflow = 1;
    end else begin
        add_overflow = 0;
    end
endfunction

module send_order(
    input clk_100mhz,
    input signed [15:0] positions [0:N-1],
    input signed [15:0] target [0:N-1],
    input signed [15:0] curr_price [0:N-1],
    input reset,
    input valid,
    output logic [0:18*N-1] bus,
    output logic done,
    output logic error
);

  parameter signed [15:0] account = 1024;
  
  logic signed [15:0] shares [0:N-1];
  
  logic signed [15:0] difference [0:N-1];
  logic div_start;
  logic div_ready;
  logic [2:0] state;
  
  logic [0:N] overflow;
  logic any_overflow;
  logic div_overflow;
  
  genvar i;
  generate
    for(i = 0 ; i < N; i ++) begin
        assign difference[i] = target[i] - positions[i];
        assign overflow[i] = mult_overflow(shares[i],account) || add_overflow(target[i],-positions[i]);
        assign bus[18*i:18*i+1] = (shares[i] > 0) ? 2'b01 : 2'b00;
        assign bus[18*i+2:18*i+17] = (shares[i] > 0) ? shares[i] * account / $signed(2**8): (-shares[i] * account)/$signed(2**8); // we can only trade integer shares! 
    end
  endgenerate
  
  assign any_overflow = (|overflow) || div_overflow;
  
  vector_division divider(
    .clk_100mhz(clk_100mhz),
    .reset(reset),
    .valid(div_start),
    .a(difference),
    .b(curr_price),
    .sel(2),
    .scale(1),
    .d(shares),
    .ready(div_ready),
    .overflow(div_overflow));
    
    
    always_ff@(posedge clk_100mhz) begin
        if(reset) begin
            state <= 0;
            div_start <= 0;
            error <= 0;
            done <= 0;
        end else begin
            if(state == 0) begin
                if(valid) begin
                    div_start <= 1;
                    state <= 1; 
                end
            end else if(state == 1) begin
                if(div_ready) begin
                    if(any_overflow) begin
                        error <= 1;
                        done <= 1;
                    end else begin
                        done <= 1;
                    end
                end
            end
        end
    end


endmodule




module get_price(
    input clk_100mhz,
    input reset,
    input signed [15:0] latest_price [0:N-1],
    input latest_price_valid,
    output logic signed [15:0] reg_latest_price [0:N-1],
    output logic new_price // this will be a pulse
);

    parameter DELAY = 100;
    
    logic [20:0] counter;
    always_ff @(posedge clk_100mhz) begin
        if(reset) begin
            counter <= DELAY-1;
            new_price <= 0;
            reg_latest_price <= '{default:0};
        end else begin
            if(counter == DELAY-1) begin
            
            // TODO: in production system, we need to remove the condition latest_price != reg_latest_price
            // this is to avoid simulation problems where the price is the same, driving covariance matrix to zero
            // in production, if the price is the same, then the covariance matrix should be zero!
            // then we will have a ton of overflows, but that's okay.
            
            
                if(latest_price != reg_latest_price && latest_price_valid) begin
                    reg_latest_price <= latest_price;
                    new_price <= 1;
                    counter <= 0;
                end else begin
                    counter <= 0;
                end
            end else begin
                counter <= counter + 1;
                new_price <= 0;
            end
        
        end
    
    end

endmodule

module debounce (input reset_in, clock_in, noisy_in,
                 output reg clean_out);

   reg [19:0] count;
   reg new_input;

   always_ff @(posedge clock_in)
     if (reset_in) begin 
        new_input <= noisy_in; 
        clean_out <= noisy_in; 
        count <= 0; end
     else if (noisy_in != new_input) begin new_input<=noisy_in; count <= 0; end
     else if (count == 60) clean_out <= new_input;
     else count <= count+1;


endmodule

module top_level_ip(
    input clk_100mhz,
    input [15:0] sw,
    input [STOCK_INDEX:0] stock_to_add,
    input book_entry entry, 
    input start,
    input [2:0] request,
    input [ORDER_INDEX:0] order_id, //should be supplied for a cancel / trade
    input delete, //should be one if cancel
    input [QUANTITY_INDEX:0] quantity,  // sho1uld be supplied for a trade
    
    output logic book_busy,
    output logic [SIZE_INDEX:0] size_of_stocks [0:NUM_STOCK_INDEX],
    output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
    output[7:0] an,
    output led16_b,
    output led16_g,
    output led16_r,
    output logic [71:0] bus,
    output logic done,
    output logic error
);
    logic done, error;
    assign led16_g = done;
    assign led16_r = error;
    logic signed [15:0] price [0:N-1];
    logic [5:0] counter;
    wire global_reset;
    wire new_p;
    logic new_p_r;
    logic [15:0] price_u[0:N-1];
    
    logic price_valid;

    logic signed [15:0] prices [0:8][0:N-1];
    
    genvar i;
    generate 
        for(i = 0; i < N; i++) begin
            assign price[i] = price_u[i];
        end
    endgenerate
        
       
    order_book_wrapper top_(                                      
    .clk_in(clk_100mhz),                                        
    .rst_in(sw[15]),                                          
    .stock_to_add(stock_to_add),                           
    .order_to_add(entry),                                  
    .start(start),                                         
    .request(request),                                     
    .order_id(order_id),                                   
    .delete(delete), //should be one if cancel             
    .quantity(quantity),                                   
    .is_busy(book_busy),
    .best_price_stocks(price_u),
    .best_prices_valid(price_valid),
    .size_of_stocks(size_of_stocks)
    );    

    assign global_reset = sw[0];
    
    logic signed [15:0] scaled_target [0:N-1];
    
    trading_top dut(
    .clk_100mhz(clk_100mhz),
    .latest_price(price),
    .latest_price_valid(price_valid),
    .global_reset(global_reset),
    .scaled_target(scaled_target),
    .bus(bus),
    .global_overflow(led16_b),
    .order_done(done),
    .order_error(error)
    );

    
//    serial_tx comm_unit(.clk_in(clk_100mhz),
//                    .rst_in(global_reset),
//                    .trigger_in(send_out_r && !send_out),
//                    .val_in(scaled_target[0][7:0]),
//                   .done(done),
//                    .data_out(ja[0]));
    
    wire [6:0] segments;
    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
    
    logic [31:0] display_bits;
    
    always_comb begin
        if(sw[14]) begin
            display_bits = {scaled_target[0],scaled_target[1]};
        end else if (sw[13]) begin
            display_bits = {scaled_target[2],scaled_target[3]};
        end else if (sw[12]) begin
            display_bits = {price[0],price[1]};
        end else if (sw[11]) begin
            display_bits = {price[2],price[3]};
        end else if (sw[10]) begin
            display_bits = bus[71:32];
        end else begin
            display_bits = bus[31:0];
        end
    end
    
    display_8hex display(.clk_in(clk_100mhz),.data_in(display_bits), .seg_out(segments), .strobe_out(an));
    
    always_ff@(posedge clk_100mhz) begin
        
        if(global_reset == 1) begin
            //new_p <= 0;
            new_p_r <= 0;
            //bus <= 0;
            counter <= 0;

        end else if(new_p == 1 && new_p_r == 0) begin
            counter <= counter + 1;
            new_p_r <= new_p;
        end else begin
            new_p_r <= new_p;

        end
        
//        if(new_p && !new_p_r) begin
//            counter <= counter + 1;
//            new_p_r <= new_p;
//        end else begin
//            new_p_r <= new_p;
//        end
    end
   
endmodule

module top_level_trade(
    input clk_100mhz,
    input sw[15:0],
    input btnc,
    input btnd,
    input btnu,
    output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
    output[7:0] an,
    output led16_b,
    output led16_g,
    output led16_r
//    output logic [71:0] bus,
//    output logic done,
//    output logic error
);
    logic done, error;
    assign led16_g = done;
    assign led16_r = error;
    logic[71:0] bus;
    logic signed [15:0] price [0:N-1];
    logic [5:0] counter;
    wire global_reset;
    wire new_p;
    logic new_p_r;
    logic [15:0] price_u[0:N-1];
    
    logic price_valid;

    logic signed [15:0] prices [0:8][0:N-1];
    
    genvar i;
    generate 
        for(i = 0; i < N; i++) begin
            assign price[i] = price_u[i];
        end
    endgenerate
    
    
    logic book_busy; 
    
       logic pick_next;                              
       debounce d1(.clock_in(clk_100mhz), .reset_in(sw[15]), .noisy_in(btnu), .clean_out(pick_next));  
       logic pick_next_previous; 
       logic change; 
       always_ff @(posedge clk_100mhz) begin
           pick_next_previous <= pick_next;
           change <= pick_next_previous == 0 && pick_next == 1; 
       end 
       
    top_level_simulation top_level_sim (.clk_in(clk_100mhz), 
    .next(change), 
    .reset(sw[15]),
     .busy(book_busy),
      .best_price_stocks (price_u),
     .stocks_valid(price_valid)); 
//    assign prices[0] = '{115.355298916*2**8,40.9465656921*2**8,34.4863845528*2**8,55.1660735136*2**8};
//    assign prices[1] = '{127.0*2**8,29.5824195882*2**8,37.7681143599*2**8,56.3017956783*2**8};   
//    assign prices[2] = '{127.0*2**8,33.1636790203*2**8,31.1068030893*2**8,59.575229658*2**8};
//    assign prices[3] = '{127.0*2**8,24.2162177991*2**8,16.112152735*2**8,50.4074439653*2**8};    
//    assign prices[4] = '{127.0*2**8,26.2766803139*2**8,14.9420497843*2**8,48.922379298*2**8};
//    assign prices[5] = '{121.714203685*2**8,32.1975154513*2**8,13.7534866892*2**8,44.4035407743*2**8};
//    assign prices[6] = '{107.831157802*2**8,33.5667962178*2**8,16.7753312399*2**8,47.6596497209*2**8};
//    assign prices[7] = '{104.862285374*2**8,36.329730527*2**8,16.6409127224*2**8,51.7086851658*2**8};
//    assign prices[8] = '{105.119810494*2**8,36.4632174103*2**8,11.8835222024*2**8,48.5692606977*2**8};
    
//    assign price = prices[counter];
    assign global_reset = sw[0];
    
    debounce db2(.reset_in(global_reset),.clock_in(clk_100mhz),.noisy_in(btnd),.clean_out(new_p));

    trading_top dut(
    .clk_100mhz(clk_100mhz),
    .latest_price(price),
    .latest_price_valid(price_valid),
    .global_reset(global_reset),
    .bus(bus),
    .global_overflow(led16_b),
    .order_done(done),
    .order_error(error)
    );
    
    wire [6:0] segments;
    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
    display_8hex display(.clk_in(clk_100mhz),.data_in(bus[31:0]), .seg_out(segments), .strobe_out(an));
    
    always_ff@(posedge clk_100mhz) begin
        
        if(global_reset == 1) begin
            //new_p <= 0;
            new_p_r <= 0;
            //bus <= 0;
            counter <= 0;

        end else if(new_p == 1 && new_p_r == 0) begin
            counter <= counter + 1;
            new_p_r <= new_p;
        end else begin
            new_p_r <= new_p;

        end
        
//        if(new_p && !new_p_r) begin
//            counter <= counter + 1;
//            new_p_r <= new_p;
//        end else begin
//            new_p_r <= new_p;
//        end
    end
   
endmodule

module trading_top(
    input clk_100mhz,
    input signed [15:0] latest_price [0:N-1],
    input latest_price_valid,
    input global_reset,
    output logic [71:0] bus,
    output logic  signed [15:0] scaled_target [0:N-1],
    output logic global_overflow,
    output logic order_done,
    output logic order_error
);

    logic new_price;
    
    logic curr_price_valid;
    logic signed [15:0] last_price [0:N-1];
    logic signed [15:0] curr_price [0:N-1];
    logic signed [15:0] old_moment [0:N-1][0:N-1];
    logic signed [15:0] old_mean [0:N-1];
    logic signed [15:0] T;
    
    logic signed [15:0] new_moment [0:N-1][0:N-1];
    logic signed [15:0] new_mean [0:N-1];
    logic signed [15:0] cov_matrix [0:N-1][0:N-1];
    logic update_cov_ready;
    logic update_cov_reset;
    logic update_cov_overflow;
   
    logic solver_valid;
    logic solver_reset;
    logic signed [15:0] unscaled_target [0:N-1];
    logic solver_ready;
    logic solver_overflow;
    
    logic normalize_ready;
    logic normalize_overflow;
    
    logic signed [15:0] positions [0:N-1];
    logic [3:0] stage;
    
    
    always_ff@(posedge clk_100mhz) begin
        if(global_reset) begin
            stage <= 0;
            update_cov_reset <= 1; // remember to do them at the end too
            solver_reset <= 1; //remember to do them at the end too
            curr_price_valid <= 0;
            old_moment <= '{default:0};
            old_mean <= '{default:0};
            last_price <= '{default:0};
            positions <= '{default:$signed(0.25) * $signed(2**8)};
            global_overflow <= 0;
            
            T <= 0;
            
        end else begin
            if(stage == 0) begin
                if(new_price) begin
                    stage <= 1;
                    curr_price_valid <= 1;
                    update_cov_reset <= 0;
                    global_overflow <= 0;
                end
            end else if (stage == 1) begin
                if(update_cov_overflow) begin
                    global_overflow <= 1;
                    stage <= 0;
                    update_cov_reset <= 1;

                end else if (update_cov_ready) begin
                    stage <= 2;
                    old_moment <= new_moment;
                    old_mean <= new_mean;
                    last_price <= curr_price;
                    T <= T+1;
                    update_cov_reset <= 1;
                    solver_reset <= 0;
                end

            end else if (stage == 2) begin
                if(solver_overflow) begin
                    global_overflow <= 1;
                    stage <= 0;
                    solver_reset <= 1;
                end else if (solver_ready) begin
                    stage <= 3;
                end
                
            end else if (stage == 3) begin
                if(normalize_overflow) begin
                    global_overflow <= 1;
                    stage <= 0;
                    solver_reset <= 1;

                end else if (normalize_ready) begin
                    stage <= 4;
                end
                    
            end else if (stage == 4) begin
                if(order_error) begin
                    global_overflow <= 1;
                    stage <= 0;
                    solver_reset <= 1;

                end else if (order_done) begin
                    positions <= scaled_target;
                    stage <= 0;
                    solver_reset <= 1;
                end
            end
        end
    end
    
    get_price my_pull_price(
    .clk_100mhz(clk_100mhz),
    .reset(global_reset),
    .latest_price(latest_price),
    .latest_price_valid(latest_price_valid),
    .reg_latest_price(curr_price),
    .new_price(new_price) // this will be a pulse
    );  
    
    update_cov my_update_cov(
    .clk_100mhz(clk_100mhz),
    .old_p(last_price),
    .new_p(curr_price),
    .old_moment(old_moment),
    .old_mean(old_mean),
    .T(T),
    .valid(curr_price_valid),
    .reset(update_cov_reset),
    
    .new_moment(new_moment),
    .new_cov(cov_matrix),
    .new_mean(new_mean),
    .ready(update_cov_ready),
    .overflow(update_cov_overflow)
    );

    linear_solver my_solver(
    .clk_100mhz(clk_100mhz),
    .reset(solver_reset),
    .valid(update_cov_ready && !update_cov_overflow),
    .cov(cov_matrix),
    .x(unscaled_target),
    .ready(solver_ready),
    .overflow(solver_overflow)
    );
    
    normalize_w my_normalize(
    .clk_100mhz(clk_100mhz),
    .reset(solver_reset),
    .valid(solver_ready && (!solver_overflow)),
    .x(unscaled_target),
    .w(scaled_target),
    .overflow(normalize_overflow),
    .ready(normalize_ready)
    );
    
    send_order my_sender(
    .clk_100mhz(clk_100mhz),
    .positions(positions),
    .target(scaled_target),
    .curr_price(curr_price),
    .reset(solver_reset),
    .valid(normalize_ready && (!normalize_overflow)),
    .bus(bus),
    .done(order_done),
    .error(order_error)

    );
       

endmodule

module linear_solver(
    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] cov [0:N-1][0:N-1],
    output logic signed [15:0] x [0:N-1],
    output logic ready,
    output logic overflow
);


    logic signed [15:0] r [0:N-1][0:N];
    // the last column of the matrix needs be all ones
    
    logic signed [15:0] cov_one [0:N-1][0:N];
    logic qr_ready;
    logic solver_overflow;
    logic solver_ready;
    
    assign overflow = solver_overflow;
    assign ready = solver_ready;
    
    always_comb begin
        for(int i =0; i < N; i++) begin
            for(int j=0; j < N; j++) begin
                cov_one[i][j] = cov[i][j];
            end
            cov_one[i][N] = 2**8;
        end
    end
    
    qr my_qr(
    .clk_100mhz(clk_100mhz),
    .reset(reset),
    .valid(valid),
    .matrix(cov_one),
    .r(r),
    .ready(qr_ready));

    pipe_solve_r my_solver(
    .clk_100mhz(clk_100mhz),
    .reset(reset),
    .valid(qr_ready),
    .r(r),
    .x(x),
    .overflow(solver_overflow),
    .ready(solver_ready)
);

endmodule



module qr(

    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] matrix [0:N-1][0:N],
    output logic signed [15:0] r [0:N-1][0:N],
    output logic ready
    );
    
    // 4 bits should be enough for everything
    parameter [3:0] LOGN = 1; // actually LOGN - 1 
    parameter [3:0] STAGES = 4;
    parameter [3:0] LOGS = 1; // actually LOGSTAGE - 1
    parameter [3:0] STAGE_LEN [0:3] = {2,2,1,1};
    parameter [3:0] BAD = N+1;
    
    // we are going to prescribe stages
    
    logic signed [4:0] state; 
    // 0: feed arctan
    // 1: wait arctan, put into registers
    // 2: feed rotate
    
    // these things need to be manually specified, ideally by a python script
    logic [LOGN:0] stage_x_row [0:3][0:1] = '{'{2'd0,2'd2},'{2'd0,2'd1},'{2'd1,2'd0},'{2'd2,2'd0}};
    logic [LOGN:0] stage_x_col [0:3][0:1] = '{'{2'd0,2'd0},'{2'd0,2'd1},'{2'd1,2'd0},'{2'd2,2'd0}};
    logic [LOGN:0] stage_y_row [0:3][0:1] = '{'{2'd1,2'd3},'{2'd2,2'd3},'{2'd2,2'd0},'{2'd3,2'd0}};
    logic [LOGN:0] stage_y_col [0:3][0:1] = '{'{2'd0,2'd0},'{2'd0,2'd1},'{2'd1,2'd0},'{2'd2,2'd0}};
    //logic [LOGN:0] stage1_x_row [0:1] = {0,1};
//    logic [LOGN:0] stage1_x_col [0:1] = {0,1};
//    logic [LOGN:0] stage1_y_row [0:1] = {2,3};
//    logic [LOGN:0] stage1_y_col [0:1] = {0,1};
    
    // cannot declare 0 length arrays in system verilog, we will rely on stage len to deal with this
    // for now pad this array
//    logic [LOGN:0] stage2_x_row [0:1] = {1,0};
//    logic [LOGN:0] stage2_x_col [0:1] = {1,0};
//    logic [LOGN:0] stage2_y_row [0:1] = {2,0};
//    logic [LOGN:0] stage2_y_col [0:1] = {1,0};
//    logic [LOGN:0] stage3_x_row [0:1] = {2,0};
//    logic [LOGN:0] stage3_x_col [0:1] = {2,0};
//    logic [LOGN:0] stage3_y_row [0:1] = {3,0};
//    logic [LOGN:0] stage3_y_col [0:1] = {2,0};
   
    logic [LOGS:0] stage;
    
    logic signed [15:0] arctan_tin_data_y;
    logic signed [15:0] arctan_tin_data_x;
    logic [31:0] arctan_tin_data;
    assign arctan_tin_data = {arctan_tin_data_y,arctan_tin_data_x};

    logic arctan_tin_valid;
    logic [15:0] arctan_tout_angle;
    logic arctan_tout_valid;
    logic [3:0] arctan_tin_user;
    logic [3:0] arctan_tout_user;
        
    cordic_1 dut1(.aclk(clk_100mhz),
        .s_axis_cartesian_tdata(arctan_tin_data),
        .s_axis_cartesian_tvalid(arctan_tin_valid),
        .s_axis_cartesian_tuser(arctan_tin_user),
        .m_axis_dout_tdata(arctan_tout_angle),
        .m_axis_dout_tvalid(arctan_tout_valid),
        .m_axis_dout_tuser(arctan_tout_user)
    );
    
    logic signed [15:0] rotate_tin_data_y[R-1:0];
    logic signed [15:0] rotate_tin_data_x[R-1:0];
    logic [31:0] rotate_tin_data[R-1:0];
    
    
    
    logic rotate_tin_valid;
    logic [15:0] rotate_tin_angle[1:0];
    logic [31:0] rotate_tout_data[1:0];
    logic rotate_tout_valid[1:0];
    
    logic [LOGN+1:0] rotate_tin_user[1:0];
    logic [LOGN+1:0] rotate_tout_user[1:0];
    
    // all the valid signals are tied: this is a synchronous design!
    // the output valid signals are supposed to be tied but we can't drive
    // the same wire with two inputs
     
     
    // can't use a for loop for this, should be okay though since we can't use a 
    // for loop for all the different rotators either. 
    // need to write a code generator for this
    
    assign rotate_tin_data[0] = {rotate_tin_data_y[0],rotate_tin_data_x[0]};
    assign rotate_tin_data[1] = {rotate_tin_data_y[1],rotate_tin_data_x[1]};

     
    cordic_0 rotate0
       (.aclk(clk_100mhz),
        .s_axis_cartesian_tdata(rotate_tin_data[0]),
        .s_axis_cartesian_tvalid(rotate_tin_valid),
        .s_axis_cartesian_tuser(rotate_tin_user[0]),
        .s_axis_phase_tdata(rotate_tin_angle[0]),
        .s_axis_phase_tvalid(rotate_tin_valid),
        .m_axis_dout_tdata(rotate_tout_data[0]),
        .m_axis_dout_tvalid(rotate_tout_valid[0]),
        .m_axis_dout_tuser(rotate_tout_user[0]));
     
     cordic_0 rotate1
       (.aclk(clk_100mhz),
        .s_axis_cartesian_tdata(rotate_tin_data[1]),
        .s_axis_cartesian_tvalid(rotate_tin_valid),
        .s_axis_cartesian_tuser(rotate_tin_user[1]),
        .s_axis_phase_tdata(rotate_tin_angle[1]),
        .s_axis_phase_tvalid(rotate_tin_valid),
        .m_axis_dout_tdata(rotate_tout_data[1]),
        .m_axis_dout_tvalid(rotate_tout_valid[1]),
        .m_axis_dout_tuser(rotate_tout_user[1]));

    logic [LOGN+1:0] pair;
    logic [LOGN+1:0] col;
    logic done;
   
    
    // first we will arctan
    always_ff @(posedge clk_100mhz) begin
        if(reset) begin
            stage <= 0;
            state <= -1;
            pair <= 0;
            arctan_tin_valid <= 0;
            rotate_tin_valid <= 0;
            done <= 0;
            ready <= 0;
            
        end else begin
            if(done == 0) begin
            
                if(state == -1) begin
                    if(valid == 1) begin
                        for(int i = 0; i < N; i ++) begin
                            for(int j =0; j < N+1; j++) begin
                                r[i][j] <= matrix[i][j];
                            end
                        
                        end
                        state <= 0;
                    end
                end else if(state == 0) begin
                    arctan_tin_valid <= 1;
                    // feed in new input every cycle
                    //arctan_tin_data <= 31'b0011_0011_0000_0000_0001_0101_0000_0000;
                    //arctan_tin_data <= {matrix[0][0],matrix[0][1]};

                    arctan_tin_data_y <= r[stage_y_row[stage][pair]][stage_y_col[stage][pair]] /$signed(2);
                    arctan_tin_data_x <= r[stage_x_row[stage][pair]][stage_x_col[stage][pair]]/ $signed(2);
                    arctan_tin_user <= pair;
                    if(pair < STAGE_LEN[stage] - 1) begin
                        pair <= pair + 1;
                    end else begin
                        state <= 4;
                        pair <= 0;
                    end
                end else if (state == 4) begin
                    state <= 1;
                    arctan_tin_user <= BAD;
                end else if (state == 1) begin
                    if(arctan_tout_user != BAD && arctan_tout_valid == 1) begin
                        // fully pipelined, should give one new output per cycle
                        rotate_tin_angle[pair] <= -arctan_tout_angle;
                        if(pair < STAGE_LEN[stage] - 1) begin
                            pair <= pair + 1;
                        end else begin
                            state <= 2;
                            pair <= 0;
                            col <= 0;
                        end
                    end                    
                end else if (state == 2) begin
                    // we are gonna rotate the entire row, even the leading zeros. this way it's easier to reason about.
                    // in stage 0 this is gonna be true anyways
                    // this doesn't give the right results! Vivado is stupid.
                    //rotate_tin_data[0] <= {matrix[stage0_y_row[0]][col]/2,matrix[stage0_x_row[0]][col]/2};
                    //rotate_tin_data[1] <= {matrix[stage0_y_row[1]][col]/2,matrix[stage0_x_row[1]][col]/2};
                    
                    // the rotate_tin_user of unused rotators in a stage will be forever bad. Lol. 
                    for(int i = 0; i < STAGE_LEN[stage]; i ++) begin
                        rotate_tin_data_x[i] <= r[stage_x_row[stage][i]][col]/ $signed(2);
                        rotate_tin_data_y[i] <= r[stage_y_row[stage][i]][col]/ $signed(2);
                        rotate_tin_user[i] <= col;
                    end
//                    rotate_tin_data_x[1] <= r[stage_x_row[stage][1]][col]/ $signed(2);
//                    rotate_tin_data_y[1] <= r[stage_y_row[stage][1]][col]/ $signed(2);
//                    rotate_tin_user[1] <= col;
     
                    rotate_tin_valid <= 1;
                    if(col < N) begin
                        col <= col + 1;
                    end else begin
                        col <= 0;
                        state <= 5;
                    end
                
                end else if (state == 5) begin
                    state <= 3;                    
                    for(int i = 0; i < STAGE_LEN[stage]; i ++) begin
                       rotate_tin_user[i] <= BAD;
                    end
                   //tout_valid <= 1;
                end else if (state == 3) begin
                
//                    for(int i = 0; i < STAGE_LEN[stage]; i ++) begin
//                        tout_valid = tout_valid && (rotate_tout_valid[i] == 1);
//                    end
                
                    //if(rotate_tout_valid[0] == 1 && rotate_tout_valid[1] == 1 && rotate_tout_user[0] != BAD && rotate_tout_user[1] != BAD) begin
                    // we are doing a dangerous thing here. We are assuming all the rotators are synchronous
                    // if we want to check for each rotator's tuser we will need a for loop, hard to do. 
                    if(rotate_tout_valid[0] == 1 && rotate_tout_user[0] != BAD ) begin

                        // fully pipelined, should give one new output per cycle
                        
                        for(int i = 0; i < STAGE_LEN[stage]; i ++) begin
                            r[stage_y_row[stage][i]][col] <= rotate_tout_data[i][31:16] * 2;
                            r[stage_x_row[stage][i]][col] <= -rotate_tout_data[i][15:0] * 2;
                        end
//                        r[stage_y_row[stage][1]][col] <= rotate_tout_data[1][31:16] * 2;
//                        r[stage_x_row[stage][1]][col] <= rotate_tout_data[1][15:0] * 2;
                        if(col < N ) begin
                            col <= col + 1;
                        end else begin
                            col <= 0;
                            state <= 0;
                            if(stage < STAGES -1) begin
                                stage <= stage + 1;
                            end else begin
                                done <= 1;
                                ready <= 1;
                            end
                        end
                    end
                
                end
                
            end
        end    
    end
    
endmodule



module solve_r(
    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] r[0:N-1][0:N],
    output logic signed [15:0] x [0:N-1],
    output logic overflow,
    output logic ready

);
    logic signed [15:0] dividend;
    logic signed [15:0] divisor;
    logic signed [31:0] c; 
    logic user;
    logic dividend_valid;
    logic divisor_valid;
    logic result_valid;
    logic [3:0] tuser_in;
    logic [3:0] tuser_out;

    parameter [2:0] ROWS = 4;
    parameter [2:0] ONE_COL = 4;
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
    
    logic [2:0] stage;
    logic [2:0] state;
    // 0: feed divisor
    // 1: wait divisor
    logic working;
    logic signed [15:0] cache [0:ROWS-1][0:ONE_COL];
    logic signed [15:0] result;
    logic signed [30:0] long_result;
    
    // we are going to make result FP[8,8]
    
    assign long_result = $signed(c[30:15]) * $signed(2**14) + $signed(c[14:0]);
    //assign long_result = $signed(c[30:15]) << 14 + $signed(c[14:0]);

    assign result = $signed(long_result[21:6]);

//    always_comb begin
//        if($signed(long_result[29:14]) > 2**7-1) begin
//            $display("solver overflow");
//            //$display($signed(long_result[29:14]));
//            //result = {$signed(127),8'b0};
//        end else if ($signed(long_result[29:14]) < -2**8) begin
//            $display("solver overflow");
//            //$display($signed(long_result[29:14]));

//            //result = {$signed(-128),8'b0};
//        end else begin
//            $display("no overflow?");
//        end
//    end
    
    always_ff @(posedge clk_100mhz) begin
        
        if(reset==1) begin
            working <= 0;
            dividend <= 0;
            divisor <= 0;
            tuser_in <= 0;
            overflow <= 0;
            ready <= 0;
        end else if (valid==1) begin
            if(working == 0) begin
                working <= 1;
                stage <= ROWS - 1;
                state <= 0;
                for(int i = 0; i < ROWS; i ++) begin
                    for(int j = 0; j < ONE_COL + 1; j ++) begin
                        cache[i][j] <= r[i][j];
                    end
                end
            end else if (working==1) begin
                if(state == 0) begin
                    dividend <= cache[stage][ONE_COL];
                    divisor <= cache[stage][stage];
                    dividend_valid <= 1;
                    divisor_valid <= 1;
                    tuser_in <= stage;
                    state <= 1;
                    if(cache[stage][stage] == 0) begin //division by zero!
                        overflow <= 1;
                    end
                end else if (state == 1) begin
                    if(tuser_out == stage) begin
                    // change data type here! what a waste
                    
                        for(int i = 0; i < stage; i ++) begin
                            cache[i][stage] <= 0;
                            cache[i][ONE_COL] <= cache[i][ONE_COL] - cache[i][stage] * result / $signed(2 ** 8);
                            
                            overflow <= mult_overflow(cache[i][stage], result);
                        end
                        x[stage] <= result;
                        
                       
                        if(stage == 0) begin
                            state <= 2;
                            ready <= 1;
                        end else begin
                            stage <= stage - 1;
                            state <= 0;
                        end
                    end
                end
             end
        end
    end    

endmodule

module pipe_solve_r(
    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] r[0:N-1][0:N],
    output logic signed [15:0] x [0:N-1],
    output logic overflow,
    output logic ready

);
    logic signed [15:0] dividend;
    logic signed [15:0] divisor;
    logic signed [31:0] c; 
    logic user;
    logic dividend_valid;
    logic divisor_valid;
    logic result_valid;
    logic [3:0] tuser_in;
    logic [3:0] tuser_out;

    parameter [2:0] ROWS = 4;
    parameter [2:0] ONE_COL = 4;
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
    
    logic [3:0] stage;
    logic [3:0] state;
    // 0: feed divisor
    // 1: wait divisor
    logic working;
    logic signed [15:0] cache [0:ROWS-1][0:ONE_COL];
    logic signed [15:0] cached_results ;
    logic signed [15:0] result;
    logic signed [30:0] long_result;
    
    // we are going to make result FP[8,8]
    
    assign long_result = $signed(c[30:15]) * $signed(2**14) + $signed(c[14:0]);
    //assign long_result = $signed(c[30:15]) << 14 + $signed(c[14:0]);

    assign result = $signed(long_result[21:6]);

    always_ff @(posedge clk_100mhz) begin
        
        if(reset==1) begin
            working <= 0;
            dividend <= 0;
            divisor <= 0;
            tuser_in <= 0;
            overflow <= 0;
            ready <= 0;
        end else if (valid==1) begin
            if(working == 0) begin
                working <= 1;
                stage <= ROWS - 1;
                state <= 0;
                for(int i = 0; i < ROWS; i ++) begin
                    for(int j = 0; j < ONE_COL + 1; j ++) begin
                        cache[i][j] <= r[i][j];
                    end
                end
            end else if (working==1) begin
                if(state == 0) begin
                    dividend <= cache[stage][ONE_COL];
                    divisor <= cache[stage][stage];
                    dividend_valid <= 1;
                    divisor_valid <= 1;
                    tuser_in <= stage;
                    state <= 1;
                    if(cache[stage][stage] == 0) begin //division by zero!
                        overflow <= 1;
                    end
                end else if (state == 1) begin
                    if(tuser_out == stage) begin
                    // change data type here! what a waste
                    
                        cached_results <= result;
                            //cache[i][ONE_COL] <= cache[i][ONE_COL] - cache[i][stage] * result / $signed(2 ** 8);                       
                        
                        x[stage] <= result;
                       
                        if(stage == 0) begin
                            state <= 3;
                            ready <= 1;
                        end else begin
                            state <= 2;
                        end
                    end
                end else if (state == 2) begin
                        
//                    for(int i = 0; i < stage; i ++) begin
//                        cache[i][stage] <= 0;

//                        cache[i][ONE_COL] <= cache[i][ONE_COL] - cache[i][stage] * cached_results / $signed(2 ** 8);
                        
//                        overflow <= mult_overflow(cache[i][stage], cached_results[i]);
//                    end
                    
                    case(stage)
                    
                        1: begin
                            cache[0][1] <= 0;
                            cache[0][ONE_COL] <= cache[0][ONE_COL] - cache[0][1] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[0][1], cached_results[0]);
                        end
                        2: begin
                            cache[0][2] <= 0;
                            cache[0][ONE_COL] <= cache[0][ONE_COL] - cache[0][2] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[0][2], cached_results[0]);
                             cache[1][2] <= 0;
                            cache[1][ONE_COL] <= cache[1][ONE_COL] - cache[1][2] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[1][2], cached_results[1]);
                        end
                        3: begin
                            cache[0][3] <= 0;
                            cache[0][ONE_COL] <= cache[0][ONE_COL] - cache[0][3] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[0][3], cached_results[0]);
                             cache[1][3] <= 0;
                            cache[1][ONE_COL] <= cache[1][ONE_COL] - cache[1][3] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[1][3], cached_results[1]);
                            cache[2][3] <= 0;
                            cache[2][ONE_COL] <= cache[1][ONE_COL] - cache[2][3] * cached_results / $signed(2 ** 8);
                            overflow <= mult_overflow(cache[2][3], cached_results[2]);
                        end
                    
                    endcase
                    
                    state <= 0;
                    stage <= stage - 1;

                end
             end
        end
    end    

endmodule

module normalize_w(
    input clk_100mhz,
    input reset,
    input valid,
    input signed [15:0] x [0:N-1],
    output signed [15:0] w [0:N-1],
    output logic overflow,
    output logic ready
);

    logic signed [15:0] sum;
    always_comb begin
        sum = 0;
        overflow = 0;
        for(int i = 0; i < N; i ++) begin
            sum = sum + x[i];
            overflow = overflow || add_overflow(sum,x[i]);
        end
    end
    
    logic signed [15:0] dividend;
    logic signed [15:0] divisor;
    logic signed [31:0] c; 
    logic dividend_valid;
    logic divisor_valid;
    logic result_valid;
    logic [3:0] tuser_in;
    logic [3:0] tuser_out;
    
    logic working;
    
    vector_division vec_div(
    .clk_100mhz(clk_100mhz),
    .reset(reset),
    .valid(valid),
    .a(x),
    .scale(1),
    .f(sum),
    .sel(0),
    .d(w),
    .ready(ready)
);
    

endmodule

