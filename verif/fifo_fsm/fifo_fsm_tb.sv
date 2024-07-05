`timescale 1ns / 1ps

module fifo_fsm_tb;

// 测试模块的参数
parameter CLK_PERIOD = 10; // 时钟周期为10纳秒

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

// 初始化信号
initial start = 0;
// 每隔N个周期产生一个单周期的信号
parameter N = 1000; // 每隔5个时钟周期
integer cycle_count = 0;
always @(posedge clk) begin
    if (cycle_count == N) begin
        start <= 1; // 产生单周期信号
        #(CLK_PERIOD) start <= 0; // 下一个时钟周期结束信号
        cycle_count <= 0; // 重置计数器
    end else if (start == 0) begin
        cycle_count <= cycle_count + 1;
    end
end

// 初始化信号
initial en = 0;
// 每隔N个周期产生一个单周期的信号
parameter N2 = 5000; // 每隔5个时钟周期
integer cycle_count2 = 0;
always @(posedge clk) begin
    if (cycle_count2 == N2) begin
        en <= 1; // 产生单周期信号
        #(CLK_PERIOD) en <= 0; // 下一个时钟周期结束信号
        cycle_count2 <= 0; // 重置计数器
    end else if (en == 0) begin
        cycle_count2 <= cycle_count2 + 1;
    end
end

// 测试模块初始化
initial begin
    // 初始化输入
    clk = 0;
    rstn = 0;
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
    #100;

    
    // 等待发送完成
    #(CLK_PERIOD * 20);
    
    // 停止测试
    #40000000;
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