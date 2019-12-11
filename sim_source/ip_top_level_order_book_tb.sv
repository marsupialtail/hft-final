`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2019 03:19:05 PM
// Design Name: 
// Module Name: test_integration
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

module test_integration_1(

    );
     logic clock;
    logic [15:0] sw; 
    logic rst; 
    logic [STOCK_INDEX:0] stock_to_add;
    book_entry entry;
    logic start; 
    logic [2:0] request; 
    logic delete; 
    logic is_busy; 
    logic [ORDER_INDEX:0] order_id;
    logic [QUANTITY_INDEX:0] quantity;
    always #5 clock = !clock;
    
    
    assign sw[15] = rst;
 order_book_wrapper top_(
        .clk_in(clock),
        .rst_in(rst),
        .stock_to_add(stock_to_add),
        .order_to_add(entry), 
        .start(start),
        .request(request),
        .order_id(order_id), 
        .delete(delete), //should be one if cancel
        .quantity(quantity),
        .is_busy(is_busy));   // should be supplied for a trade
     
        
        localparam END = 8;
        
       localparam STOCKS = 4;
        logic [4:0] price_index  = 0;
        
     
       logic  [PRICE_INDEX:0]  d_array_ [0:END] [0:NUM_STOCK_INDEX];      


    assign d_array_[0] = '{115.355298916*2**8,40.9465656921*2**8,34.4863845528*2**8,55.1660735136*2**8};
    assign d_array_[1] = '{127.0*2**8,29.5824195882*2**8,37.7681143599*2**8,56.3017956783*2**8};   
    assign d_array_[2] = '{127.0*2**8,33.1636790203*2**8,31.1068030893*2**8,59.575229658*2**8};
    assign d_array_[3] = '{127.0*2**8,24.2162177991*2**8,16.112152735*2**8,50.4074439653*2**8};    
    assign d_array_[4] = '{127.0*2**8,26.2766803139*2**8,14.9420497843*2**8,48.922379298*2**8};
    assign d_array_[5] = '{121.714203685*2**8,32.1975154513*2**8,13.7534866892*2**8,44.4035407743*2**8};
    assign d_array_[6] = '{107.831157802*2**8,33.5667962178*2**8,16.7753312399*2**8,47.6596497209*2**8};
    assign d_array_[7] = '{104.862285374*2**8,36.329730527*2**8,16.6409127224*2**8,51.7086851658*2**8};
    assign d_array_[8] = '{105.119810494*2**8,36.4632174103*2**8,11.8835222024*2**8,48.5692606977*2**8};
     /*  localparam END = 2;
        
       localparam STOCKS = 4; 
        logic [4:0] price_index  = 0; 
        
         logic  [PRICE_INDEX:0]  d_array_ [0:END] [0:NUM_STOCK_INDEX] = '{'{  100, 106, 107, 108},
                                                                    '{ 99, 105, 108, 109}, 
                                                                     '{ 99, 99, 99, 99}  };  
       /*logic  [PRICE_INDEX:0]  d_array_ [0:END] [0:NUM_STOCK_INDEX] = '{'{  100*2**8, 106*2**8, 107*2**8, 108*2**8},
                                                                    '{ 101*2**8, 107*2**8, 108*2**8, 109*2**8},
                                                                     '{104*2**8, 110*2**8, 109*2**8, 110*2**8},
                                                                     '{106*2**8, 111*2**8, 111*2**8, 114*2**8},
                                                                     '{110*2**8, 113*2**8, 114*2**8, 116*2**8},
                                                                     '{110*2**8, 113*2**8, 114*2**8, 116*2**8}};      */
  initial begin
    clock = 1;
    rst = 1; 
    start = 0; 
    #10; 
    rst = 0;
    for(int j = 0; j <= END; j = j+1) begin  
        for(int i = 0; i <= NUM_STOCK_INDEX; i = i+1) 
        begin
            if(price_index != 0) begin
                stock_to_add = i; 
                start = 1; 
                order_id = 1;
                request = CANCEL_ORDER;
                delete = 1; 
                #10; 
                start = 0; 
                while(is_busy) begin
                    #10;
                
                end
            end   
            
            stock_to_add = i; 
            start = 1; 
            entry = '{price:d_array_[price_index][i], order_id:1, quantity:1}; 
            request = ADD_ORDER; 
            #10; 
            start = 0; 
            while(is_busy) begin
                #10;
            end
        
        //#1000;  
      end
      
     price_index = price_index+1;
    end
  end    
endmodule