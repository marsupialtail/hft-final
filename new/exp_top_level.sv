`include "constants.sv"

module test_integration(
 input sys_clk,
 input [15:0] sw,
 input btnd,
 output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
output[7:0] an,
output led16_b,
output led16_g,
output led16_r
    );
     
    logic rst; 
    logic [STOCK_INDEX:0] stock_to_add;
    book_entry entry;
    logic start; 
    logic [2:0] request; 
    logic delete; 
    logic is_busy; 
    logic [ORDER_INDEX:0] order_id;
    logic [QUANTITY_INDEX:0] quantity;
    
    logic book_busy;
    
    wire clk_80mhz;
    logic pick_next;
    logic pick_next_r;
    
    clk_wiz_0 bump(.clk_in1(sys_clk),.clk_out1(clk_80mhz));
    debounce d1(.clock_in(clk_80mhz), .reset_in(sw[15]), .noisy_in(btnd), .clean_out(pick_next));  

    
 top_level dut(
    .clk_100mhz(clk_80mhz),
    .sw(sw),
    .stock_to_add(stock_to_add),                           
    .entry(entry),                                  
    .start(start),                                         
    .request(request),                                     
    .order_id(order_id),                                   
    .delete(delete), //should be one if cancel             
    .quantity(quantity),                                   
    .book_busy(book_busy),
    .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg), .dp(dp),  // segments a-g, dp
    .an(an),
    .led16_b(led16_b),
    .led16_g(led16_g),
    .led16_r(led16_r)
);
        
assign is_busy = book_busy;    
localparam END = 48;

localparam STOCKS = 4; 
logic [6:0] price_index  = 0; 

logic [5:0] state;
logic [5:0] state2;
logic [20:0] counter;
logic [5:0] i;

logic  [PRICE_INDEX:0]  d_array_ [0:48] [0:NUM_STOCK_INDEX];      


assign d_array_[0] = '{115.355298916*2**8,40.9465656921*2**8,34.4863845528*2**8,55.1660735136*2**8};
assign d_array_[1] = '{127.0*2**8,29.5824195882*2**8,37.7681143599*2**8,56.3017956783*2**8};   
assign d_array_[2] = '{127.0*2**8,33.1636790203*2**8,31.1068030893*2**8,59.575229658*2**8};
assign d_array_[3] = '{127.0*2**8,24.2162177991*2**8,16.112152735*2**8,50.4074439653*2**8};    
assign d_array_[4] = '{127.0*2**8,26.2766803139*2**8,14.9420497843*2**8,48.922379298*2**8};
assign d_array_[5] = '{121.714203685*2**8,32.1975154513*2**8,13.7534866892*2**8,44.4035407743*2**8};
assign d_array_[6] = '{107.831157802*2**8,33.5667962178*2**8,16.7753312399*2**8,47.6596497209*2**8};
assign d_array_[7] = '{104.862285374*2**8,36.329730527*2**8,16.6409127224*2**8,51.7086851658*2**8};
assign d_array_[8] = '{105.119810494*2**8,36.4632174103*2**8,11.8835222024*2**8,48.5692606977*2**8};
 assign d_array_[9] = '{114.597976689*2**8,31.5138766363*2**8,11.2625986153*2**8,60.0325608116*2**8};
assign d_array_[10] = '{127.0*2**8,30.8718742797*2**8,11.3880525765*2**8,68.2524073185*2**8};
assign d_array_[11] = '{127.0*2**8,35.2823975615*2**8,11.6782023548*2**8,72.8426985594*2**8};
assign d_array_[12] = '{110.719361169*2**8,41.2466444431*2**8,10.0730285769*2**8,69.4478890888*2**8};
assign d_array_[13] = '{117.036119074*2**8,40.7110493239*2**8,9.28277202102*2**8,65.8450732847*2**8};
assign d_array_[14] = '{111.715096564*2**8,48.1988851077*2**8,11.8730974208*2**8,66.1485055281*2**8};
assign d_array_[15] = '{121.865032382*2**8,43.7055950132*2**8,13.3517863552*2**8,72.524286021*2**8};
assign d_array_[16] = '{108.302428202*2**8,55.8442320488*2**8,16.0832484483*2**8,73.7296488882*2**8};
assign d_array_[17] = '{97.226952325*2**8,62.014963434*2**8,16.7774795442*2**8,75.2919034407*2**8};
assign d_array_[18] = '{90.6678104747*2**8,50.0936828466*2**8,21.0118773381*2**8,83.4179169717*2**8};
assign d_array_[19] = '{84.8955530082*2**8,55.0117560956*2**8,20.6890245493*2**8,74.2816540892*2**8};
assign d_array_[20] = '{80.1419504053*2**8,53.3106375326*2**8,20.137454168*2**8,64.7584964188*2**8};
assign d_array_[21] = '{60.7513387387*2**8,71.6125388503*2**8,17.7900295254*2**8,58.9446616845*2**8};
assign d_array_[22] = '{53.7268766339*2**8,87.4878206377*2**8,18.9229693044*2**8,50.9871838095*2**8};
assign d_array_[23] = '{54.4787402579*2**8,88.2286718086*2**8,19.9184967643*2**8,55.4132552897*2**8};
assign d_array_[24] = '{60.4511616641*2**8,88.1367642681*2**8,20.8200638912*2**8,67.2460681644*2**8};
assign d_array_[25] = '{57.9115691272*2**8,97.1932589329*2**8,26.2062138427*2**8,75.2154847462*2**8};
assign d_array_[26] = '{60.8418186729*2**8,101.752719816*2**8,25.9507034878*2**8,76.4600177024*2**8};
assign d_array_[27] = '{69.4445333909*2**8,101.528164165*2**8,32.4440127955*2**8,88.8203943876*2**8};
assign d_array_[28] = '{67.1445591665*2**8,98.6093829304*2**8,29.9111268138*2**8,91.4736035158*2**8};
assign d_array_[29] = '{69.6854153859*2**8,100.625107418*2**8,28.064677332*2**8,86.4577312171*2**8};   
assign d_array_[30] = '{63.0214546891*2**8,114.547429973*2**8,30.6303494529*2**8,74.7318935931*2**8};
assign d_array_[31] = '{62.7039351437*2**8,110.804146475*2**8,37.3565836673*2**8,77.239585318*2**8};   
assign d_array_[32] = '{72.5134151997*2**8,99.7846919829*2**8,34.8330094562*2**8,80.4745304686*2**8}; 
assign d_array_[33] = '{76.2436407022*2**8,111.841025794*2**8,33.2757954451*2**8,72.9691931419*2**8};
assign d_array_[34] = '{90.2206143745*2**8,100.061234541*2**8,27.4101689838*2**8,82.2846129524*2**8};
assign d_array_[35] = '{89.5106913138*2**8,100.380392776*2**8,31.5142202558*2**8,73.4638548513*2**8};
assign d_array_[36] = '{81.7403296696*2**8,110.582419879*2**8,37.9382660578*2**8,65.0549725876*2**8};
assign d_array_[37] = '{85.2385067308*2**8,97.0056728205*2**8,34.2251549301*2**8,69.5930200369*2**8};
assign d_array_[38] = '{81.3976054959*2**8,91.8966607002*2**8,35.5322675347*2**8,73.3630103629*2**8};
assign d_array_[39] = '{96.4392373603*2**8,73.5818473341*2**8,29.4327838287*2**8,73.7432268743*2**8};
assign d_array_[40] = '{100.173689874*2**8,60.7258793598*2**8,37.6357014651*2**8,83.1968419319*2**8};
assign d_array_[41] = '{106.07352731*2**8,57.1030912601*2**8,37.0329010041*2**8,79.6106047598*2**8};
assign d_array_[42] = '{113.061032135*2**8,46.765730082*2**8,33.7549827641*2**8,75.3121698778*2**8};
assign d_array_[43] = '{116.737698198*2**8,46.7820686982*2**8,25.7475344197*2**8,65.830989642*2**8};
assign d_array_[44] = '{127.0*2**8,50.7438975216*2**8,24.2887476739*2**8,61.6278785072*2**8};
assign d_array_[45] = '{121.930017526*2**8,40.8344653949*2**8,22.8432596129*2**8,63.7982933554*2**8};
assign d_array_[46] = '{119.410717373*2**8,41.513271546*2**8,22.3017840614*2**8,68.2367308458*2**8};
assign d_array_[47] = '{127.0*2**8,42.6778194476*2**8,21.9146782117*2**8,65.612051776*2**8};
assign d_array_[48] = '{127.0*2**8,40.2419214303*2**8,22.1645451001*2**8,66.3635141004*2**8};



always_ff @(posedge clk_80mhz) begin

    if(sw[3] == 1) begin
        counter <= 0;
        state <= 0;
        state2 <= 0;
        i <= 0;
        price_index <= 0;
    end else begin
    
        pick_next_r <= pick_next;
    
        if(state == 0) begin
            if(price_index != 0) begin
                if(state2 == 0) begin 
                    stock_to_add <= i;
                    start <= 1;
                    order_id <= 1;
                    request <= CANCEL_ORDER;
                    delete <= 1;
                    state2 <= 5;
                end else if (state2 == 5) begin
                    state2 <= 1;
                end else if (state2 == 1) begin
                    start <= 0;
                    if(is_busy) begin
                        state2 <= 1;
                    end else begin
                        if(i == NUM_STOCK_INDEX) begin
                            i <= 0;
                            state2 <= 2;				
                        end else begin
                            state2 <= 0;
                            i <= i + 1;
                        end
                    end
                end else if (state2 == 2) begin
                    stock_to_add <= i;
                    start <= 1;
                    entry <= '{price:d_array_[price_index][i], order_id:1, quantity:1}; 
                        request <= ADD_ORDER;
                    state2 <= 6;
                end else if (state2 == 6) begin
                    state2 <= 3; 
                end else if (state2 == 3) begin
                    start <= 0;
                    if(is_busy) begin
                        state2 <= 3;
                    end else begin
                        if(i == NUM_STOCK_INDEX) begin
                            i <= 0;
                            state2 <= 4;				
                        end else begin
                            state2 <= 2;
                            i <= i + 1;
                        end
                    end
                end else if (state2 == 4) begin
                    state <= 1;			
                    counter <= 0;
                end
            end else begin
                if (state2 == 0) begin
                    stock_to_add <= i;
                    start <= 1;
                    entry <= '{price:d_array_[price_index][i], order_id:1, quantity:1}; 
                    request <= ADD_ORDER;
                    state2 <= 5;
                end else if (state2 == 5) begin
                    state2 <= 1; 
                end else if (state2 == 1) begin
                    start <= 0;
                    if(is_busy) begin
                        state2 <= 1;
                    end else begin
                        if(i == NUM_STOCK_INDEX) begin
                            i <= 0;
                            state2 <= 2;				
                        end else begin
                            state2 <= 0;
                            i <= i + 1;
                        end
                    end
                end else if (state2 == 2) begin
                    state <= 1;			
                    counter <= 0;
                end
            end
    
    
        end else if (state == 1) begin
//            if(counter == 1000) begin
//                if(price_index == 48 - 1) begin
//                    state <= 2;
//                end else begin
//                    state <= 0;
//                    state2 <= 0;
//                    i <= 0;
//                    price_index <= price_index + 1;
//                end
//            end else begin
//                counter <= counter + 1;
//            end
            if(pick_next_r && !pick_next) begin
                if(price_index == 48 - 1) begin
                    state <= 2;
                end else begin
                    state <= 0;
                    state2 <= 0;
                    i <= 0;
                    price_index <= price_index + 1;
                end
            end else begin
                state <= 1;
            end
        end
    end
end
endmodule 