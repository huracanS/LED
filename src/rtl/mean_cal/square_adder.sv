module square_adder(
    input   logic clk,
    input   logic rst_n,
    input   logic data_en,
    input   logic [23:0]  data,
    output  logic [16:0] SumR [15:0],
    output  logic [16:0] SumG [15:0],
    output  logic [16:0] SumB [15:0],
    output  logic start
);
//380*20=7600 ~= 8192 = 2^13
localparam  ROW_LEN = 1080;
localparam  COL_LEN = 1920;
logic [3:0] Rin,Gin,Bin;
logic [10:0] row_cnt;
logic [10:0] col_cnt;
logic [15:0]  mean_aera;
assign  Rin = data[23:20];
assign  Gin = data[15:12];
assign  Bin = data[ 7:4 ];
//------------position calculate------------------
always @(posedge clk,negedge rst_n)begin
    if(~rst_n)begin
        row_cnt<= 'd0;
        col_cnt<= 'd0;
    end
    else if(data_en)begin
        if(row_cnt == (ROW_LEN -1)) begin
            if(col_cnt == (COL_LEN -1)) begin
                row_cnt<= 'd0;
                col_cnt<= 'd0;
            end
            else begin
                row_cnt<= row_cnt;
                col_cnt<= col_cnt + 1'b1;
            end
        end
        else begin
            if(col_cnt == (COL_LEN -1)) begin
                row_cnt<= row_cnt + 1'b1;
                col_cnt<= 'd0;
            end
            else begin
                row_cnt<= row_cnt;
                col_cnt<= col_cnt + 1'b1;
            end
        end        
    end
end

//----------------aera_calculate----------------------------
assign  mean_aera[0]  = (row_cnt>='d0   ) && (row_cnt<'d20  )&& (col_cnt>='d0   ) && (col_cnt<'d340 );
assign  mean_aera[1]  = (row_cnt>='d0   ) && (row_cnt<'d20  )&& (col_cnt>='d395 ) && (col_cnt<'d735 );
assign  mean_aera[2]  = (row_cnt>='d0   ) && (row_cnt<'d20  )&& (col_cnt>='d790 ) && (col_cnt<'d1130);
assign  mean_aera[3]  = (row_cnt>='d0   ) && (row_cnt<'d20  )&& (col_cnt>='d1185) && (col_cnt<'d1525);
assign  mean_aera[4]  = (row_cnt>='d0   ) && (row_cnt<'d20  )&& (col_cnt>='d1580) && (col_cnt<'d1920);

assign  mean_aera[5]  = (row_cnt>='d25  ) && (row_cnt<'d365 )&& (col_cnt>='d0   ) && (col_cnt<'d20  );
assign  mean_aera[6]  = (row_cnt>='d25  ) && (row_cnt<'d365 )&& (col_cnt>='d1900) && (col_cnt<'d1920);
assign  mean_aera[7]  = (row_cnt>='d370 ) && (row_cnt<'d710 )&& (col_cnt>='d0   ) && (col_cnt<'d20  );
assign  mean_aera[8]  = (row_cnt>='d370 ) && (row_cnt<'d710 )&& (col_cnt>='d1900) && (col_cnt<'d1920);
assign  mean_aera[9]  = (row_cnt>='d715 ) && (row_cnt<'d1055)&& (col_cnt>='d0   ) && (col_cnt<'d20  );
assign  mean_aera[10] = (row_cnt>='d715 ) && (row_cnt<'d1055)&& (col_cnt>='d1900) && (col_cnt<'d1920);

assign  mean_aera[11] = (row_cnt>='d1060) && (row_cnt<'d1080)&& (col_cnt>='d0   ) && (col_cnt<'d340 );
assign  mean_aera[12] = (row_cnt>='d1060) && (row_cnt<'d1080)&& (col_cnt>='d395 ) && (col_cnt<'d735 );
assign  mean_aera[13] = (row_cnt>='d1060) && (row_cnt<'d1080)&& (col_cnt>='d790 ) && (col_cnt<'d1130);
assign  mean_aera[14] = (row_cnt>='d1060) && (row_cnt<'d1080)&& (col_cnt>='d1185) && (col_cnt<'d1525);
assign  mean_aera[15] = (row_cnt>='d1060) && (row_cnt<'d1080)&& (col_cnt>='d1580) && (col_cnt<'d1920);
//---------------add logic----------------------------------
genvar i;
generate 
    for(i=0;i<16;i=i+1)begin
      always @(posedge clk,negedge rst_n) begin
        if(~rst_n)begin
            SumR[i] <= 'd0;
            SumG[i] <= 'd0;
            SumB[i] <= 'd0;
        end
        else if(start)begin
            SumR[i] <= 'd0;
            SumG[i] <= 'd0;
            SumB[i] <= 'd0;            
        end
        else if((mean_aera[i] == 1'b1)&&data_en)begin
            SumR[i] <= SumR[i] + Rin;
            SumG[i] <= SumG[i] + Gin;
            SumB[i] <= SumB[i] + Bin;
        end
    end  
end
endgenerate

//-------------valid logic----------------------------------
assign start =  (row_cnt==(ROW_LEN-1)) && (col_cnt==(COL_LEN-1)) && data_en;
endmodule