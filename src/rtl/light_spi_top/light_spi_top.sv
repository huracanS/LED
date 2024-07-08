//debug 可以抓一下fifo full
module light_spi_top(
    input   logic   clk,//150M
    input   logic   spi_send_clk,//10M real clk= send_clk/10
    input   logic   rst_n,
    input   logic   data_en,
    input   logic   [23:0]  data,
    //register interface
    input   logic   EN, // open sk9822 led
    input   logic   update,//erver 20ms pulse
    //sl9822 spi interface
    output  logic   cko,
    output  logic   sdo
);
//signal define
logic start;
logic [3:0]  MeanR_ori [7:0];
logic [3:0]  MeanG_ori [7:0];
logic [3:0]  MeanB_ori [7:0];
genvar i;
generate
    for(i=0;i<8;i=i+1)begin
        MeanR[i] = EN?MeanR_ori:4'b0000;
        MeanG[i] = EN?MeanG_ori:4'b0000;
        MeanB[i] = EN?MeanB_ori:4'b0000;
    end
endgenerate
//-----------mean_cal-----------------
mean_cal u_mean_cal(
    clk         (clk            ),
    rst_n       (rst_n          ),
    data_en     (data_en        ),
    data        (data           ), 
    MeanR       (MeanR_ori      ),
    MeanG       (MeanG_ori      ),
    MeanB       (MeanB_ori      ), 
    start_o     (start          )
);

//-----------led_ctrl-----------------
led_ctrl_top u_led_spi_ctrl(
    .clk_fast   (clk            ),//150M
    .clk_slow   (spi_send_clk   ),//10M
    .rstn       (rst_n          ),
    .en         (update         ),//发送的中断信号
    .start      (start          ),//开始传输信号.
    .MeanR      (MeanR          ), //8分区的总共R像素 8bit
    .MeanG      (MeanG          ), //8分区的总共G像素 8bit
    .MeanB      (MeanB          ), //8分区的总共B像素 8bit
    .cko_o      (cko            ),
    .sdo_o      (sdo            )
);


endmodule