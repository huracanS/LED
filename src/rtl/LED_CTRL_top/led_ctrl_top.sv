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
logic [11:0] fifo_data;
logic send_start;
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
    .fifo_data (fifo_data),
    .send_start(send_start)//开启物理PHY.
);
//-----------------------------------------------------------------

//----------同步模块-----------------------------------------------
logic send_start_sync;
always @(posedge clk_slow or negedge rstn) begin
    if(!rstn) begin
        send_start_sync <= 1'b0;
    end else begin
        send_start_sync <= send_start;
    end
end
//-----------------------------------------------------------------

//----------异步fifo-----------------------------------------------
logic empty_flag;
hasyncfifo_ahead12 u_hasyncfifo_ahead(
    .clkw      (clk_fast),
    .clkr      (clk_slow),
    .rst       (!rstn),
    .we        (we),
    .di        (fifo_data),
    .re        (),
    .dout      (),
    .valid     (),
    .full_flag (),
    .empty_flag(),
    .afull     ()
);
//----------------------------------------------------------------



endmodule