`define TEST_PATTERN 1//1:测试PATTERN1 2:测试PATTERN2.

module fpga_ed4g(
    input logic sysclk_i,//系统时钟: 25M.
    
    //输出信号.
    output logic cko, /*synthesis keep*/
    output logic sdo /*synthesis keep*/
);

//>>>信号定义
//1.复位电路
logic  [28:0]	rst_cnt=0;
//2.PLL分频电路
logic clk_150m; /*synthesis keep*/
//3.LED驱动电路
logic enable; /*synthesis keep*/
logic [127:0] data_in; /*synthesis keep*/
//>>>

//---------复位电路--------------------------------------------
always @(posedge sysclk_i)begin
	if (rst_cnt[28])//上板
		rst_cnt <=  rst_cnt;
	else
		rst_cnt <=  rst_cnt + 1'b1;
end
//--------------------------------------------------------------

//---------PLL分频电路-----------------------------------------
PLL_150M u_PLL_150M (
  .refclk(sysclk_i),//sysclk_i
  .reset(!rst_cnt[28]),
  .extlock(lock),
  .clk0_out(clk_150m)//LED驱动电路. 
);
//--------------------------------------------------------------

//---------LED驱动输出电路-------------------------------------
LED_send #(
    .LED_NUM(4),//LED帧个数：发送LED帧图像的个数.
    .WAIT_CNT(5),//等待时间：发送开始和结束等待的时间.
    .DIV_CNT(5)//分频系数: 150M/30M = 5.
) u_LED_send(
    .clk(clk_150m),//时钟150M
    .rstn(lock),
    
    //输入数据使能和数据.
    .enable(enable),//发送的数据使能
    //.data_in(data_in),//发送的数据
    .data_in(data_in),//发送的数据 测试PATTERN 1 

    //输出信号.
    .cko(cko),//输出的时钟信号
    .sdo(sdo)//输出的数据信号
);
//--------------------------------------------------------------

//----测试PATTERN
test_pattern u_test_pattern( 
    .clk(clk_150m),
    .rstn(lock),

    //输出LED控制信号.
    .enable(enable),
    .data_in(data_in)
);
//-----

endmodule