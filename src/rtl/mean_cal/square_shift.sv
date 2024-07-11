module square_shift(
    input   logic clk,
    input   logic rst_n,
    input   logic [16:0] SumR [15:0],
    input   logic [16:0] SumG [15:0],
    input   logic [16:0] SumB [15:0],
    input   logic start_i,
    output  logic [3:0]  MeanR [15:0],
    output  logic [3:0]  MeanG [15:0],
    output  logic [3:0]  MeanB [15:0],    
    output  logic start_o
);
genvar i;
generate for(i=0;i<16;i=i+1)begin
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            MeanR[i] <= 'd0;
            MeanG[i] <= 'd0;
            MeanB[i] <= 'd0;
        end
        else if(start_i) begin
            MeanR[i] <= (SumR[i] >> 13) + (SumR[i] >> 16); 
            MeanG[i] <= (SumG[i] >> 13) + (SumG[i] >> 16);
            MeanB[i] <= (SumB[i] >> 13) + (SumB[i] >> 16);
        end
    end
end
endgenerate
always @(posedge clk,negedge rst_n) begin
    if(~rst_n)begin
        start_o <= 1'b0;
    end
    else begin
        start_o <= start_i;
    end
end
endmodule