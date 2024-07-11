`define TEST_PATTERN 1//1:测试PATTERN1 2:测试PATTERN2.

module fpga_ed4g(
    input logic sysclk_i,//系统时钟: 50M.
    
    //输出信号.
    output logic cko, /*synthesis keep*/
    output logic sdo /*synthesis keep*/
);

//>>>信号定义
logic  [28:0]	rst_cnt=0;
logic clk_150m; 
logic clk_10m; /*synthesis keep*/
logic clk_3m; /*synthesis keep*/
logic [3:0]  MeanR [15:0];
logic [3:0]  MeanG [15:0];
logic [3:0]  MeanB [15:0];
logic [191:0] color_pattern; /*synthesis keep*/
logic lock;
logic [27:0] cnt1s;
always@(posedge sysclk_i,negedge lock)begin
	if(!lock)begin
    	cnt1s <= 'd0;
    end
    else if(cnt1s[27]==1)begin
    	cnt1s <= 'd0;
    end
    else begin
    	cnt1s <= cnt1s+1'b1;
    end
end
assign color_pattern = {12'h742,12'h001,12'h645,12'h967,12'ha66,12'h422,12'h312,12'h524,12'hb55,12'h424,12'h634,12'ha67,12'hdcc,12'hddd,12'hdcc,12'hdbb};
// always@(posedge sysclk_i,negedge lock)begin
// 	if(!lock)begin
//     	color_pattern = {12'hfff,12'hf0f,12'h00f,12'h0ff,12'h0f0,12'hff0,12'hfa0,12'h9AA};//白紫蓝青绿黄橙红76543210
//     end
//     else if(cnt1s[27])begin
//     	color_pattern = {color_pattern[47:0],color_pattern[95:48]};
//     end
// end
genvar i;
generate
    for(i=0;i<16;i=i+1)begin:color_gen
        assign MeanB[i] = color_pattern[i*12+:4];
        assign MeanG[i] = color_pattern[i*12+4+:4];
        assign MeanR[i] = color_pattern[i*12+8+:4];     
    end
endgenerate
  
//>>>

//---------复位电路--------------------------------------------
always @(posedge sysclk_i)begin
	if (rst_cnt[25])//上板
		rst_cnt <=  rst_cnt;
	else
		rst_cnt <=  rst_cnt + 1'b1;
end
//--------------------------------------------------------------

//---------PLL分频电路-----------------------------------------
PLL_150M u_PLL_150M (
  .refclk(sysclk_i),//sysclk_i
  .reset(!rst_cnt[25]),
  .extlock(lock),
  .clk0_out(clk_150m),//LED驱动电路. 
  .clk1_out(clk_10m),
  .clk2_out(clk_3m)
);
//--------------------------------------------------------------

//---------LED驱动输出电路-------------------------------------
led_ctrl_top u_ctrl_top(
    .clk_fast   (clk_150m),//150M
    .clk_slow   (clk_10m ),//10M
    .rstn       (lock    ),
    .en         (en      ),//发送的中断信号
    .start      (start   ),//开始传输信号.
    .MeanR      (MeanR   ), //8分区的总共R像素 8bit
    .MeanG      (MeanG   ), //8分区的总共G像素 8bit
    .MeanB      (MeanB   ), //8分区的总共B像素 8bit
    .cko_o      (cko     ),
    .sdo_o      (sdo     )
);
//--------------------------------------------------------------

logic [21:0]start_cnt;
logic [21:0]en_cnt;

always @(posedge clk_150m,negedge lock) begin
    if(!lock)begin
        start_cnt <= 'd0;
        en_cnt    <= 'd0;
    end
    else if(start_cnt >= 'd2070000)begin
        start_cnt<= 'd0;
    end
    else if(en_cnt >= 'd3000000)begin
        en_cnt <= 'd0;
    end
    else begin
        start_cnt <= start_cnt + 1'b1;
        en_cnt <= en_cnt + 1'b1;
    end
end
assign start = (start_cnt == 'd2070000);
assign en    = (en_cnt == 'd3000000);

endmodule