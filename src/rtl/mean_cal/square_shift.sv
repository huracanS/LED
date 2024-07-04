module square_shift(
    input   logic clk,
    input   logic rst_n,
    input   logic [20:0] SumR [7:0],
    input   logic [20:0] SumG [7:0],
    input   logic [20:0] SumB [7:0],
    input   logic start_i,
    output  logic [3:0]  MeanR [7:0],
    output  logic [3:0]  MeanG [7:0],
    output  logic [3:0]  MeanB [7:0],    
    output  logic start_o
);
genvar i;
generate for(i=0;i<8;i=i+1)begin
    always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            MeanR[i] <= 'd0;
            MeanG[i] <= 'd0;
            MeanB[i] <= 'd0;
        end
        else if(start_i) begin
            MeanR[i] <= SumR[i][20]?'hF:SumR[i] >> 16;
            MeanG[i] <= SumG[i][20]?'hF:SumG[i] >> 16;
            MeanB[i] <= SumB[i][20]?'hF:SumB[i] >> 16;
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