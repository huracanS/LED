module mean_cal (
    input   logic clk,
    input   logic rst_n,
    input   logic data_en,
    input   logic [23:0]  data, 
    output  logic [3:0]  MeanR [15:0],
    output  logic [3:0]  MeanG [15:0],
    output  logic [3:0]  MeanB [15:0], 
    output  logic start_o
);

logic [16:0] SumR [15:0];
logic [16:0] SumG [15:0];
logic [16:0] SumB [15:0];

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