////`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////////
////// Company: 
////// Engineer: 
////// 
////// Create Date: 12/05/2019 05:58:33 PM
////// Design Name: 
////// Module Name: book_trade_stack
////// Project Name: 
////// Target Devices: 
////// Tool Versions: 
////// Description: 
////// 
////// Dependencies: 
////// 
////// Revision:
////// Revision 0.01 - File Created
////// Additional Comments:
////// 
//////////////////////////////////////////////////////////////////////////////////////

////`include "book_top_level.sv"
//`include "constants.sv"


//module book_trade_stack(
//    input clk_100mhz,
//    input reset,
//    input [STOCK_INDEX:0] stock_to_add,
//    input book_entry order_to_add,
//    input start,
//    input [2:0] request,
//    input [ORDER_INDEX:0] order_id, //should be supplied for a cancel / trade
//    input delete, //should be one if cancel
//    input [QUANTITY_INDEX:0] quantity,  // should be supplied for a trade
//    output bus,
//    output trade_overflow,
//    output order_done,
//    output order_error
//    );
    
//    logic [PRICE_INDEX:0] best_price_stocks [0:NUM_STOCK_INDEX];
//    logic best_price_valid;
    
//    book_builder endrias_book_builder(

//       .clk_in(clk_100mhz),
//       .rst_in(reset),
//       .stock_to_add(stock_to_add),
//       .order_to_add(order_to_add),
//       .start(start),
//       .request(request),
//       .order_id(order_id), //should be supplied for a cancel / trade
//       .delete(delete), //should be one if cancel
//       .quantity(quantity)  // should be supplied for a trade
//       .best_price_valid(best_price_valid),
    

//   );
   
//   trading_top tony_trader(
//    .clk_100mhz(clk_100mhz),
//    .latest_price(best_price_stocks),
//    .latest_price_valid(best_price_valid),
//    .global_reset(reset),
//    .bus(bus),
//    .global_overflow(trade_overflow),
//    .order_error(order_error),
//    .order_done(order_done)
//    );

    
//endmodule
