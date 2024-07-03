`timescale 1ns / 1ps

module tb_LED_send;

// Parameters
localparam LED_NUM = 4;
localparam WAIT_CNT = 5;

// Inputs
logic clk;
logic rstn;
logic enable;
logic [23:0] fifo_data_in;
logic [127:0] data_in;

// Outputs
logic cko;
logic sdo;

// 实例化被测试模块
LED_send uut (
    .clk(clk),
    .rstn(rstn),
    .enable(enable),
    .data_in(data_in),
    .fifo_data_in(fifo_data_in),
    .cko_o(cko),
    .sdo(sdo)
);

// 时钟生成
//always #10 clk = ~clk;  // 产生100MHz的时钟信号
always #(6.6667/2) clk = ~clk;  // 产生150MHz的时钟信号

initial begin
    // 初始化输入
    clk = 0;
    rstn = 0;
    enable = 0;
    data_in = 128'h0;
    
    // 等待几个时钟周期以应用复位
    #100;
    rstn = 1;  // 释放复位
    
    // 测试不同的数据和使能情况
    #100 enable = 1;  // 使能数据发送
    //data_in = 128'h12345678_9ABCDEF0;  // 赋予数据
    data_in = 128'h5555_5555_5555_5555_5555_5555_5555_5555;
    fifo_data_in = 24'h55_5555;
    #100 
    enable = 0; //使能数据关闭
    data_in = 128'h0;
    #1000;  // 等待一段时间以观察输出
    
    enable = 0;  // 禁用数据发送
    data_in = 128'h0;
    #70000;  // 再次等待一段时间以观察输出
    
    // 结束仿真
    $finish;
end

endmodule