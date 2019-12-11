`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2019 06:14:07 PM
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



module top_level_simulation(input clk_in, input next, input reset, output busy,
    output logic[PRICE_INDEX:0] best_price_stocks  [0:NUM_STOCK_INDEX] ,
    output logic stocks_valid                                     
);                                               
    logic [STOCK_INDEX:0] stock_to_add;                        
    book_entry entry;                                          
    reg start;                                               
    logic [2:0] request;                                       
    logic delete;                                              
    logic is_busy;                                             
    logic [ORDER_INDEX:0] order_id;                            
    logic [QUANTITY_INDEX:0] quantity; 
    
            

    
 order_book_wrapper top_(                                      
        .clk_in(clk_in),                                        
        .rst_in(reset),                                          
        .stock_to_add(stock_to_add),                           
        .order_to_add(entry),                                  
        .start(start),                                         
        .request(request),                                     
        .order_id(order_id),                                   
        .delete(delete), //should be one if cancel             
        .quantity(quantity),                                   
        .is_busy(is_busy),
        .best_price_stocks(best_price_stocks),
        .best_prices_valid(stocks_valid));   // should be supplied for a trade
        

       localparam FIRST = 0; 
       localparam END = 5; 
       

       localparam WAIT_FIRST = 2'b00; 
       localparam WAIT_NEXT = 2'b01;
       localparam PROGRESS =  2'b11; 
       logic [1:0] top_level = WAIT_NEXT;  
            
       logic [7:0] state = 0;  
       
       reg pick_next_previous; 
       logic [PRICE_INDEX:0] best_price; 
       assign best_price = best_price_stocks[0]; 
   //    ila_0 top_level_ila(.clk(clk_in), .probe0(best_price), .probe1(top_level), .probe2(state));
       
       logic change_signal; 
 
       assign busy = (top_level == PROGRESS) || is_busy;  
       
       logic  [PRICE_INDEX:0]  d_array_ [0:END] [0:NUM_STOCK_INDEX] = '{'{  100.123*2**7, 106.54*2**7, 107.23*2**7, 108.6546*2**7},
                                                                    '{ 130.785*2**7, 150.5463*2**7, 110.213*2**7, 113.4353*2**7},
                                                                     '{164.3242*2**7, 170.23*2**7, 120.234*2**7, 119.7612*2**7},
                                                                     '{186.768*2**7, 171.756*2**7, 130.6587*2**7, 134.324*2**7},
                                                                     '{190.01*2**7, 172.99*2**7, 150.1*2**7, 146.865*2**7},
                                                                     '{190.88*2**7, 173.21*2**7, 160.234*2**7, 176.24*2**7}};
       logic  [PRICE_INDEX:0]  d_array [1:0] [NUM_STOCK_INDEX:0] = '{'{ 100.0*2**8,40.0*2**8,50.0*2**8,60.0*2**8},
                                                                      '{ 115.355298916*2**8,40.9465656921*2**8,34.4863845528*2**8,55.1660735136*2**8}};
       
       logic  [PRICE_INDEX:0]  price_ [NUM_STOCK_INDEX:0]= { 100.0*2**8,40.0*2**8,50.0*2**8,60.0*2**8};  
      
      logic [3:0]  stock_index = 0; 
      logic [3:0] price_index = 0; 
      parameter INITIAL = 0; 
      parameter ADD = 1;  
      parameter DELETE = 2; 
      always_ff @(posedge clk_in) begin
         case(top_level) 
         PROGRESS: begin
           case(state) 
                ADD: begin
                    stock_to_add <= stock_index;                                           
                    start <= 1;                                                  
                    entry <= '{price:d_array_[price_index][stock_index], order_id:2, quantity:2};                 
                    request <= ADD_ORDER;                                        
                    top_level <= WAIT_FIRST;                                                    
                end
              /*  
               2: begin
                    stock_to_add <= 0;                                           
                    start <= 1;                                                  
                    entry <= '{price:4, order_id:3, quantity:2};   
                                
                    request <= ADD_ORDER;                                        
                   top_level <= WAIT_FIRST;  
               
                 end 
               3: begin
                  stock_to_add <= 0;                                           
                    start <= 1;                                                  
                    order_id <= 3; 
                    delete <= 1;              
                    request <= CANCEL_ORDER;                                        
                   top_level <= WAIT_FIRST;   
               end  */
               
                
            endcase    
        end
        WAIT_FIRST: begin
           top_level <= WAIT_NEXT; 
           
        end
      
        WAIT_NEXT: begin
        
          start <= 0; 
          
           if(!is_busy && price_index <= END )  begin
               if(next && (state == INITIAL)) begin
                stock_index <= 0; 
                state <= ADD; 
                top_level <= PROGRESS; 
               end
               else if(stock_index < NUM_STOCK_INDEX) begin
                  stock_index <= stock_index + 1; 
                  state <= ADD; 
                  top_level <= PROGRESS;
               end 
              else if(next && price_index < END) begin
                  
                  stock_index <= 0; 
                  state <= ADD;
                  price_index <= price_index + 1;
                  top_level <= PROGRESS;
                end     
              
           end
        end   
        endcase  
        
       end  

endmodule 

module top_level_order_book(input clk_100mhz, input btnu, input [15:0] sw);
                       
       logic pick_next;                              
       debounce d1(.clock_in(clk_100mhz), .reset_in(sw[15]), .noisy_in(btnu), .clean_out(pick_next));  
       logic pick_next_previous; 
       logic change; 
       always_ff @(posedge clk_100mhz) begin
           pick_next_previous <= pick_next;
           change <= pick_next_previous == 0 && pick_next == 1; 
       end 
       
       logic busy; 
       top_level_simulation(.clk_in(clk_100mhz), .next(change), .reset(sw[15]), .busy(busy)); 
            
      
                                                   
endmodule 

module order_book_wrapper(
        input clk_in,
        input rst_in,
        input [STOCK_INDEX:0] stock_to_add,
        input book_entry order_to_add, 
        input start,
        input delete,
        input [QUANTITY_INDEX:0] quantity,
        input [2:0] request,
        input [ORDER_INDEX:0] order_id, //should be supplied for a cancel / trade
        output logic is_busy,
        output logic best_price_valid,
        output logic [CANCEL_UPDATE_INDEX:0] cancel_update, 
        output logic [PRICE_INDEX:0] best_price_stocks [0:NUM_STOCK_INDEX], 
        output logic [0:NUM_STOCK_INDEX] best_prices_valid,
        output logic [SIZE_INDEX:0] size_of_stocks [0:NUM_STOCK_INDEX] 
    );
    logic [NUM_STOCK_INDEX:0] order_book_start; 
    logic [NUM_STOCK_INDEX:0] book_busy; 
    

    logic [STOCK_INDEX:0] stock_latched; 
    localparam WAITING = 2'b00; 
    localparam INITATE = 2'b01;
    localparam PROGRESS = 2'b10; 
 

    
    assign best_price_valid = &best_prices_valid;
     
     logic [2:0] state = WAITING;
         assign is_busy = state != WAITING; 
     genvar i; 
    
   
     generate 
        for(i = 0; i < NUM_STOCKS; i = i+1) 
   
        begin
          order_book #(.IS_MAX(MAX))  book(
        .clk_in(clk_in),
        .rst_in(rst_in), 
        .order_to_add(order_to_add),
        .request(request), 
        .start_book(order_book_start[i]),
        .order_id(order_id), 
        .delete(delete), 
        .quantity(quantity), 
        .is_busy_o(book_busy[i]),
        .best_price_o(best_price_stocks[i]), 
        .best_price_valid(best_prices_valid[i]),
        .size_book(size_of_stocks[i])
    );  
        end
    endgenerate 
    
    
    
  //  ila_0 wrapper_ila(.clk(clk_in), .probe0(stock_to_add), .probe1(start), .probe2(state));
     always_ff @(posedge clk_in) begin
        case(state) 
            WAITING: begin
               if(start) begin
                 if(stock_to_add < NUM_STOCKS) begin
                   state <= INITATE;
                   stock_latched <= stock_to_add; 
                   //stock to add from 0 to 1
                   order_book_start[stock_to_add] <= 1; 
                 end
                else begin
         
                end
               end
            
            end
            INITATE: begin
               state <= PROGRESS; 
               order_book_start[stock_to_add] <= 0; 
            end 
            PROGRESS: begin
              if(!book_busy[stock_latched]) begin
                state <= WAITING; 
              end
            end
        endcase
         
        
     
     end
        
endmodule
    