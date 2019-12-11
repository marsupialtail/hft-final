`timescale 1ns / 1ps
//`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2019 07:14:49 PM
// Design Name: 
// Module Name: order_book
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


    
module memory_manager(
    input clk_in,
    input logic start, 
    input logic is_write, 
    input logic [ADDRESS_INDEX:0] addr, 
    input book_entry data_i, 
    output book_entry data_o, 
    output logic valid); 
    

    logic [10:0] counter = 0;
  
    logic write;
    localparam WAITING = 0; 
    localparam STARTED = 1; 
    
    logic [2:0] state = WAITING; 
    logic enable = 0;
    
    blk_mem_gen_0 mem (.clka(clk_in), .addra(addr), .douta(data_o), .dina(data_i), .ena(enable), .wea(write)); 
    //ila_0 my_ila(.clk(clk_in), .probe0(start_book), .probe1(best_price_o), .probe2(current_size));
    always_ff @(posedge clk_in) begin
        case(state) 
            WAITING: begin
                valid <= 0; 
                if(start) begin
                    write <= is_write; 
                    state <= STARTED; 
                    counter <= 1; 
                    enable <= 1; 
                end 
                
            end    
            STARTED: begin    
                if(counter < BRAM_LATENCY + 1) begin
                    counter <= counter + 1; 
                end
                else begin
                    state <= WAITING;
                    counter <= 0;  
                    valid <= 1;
                    enable <= 0;  
                    write <= 0;
                end
             end   
         endcase
         
    end
        
endmodule        
    
 
  
  
module order_book #(parameter IS_MAX = MAX) (
        input clk_in,
        input rst_in,
        input book_entry order_to_add, 
        input start_book,
        input delete, 
        input [2:0] request,
        input [ORDER_INDEX:0] order_id, //should be supplied for a cancel / trade
        input [QUANTITY_INDEX:0] quantity,  // should be supplied for a trade
        output logic is_busy_o,
        output logic [CANCEL_UPDATE_INDEX:0] cancel_update, 
        output logic [PRICE_INDEX:0] best_price_o, 
        output logic best_price_valid, 
        output logic [SIZE_INDEX:0] size_book
    );
    
    localparam MAX_INDEX = 0; 

  

    localparam START = 0; 
    localparam PROGRESS = 1; 
    
    logic start; 
    logic [ADDRESS_INDEX:0] addr;
    
    logic [ADDRESS_INDEX:0] add_addr;
    
    
    
    logic [PRICE_INDEX:0] best_price = 0;
    
    assign best_price_o = best_price; 
    logic [PRICE_INDEX:0] add_best_price;
    logic [PRICE_INDEX:0] decrease_best_price; 
    
    book_entry data_i; 
    book_entry data_o; 
    
    book_entry add_data_w;
    book_entry decrease_w; 
    
    logic mem_start; 
    
    

    logic valid;
    logic is_write; 
    
    logic is_write_add; 
    logic add_start;
    logic decrease_start; 
    logic add_ready; 
    logic decrease_ready; 
    logic add_mem_start;
    
    
    logic valid_mem; 
    logic units_busy; 
    
    localparam WAITING_STATE= 2'b00; 
    localparam PROGRESS_STATE = 2'b01;
    
    logic [2:0] request_latched = 0; 
    memory_manager book_mem(.clk_in(clk_in), .start(mem_start), .is_write(is_write), .addr(addr), .data_i(data_i), .data_o(data_o), .valid(valid_mem)); 
   
    
 
       
     logic is_busy = 0; 
    assign is_busy_o = is_busy; 
     logic [SIZE_INDEX:0] current_size = 0;
     logic [SIZE_INDEX:0] add_size;
     logic [SIZE_INDEX:0] decrease_size; 
    
    assign size_book = current_size; 
    assign best_price_valid = current_size > 0; 
      
    add_order order_adder(.clk_in(clk_in), .order(order_to_add), .start(add_start), .valid(valid_mem), .price_valid(best_price_valid),
    .best_price(best_price),
                          .size(current_size),.addr(add_addr), .mem_start(add_mem_start), .is_write(is_write_add), 
                          .ready(add_ready), .size_update_o(add_size), .data_w(add_data_w), .add_best_price(add_best_price)); 

  
     read_result read_output;
     mem_struct mem_control; 
     
     assign read_output.first = data_o;
     logic delete_actual; 
    decrease_order order_decreaser(.clk_in(clk_in), .id(order_id), .quantity(quantity), .delete(delete_actual),  .best_price(best_price),
                                   .mem_valid(valid_mem), .size(current_size), .start(decrease_start), 
                                   .data_r(read_output), .mem_control(mem_control), .data_w(decrease_w), 
                                   .ready(decrease_ready), .size_update_o(decrease_size), .update(cancel_update)); 
     always_comb begin
        if(is_busy ) begin
            case(request_latched)
                ADD_ORDER: begin
                    addr = add_addr; 
                    is_write = is_write_add; 
                    mem_start = add_mem_start; 
                    data_i =  add_data_w; 
                    units_busy = !add_ready; 
                end
                //R, EXECUTE_ORDER:
                CANCEL_ORDER, EXECUTE_ORDER: begin
                   addr = mem_control.addr; 
                   is_write = mem_control.is_write;
                   mem_start = mem_control.start; 
                   data_i = decrease_w; 
                   units_busy = !decrease_ready; 
                end
                default: begin
                  addr = 0; 
                  units_busy = 0; 
                  is_write = 0; 
                  mem_start = 0; 
                  data_i = 0; 
                  units_busy = 0; 
                end
            endcase  
        end
        else begin
          addr = 0; 
          units_busy = 0; 
          is_write = 0; 
          mem_start = 0; 
          data_i = 0; 
          units_busy = 0;  
        end

    end
    
    logic [3:0] add_state;
    
     
    logic [1:0] add_mem_state; 
    
    logic [1:0] current_state =  WAITING_STATE;

 //  ila_0 book_ila(.clk(clk_in), .probe0(start_book), .probe1(best_price_o), .probe2(current_size));
    always_ff @(posedge clk_in) begin
        
        if(rst_in)  begin
            current_size <= 0;
            //add_size <= 0; 
            is_busy <= 0; 
          //  decrease_size <= 0; 
        end
        else begin
              
            if(is_busy) begin
                add_start <= 0;
                decrease_start <= 0;  
                if(!units_busy) begin
                   is_busy <= 0;  
                   case(request_latched) 
                      ADD_ORDER: begin
                         current_size <= add_size; 
                         best_price <= add_best_price;  
                      end
                      CANCEL_ORDER, EXECUTE_ORDER: begin
                         current_size <= decrease_size; 
                      end
                       
                   endcase
                end
            end
            else begin
                if(start_book) begin
                    request_latched <= request; 
                    is_busy <= 1;
                    case(request)
                        ADD_ORDER: begin
                            add_start <= 1; 
                        end
                        CANCEL_ORDER: begin
                            decrease_start <= 1; 
                            delete_actual <= 1; 
                         end
                        EXECUTE_ORDER: begin
                           decrease_start <= 1; 
                           delete_actual <= 0;
                        end                 
                    endcase
                end 
        end  
     end
              
           
    end
    
    
    
