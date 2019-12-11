`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2019 03:37:49 PM
// Design Name: 
// Module Name: uart
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


module serial_tx(   input           clk_in,
                    input           rst_in,
                    input           trigger_in,
                    input [7:0]     val_in,
                    output logic    done,
                    output logic    data_out);
    parameter   DIVISOR = 694; //treat this like a constant!!
    
    logic [9:0]         shift_buffer = 10'b0; //10 bits...interesting
    logic [31:0]        count = 32'b0;
    logic [3:0] sent;
    
    assign data_out = ~shift_buffer[0];
    
    always @(posedge clk_in)begin
        //count <= count + 1;

        if(rst_in) begin
            count <= 32'b0;
            sent <= 0;
            done <= 0;
        end else if(trigger_in) begin
            count <= 32'b0;

            shift_buffer[9] <= 0;
            shift_buffer[8:1] <= ~val_in[7:0];
            shift_buffer[0] <= 1;
            
            sent <= 0;
            done <= 0;
        end else begin
            if(count == DIVISOR) begin
                count <= 32'b0; 
                shift_buffer <= shift_buffer >> 1;
                sent <= sent + 1;
                if(sent == 9) begin
                    done <= 1;
                end
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
