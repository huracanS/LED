`timescale 1ns / 1ps

module fifo_fsm_tb;

// 测试模块的参数
parameter CLK_PERIOD = 20; // 时钟周期为5纳秒

// 测试模块的输入和输出
reg clk;
reg rstn;
reg en;
reg start;
logic [3:0] MeanR [7:0];
logic [3:0] MeanG [7:0];
logic [3:0] MeanB [7:0];

// 实例化被测试模块
fifo_fsm uut (
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .start(start),
    .MeanR(MeanR),
    .MeanG(MeanG),
    .MeanB(MeanB),
    .we(we),
    .fifo_data(fifo_data),
    .send_start(send_start)
);

// 时钟生成
initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk; // 产生时钟信号
end

// 测试模块初始化
initial begin
    // 初始化输入
    clk = 0;
    rstn = 0;
    en = 0;
    start = 0;
    MeanR = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};
    MeanG = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};
    MeanB = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};
    // 初始化MeanR, MeanG, MeanB为固定值
    // integer i;
    // for (i = 0; i < 8; i = i + 1) begin
    //     MeanR[i] = i; // R通道的值从0递增
    //     MeanG[i] = 8 - i; // G通道的值从7递减
    //     MeanB[i] = 15 - 2 * i; // B通道的值从15递减，步长为2
    // end
    
    // 等待时钟稳定
    #100;
    
    // 使能复位
    rstn = 1;
    
    // 等待几个时钟周期
    #(CLK_PERIOD * 5);
    
    // 使能FIFO功能
    en = 1;
    
    // 触发开始传输
    #(CLK_PERIOD * 5) start = 1;
    
    // 等待发送完成
    #(CLK_PERIOD * 20);
    
    // 停止测试
    #40000;
    $finish;
end

// initial begin
//     integer i;
//     for (i = 0; i < 8; i = i + 1) begin
//         MeanR[i] = i; // R通道的值从0递增
//         MeanG[i] = 8 - i; // G通道的值从7递减
//         MeanB[i] = 15 - 2 * i; // B通道的值从15递减，步长为2
//     end
// end
// 观察输出
// initial begin
//     $monitor("Time = %t, we = %b, fifo_data = %b, send_start = %b", $time, we, fifo_data, send_start);
// end

endmodule