endmodule




module add_order#(parameter IS_MAX=MAX)
               (input clk_in, input book_entry order, input start, input valid, 
                input [SIZE_INDEX:0] size, input [PRICE_INDEX:0] best_price, input price_valid, 
                output logic [ADDRESS_INDEX:0] addr,  output logic mem_start,
                output book_entry data_w, 
                output logic is_write, output logic ready, output logic [SIZE_INDEX:0] size_update_o, 
                output logic  [PRICE_INDEX:0] add_best_price ); 


    logic [1:0] add_mem_state = 0; 
    
    localparam START = 0; 
    localparam PROGRESS = 1; 
    logic [SIZE_INDEX:0] size_update = 0; 
    
    
    assign size_update_o = size_update; 
    
    
    always_ff @(posedge clk_in) begin
       case(add_mem_state) 
       START: begin
            ready <= 0; 
            if(start) begin
                if(size < MAX_INDEX) begin
                    addr <= size; 
                    is_write <= 1;
                    size_update <= size + 1; 
                    add_mem_state <= PROGRESS;
                    data_w <= order; 
                    mem_start <= 1; 
                    if(!price_valid || (order.price > best_price) == IS_MAX) begin
                       add_best_price <= order.price; 
                    end
                    else begin
                        add_best_price <= best_price; 
                    end
                
                 end     
            end
        end
        PROGRESS: begin
            mem_start <= 0; 
            if(valid) begin
                ready <= 1; 
                add_mem_state <= START; 
            end    
        end            
    endcase      
     end
     
             
endmodule


 

