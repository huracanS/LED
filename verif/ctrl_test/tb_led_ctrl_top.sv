`timescale 1ns / 1ps

module tb_led_ctrl_top;

// Parameters
localparam CLK_FAST_PERIOD = 6; // 假设clk_fast为250MHz
localparam CLK_SLOW_PERIOD = 20; // 假设clk_slow为50MHz

// Inputs
logic clk_fast;
logic clk_slow;
logic rstn;
logic en;
logic start;
logic [3:0] MeanR [7:0];
logic [3:0] MeanG [7:0];
logic [3:0] MeanB [7:0];

// Outputs
logic we;
logic [11:0] fifo_data_in;
logic send_start;
logic rd;
logic [11:0] fifo_data_out;
logic send_start_sync;
logic empty_flag;
logic cko_o;
logic [7:0] sdo;
glbl glbl();
// 实例化待测试模块
led_ctrl_top uut (
    .clk_fast(clk_fast),
    .clk_slow(clk_slow),
    .rstn(rstn),
    .en(en),
    .start(start),
    .MeanR(MeanR),
    .MeanG(MeanG),
    .MeanB(MeanB)
);



// 时钟生成
always #(CLK_FAST_PERIOD/2) clk_fast = ~clk_fast;
always #(CLK_SLOW_PERIOD/2) clk_slow = ~clk_slow;

// 初始化信号
initial start = 0;
// 每隔N个周期产生一个单周期的信号
parameter N = 3000; // 每隔5个时钟周期
integer cycle_count = 0;
always @(posedge clk_slow) begin
    if (cycle_count == N) begin
        start <= 1; // 产生单周期信号
        #(CLK_FAST_PERIOD) start <= 0; // 下一个时钟周期结束信号
        cycle_count <= 0; // 重置计数器
    end else if (start == 0) begin
        cycle_count <= cycle_count + 1;
    end
end


// 初始化信号
initial en = 0;
// 每隔N个周期产生一个单周期的信号
parameter N2 = 20000; // 每隔5个时钟周期
integer cycle_count2 = 0;
always @(posedge clk_slow) begin
    if (cycle_count2 == N2) begin
        en <= 1; // 产生单周期信号
        #(CLK_FAST_PERIOD) en <= 0; // 下一个时钟周期结束信号
        cycle_count2 <= 0; // 重置计数器
    end else if (en == 0) begin
        cycle_count2 <= cycle_count2 + 1;
    end
end

// 测试序列
initial begin
    // 初始化输入
    clk_fast = 0;
    clk_slow = 0;
    rstn = 0;
    MeanR = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};
    MeanG = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};
    MeanB = {4'h8,4'h7,4'h6,4'h5,4'h4,4'h3,4'h2,4'h1};

    // 复位系统
    #100;
    rstn = 1;

    // 检查输出
    #2000000;
    $display("Test completed.");
    $finish;
end

endmodule