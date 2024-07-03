module mean_cal (
    input   logic clk,
    input   logic rst_n,
    input   logic data_en,
    input   logic [23:0]  data, 
    output  logic [3:0]  MeanR [7:0],
    output  logic [3:0]  MeanG [7:0],
    output  logic [3:0]  MeanB [7:0], 
    output  logic start_o
);
logic [20:0] dbg_R;

logic [20:0] SumR [7:0];
logic [20:0] SumG [7:0];
logic [20:0] SumB [7:0];
assign dbg_R = SumR[0];
logic start_i;
square_adder u_sa(
    .clk    (clk    ),    
    .rst_n  (rst_n  ),     
    .data_en(data_en),    
    .data   (data   ),    
    .SumR   (SumR   ),    
    .SumG   (SumG   ),    
    .SumB   (SumB   ),    
    .start  (start_i)   
);

square_shift u_ss(
    .clk    (clk    ),     
    .rst_n  (rst_n  ),         
    .SumR   (SumR   ),         
    .SumG   (SumG   ),         
    .SumB   (SumB   ),         
    .start_i(start_i),         
    .MeanR  (MeanR  ),         
    .MeanG  (MeanG  ),         
    .MeanB  (MeanB  ),             
    .start_o(start_o)        
);

endmodule