module decrease_order#(parameter SIDE=BUY_SIDE)
               (input clk_in,
                input logic [ORDER_INDEX:0] id,
                input [QUANTITY_INDEX:0] quantity, 
                input [PRICE_INDEX:0] best_price,
                input delete,
                input mem_valid, 
                input [SIZE_INDEX:0] size,
                input start, 
                input read_result data_r, 
                output  mem_struct mem_control, 
                output book_entry data_w, 
                output logic ready, 
                output logic [SIZE_INDEX:0] size_update_o, 
                output logic[CANCEL_UPDATE_INDEX:0] update
    ); 
    logic [SIZE_INDEX:0] index; 
    
    logic [SIZE_INDEX:0] size_latched; 
  
    localparam WAITING = 3'b000; 
    localparam FIND = 3'b001;
    localparam DELETE = 3'b010; 
    localparam UPDATE = 3'b110; 
    localparam DONE = 3'b011; 
    localparam NOT_FOUND = 3'b111; 
     
    localparam COPY = 2'b00; 
    localparam MOVE = 2'b01; 
    
    
    localparam MEM_IDLE = 0 ; 
    localparam MEM_PROGRESS = 1; 
    logic [2:0] mem_state = MEM_IDLE; 
        
  
     
    logic [2:0] state = WAITING; 
     
    logic [SIZE_INDEX:0] update_index; 
    logic [2:0] delete_state; 
    logic [QUANTITY_INDEX:0] quantity_latched;
    logic delete_latched;  
    book_entry copy_entry; 
    
    assign size_update_o = size_latched; 
    
    //need start signal, entry in order book, addr, delete 
   // ila_1 my_ila(.clk(clk_in), .probe0(0), .probe1(data_r), .probe2(mem_valid), .probe3(start), .probe4(mem_control.addr));
    
    always_ff @(posedge clk_in) begin
          case (state)
          
            WAITING: begin
                data_w <= 0; 
                update <= WAITING; 
                if(start) begin
                    index <= 0; 
                    state <= FIND; 
                    mem_state <= MEM_IDLE; 
                    size_latched <= size; 
                    quantity_latched <= quantity; 
                    delete_latched <= delete; 
                    ready <= 0; 
                end 
                else begin
                    ready <= 0;
                end
            end  
            UPDATE: begin 
                    case(mem_state) 
                        MEM_IDLE: begin
                          mem_control.addr <= update_index;    
                          mem_control.is_write <= 1;  
                          mem_control.start <= 1; 
                          data_w <= '{price:copy_entry.price, order_id:copy_entry.order_id, quantity:copy_entry.quantity - quantity_latched};
                          mem_state <= MEM_PROGRESS;
                        end  
                        MEM_PROGRESS: begin
                           mem_control.start <= 0; 
                            if(mem_valid) begin
                                mem_state <= MEM_IDLE; 
                                state <= WAITING; 
                                update <= UPDATE;
                                ready <= 1; 
                            end
                       end
                    endcase 
               
               end  
            FIND: begin
              case(mem_state) 
                  MEM_IDLE:  begin
                    if(index < size_latched) begin
                        mem_control <= '{addr: index, is_write:0, start: 1}; 
                        mem_state <= MEM_PROGRESS;
                    end
                    else begin
                       state <= WAITING; 
                       update <= NOT_FOUND; 
                       ready <= 1;   
                       
                    end
                  end
                  MEM_PROGRESS: begin
                   mem_control.start <= 0; 
                    if(mem_valid) begin
                       mem_state <= MEM_IDLE;
                      
                        if(data_r.first.order_id == id) begin
                            update_index <= index;
                            if(data_r.first.quantity <= quantity || delete_latched) begin
                                state <= DELETE; 
                                delete_state <= COPY;  
                            end
                            else begin
                               state <= UPDATE; 
                               copy_entry <= data_r.first;     
                            end
                        end  
                        else begin
                            index <= index + 1; 
                        end
                        
                          
                    end
                  end
              endcase
            end  
            DELETE: begin
              case(delete_state) 
              
                COPY: begin
                    case(mem_state) 
                      MEM_IDLE: begin
                        if(update_index + 1 < size_latched) begin
                          
                          mem_control.addr <= update_index + 1;   
                          mem_control.is_write <= 0; 
                          mem_control.start <= 1; 
                          mem_state <= MEM_PROGRESS;
                        end
                        else begin
                           size_latched <= size_latched - 1; 
                           state <= WAITING;  
                           ready <= 1; 
                           update <= DELETE;  
                        end
                       end  
                        
                      MEM_PROGRESS: begin
                         mem_control.start <= 0; 
                        if(mem_valid) begin
                            copy_entry <= data_r.first; 
                            
                            delete_state <= MOVE; 
                            mem_state <= MEM_IDLE; 
                            
                        end
                      end  
                    endcase       
               end
               MOVE: begin
                    case(mem_state) 
                        MEM_IDLE: begin
                        
                          mem_control.addr <= update_index;    
                          mem_control.is_write <= 1;  
                          mem_control.start <= 1; 
                          data_w <= copy_entry; 
                          mem_state <= MEM_PROGRESS;
                        
                        end  
                        MEM_PROGRESS: begin
                           mem_control.start <= 0; 
                            if(mem_valid) begin
                                mem_state <= MEM_IDLE; 
                                delete_state <= COPY; 
                                update_index <= update_index + 1; 
                            end
                       end
                    endcase 
                end    
               
             endcase   
             
             
           end
            
          endcase    
  
    end

endmodule        