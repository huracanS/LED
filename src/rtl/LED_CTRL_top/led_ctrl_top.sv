module led_ctrl_top(
    input logic clk_fast,//150M
    input logic clk_slow,//10M
    input logic rstn,

    //cpu 
    input logic en,//发送的中断信号
    
    //main_cac
    input logic start,//开始传输信号.
    input  logic [3:0]  MeanR [15:0], //8分区的总共R像素 8bit
    input  logic [3:0]  MeanG [15:0], //8分区的总共G像素 8bit
    input  logic [3:0]  MeanB [15:0], //8分区的总共B像素 8bit

    output logic cko_o,
    output logic sdo_o
);


//----------fifo_fsm-----------------------------------------------
// 功能:外部中断给出en后进入等待传输有效Frame数据的状态，如果main_cac模块给出传输信号，将数据存入fifo中.
logic we;
logic [11:0] fifo_data_in;
logic send_start;
logic rd; /*synthesis keep*/
logic [11:0] fifo_data_out;/*synthesis keep*/
fifo_fsm #(
//发送灯带分区帧格式
    .FRAME_N15_f      (4),
    .FRAME_N14        (3),
    .FRAME_N13        (3),
    .FRAME_N12        (3),
    .FRAME_N11_f      (3),
    .FRAME_N11_b      (1),
    .FRAME_N9         (2),
    .FRAME_N7         (2),
    .FRAME_N5         (2),
    .FRAME_N0_f       (1),
    .FRAME_N0_b       (3),
    .FRAME_N1         (3),
    .FRAME_N2         (3),
    .FRAME_N3         (3),
    .FRAME_N4_f       (3),
    .FRAME_N4_b       (1),
    .FRAME_N6         (2),
    .FRAME_N8         (2),
    .FRAME_N10        (2),
    .FRAME_N15_b      (1)
) u_fifo_fsm (
    .clk  (clk_fast), 
    .rstn (rstn),

    .en   (en),//中断开启fifo功能.
    .start(start),//main_cac开始传输.
    .MeanR(MeanR), //8分区的总共R像素 8bit
    .MeanG(MeanG), //8分区的总共G像素 8bit
    .MeanB(MeanB), //8分区的总共B像素 8bit

    .we        (we),//输出写FIFO
    .fifo_data (fifo_data_in),
    .send_start(send_start)//开启物理PHY.
);
//-----------------------------------------------------------------

//----------同步模块-----------------------------------------------
logic send_start_sync;
cdc_sbit_handshake u_cdc_sbit_handshake(
    .aclk    (clk_fast)       ,	//快时钟
    .arst_n  (rstn)           ,	//快时钟域复位信号
    .signal_a(send_start)     ,//快时钟域信号
    .bclk    (clk_slow)       ,	//慢时钟
    .brst_n  (rstn)           ,	//慢时钟域复位信号
    .signal_b(send_start_sync)//慢时钟域输出信号
    );
//-----------------------------------------------------------------

//----------异步fifo-----------------------------------------------
logic empty_flag;
hasyncfifo_ahead12to12 u_hasyncfifo_ahead12to12(
    .clkw      (clk_fast),
    .clkr      (clk_slow),
    .rst       (!rstn),
    .we        (we),
    .di        (fifo_data_in),
    .re        (rd),
    .dout      (fifo_data_out),
    .valid     (),
    .full_flag (),
    .empty_flag(empty_flag),
    .afull     ()
);
//----------------------------------------------------------------

//-----------LED_SEND---------------------------------------------
// logic cko_o;
// logic sdo_o;
LED_send #(
    .LED_NUM(47),//LED帧个数：发送LED帧图像的个数.
    .WAIT_CNT(5),//等待时间：发送开始和结束等待的时间, n个cko的周期.
    .DIV_CNT (5)//分频系数: 150M/30M = 5.
) u_LED_send(
    .clk (clk_slow),//150M
    .rstn(rstn),
    
    //控制fifo.
    .fifo_data_in({fifo_data_out[11:8],4'b0000,fifo_data_out[7:4],4'b0000,fifo_data_out[3:0],4'b0000}),//输入的数据 RGB
    .rd          (rd),//fifo读使能.

    //输入数据使能和数据.
    .enable(send_start_sync),//发送的数据使能

    //输出信号.
    .cko_o(cko_o),//输出的时钟信号
    .sdo(sdo_o)//输出的数据信号
);
//----------------------------------------------------------------


endmodule