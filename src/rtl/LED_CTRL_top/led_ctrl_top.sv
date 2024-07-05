module led_ctrl_top(
    input logic clk_fast,
    input logic clk_slow,
    input logic rstn,

    //cpu 
    input logic en,//发送的中断信号
    
    //main_cac
    input logic start,//开始传输信号.
    input  logic [3:0]  MeanR [7:0], //8分区的总共R像素 8bit
    input  logic [3:0]  MeanG [7:0], //8分区的总共G像素 8bit
    input  logic [3:0]  MeanB [7:0] //8分区的总共B像素 8bit
);


//----------fifo_fsm-----------------------------------------------
// 功能:外部中断给出en后进入等待传输有效Frame数据的状态，如果main_cac模块给出传输信号，将数据存入fifo中.
logic we;
logic [11:0] fifo_data_in;
logic send_start;
logic rd;
logic [11:0] fifo_data_out;
fifo_fsm #(
//发送灯带分区帧格式
    .FRAME_N7_front  (4),
    .FRAME_N6        (4),
    .FRAME_N5_front  (4),
    .FRAME_N3        (4),
    .FRAME_N0_front  (1),
    .FRAME_N0_back   (4),
    .FRAME_N1        (4),
    .FRAME_N2_front  (4),
    .FRAME_N2_back   (1),
    .FRAME_N4        (4),
    .FRAME_N7        (1)
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
    .empty_flag(),
    .afull     ()
);
//----------------------------------------------------------------

//-----------LED_SEND---------------------------------------------
logic cko_o;
LED_send u_LED_send(
    .clk (clk_slow),//150M
    .rstn(rstn),
    
    //控制fifo.
    .fifo_data_in({fifo_data_out[11:8],4'b1111,fifo_data_out[7:4],4'b1111,fifo_data_out[3:0],4'b1111}),//输入的数据 RGB
    .rd          (rd),//fifo读使能.
    .sdo_2       (),//输出的数据信号测试

    //输入数据使能和数据.
    .enable(send_start_sync),//发送的数据使能
    .data_in('d0),//发送的数据

    //输出信号.
    .cko_o(cko_o),//输出的时钟信号
    .sdo()//输出的数据信号
);
//----------------------------------------------------------------


endmodule