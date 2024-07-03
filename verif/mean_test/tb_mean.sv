`timescale 1ns / 100ps

module tb_mean;

// Parameters
localparam  ROW_LEN = 1080;
localparam  COL_LEN = 1920;
integer  a;
// Inputs
logic clk;
logic rst_n;
logic data_en;
logic [23:0] data;

// Outputs
logic [3:0]  MeanR [7:0];
logic [3:0]  MeanG [7:0];
logic [3:0]  MeanB [7:0];
logic start_o;
logic [95:0] Mean;
genvar i;
generate
    for(i=0;i<8;i=i+1)begin
        assign Mean[i*12+11:i*12] = {MeanR[i],MeanG[i],MeanB[i]}; 
    end
endgenerate

// 实例化被测试模块
mean_cal uut (
    .clk(clk),
    .rst_n(rst_n),
    .data_en(data_en),
    .data(data),
    .MeanR(MeanR),
    .MeanG(MeanG),
    .MeanB(MeanB),
    .start_o(start_o)
);

// 时钟生成
always #(6.6667/2) clk = ~clk;  // 产生150MHz的时钟信号

initial begin
    // 初始化输入
    clk     = 0;
    rst_n    = 0;
    data_en = 0;
    data    = 24'h3399DD;
    
    // 等待几个时钟周期以应用复位
    #100;
    rst_n = 1;  // 释放复位
    #200 data_en <= 1'b1;
    repeat(2*ROW_LEN*COL_LEN+2000)begin
        @(posedge clk)begin
            a = a;
        end
    end
    // 结束仿真
    $finish;
end

endmodule