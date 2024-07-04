//另一种写法是状态机法
module hsyncfifo_ahead512x24(
    input               clk,
    input               rst,
    input               we,
    input   [23:0]      di,
    input               re,
    output  [23:0]      dout,
    output  reg         valid,
    output              full_flag,
    output              empty_flag,
    output  wire        aempty,
    output  wire        afull
);
wire    re_tmp;
wire    empty_tmp;
//////////////////////////////////////////////
hsyncfifo_512x24 u_hsyncfifo_512x24
(
    .rst         (  rst        ),   
    .clk         (  clk        ),      
    .we          (  we         ),
    .di          (  di         ),
    .re          (  re_tmp     ),
    .do          (  dout       ),  
    .full_flag   (  full_flag  ),
    .empty_flag  (  empty_tmp  ),
    .afull_flag  (  afull      ),
    .aempty_flag (  aempty     )
);
//////////////////////////////////////////////
assign  empty_flag = ~valid;
assign  re_tmp = (!empty_tmp && re) | (!empty_tmp && !re && !valid);//从实体fifo中读的情况1.预读取2.正常读
always@(posedge clk,posedge rst)begin
    if(rst)begin
        valid <= 1'b0;
    end
    else if(re_tmp)begin//从实体FIFO中读，数据进入valid寄存器
        valid <= 1'b1;
    end
    else if(valid && re && empty_tmp)begin//从valid读，不从实体FIFO读，因为实体FIFO空了
        valid <= 1'b0;
    end
    else begin
        valid <= valid;
    end
end
endmodule