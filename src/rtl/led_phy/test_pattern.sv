module test_pattern(
    input logic clk,
    input logic rstn,

    //输出LED控制信号.
    output logic enable,
    output logic [127:0] data_in
);
logic [18:0] cnt_time;


//----测试PATTERN

`ifdef TEST_PATTERN
//测试组件:计时模块

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cnt_time <= 'd0;
    end else if(cnt_time == 18'd25000) begin//10us: 25M Sysclk_i一个系统周期40ns,10ms = 40ns x 25000
        cnt_time <= 'd0;
    end else begin
        cnt_time <= cnt_time;
    end
end

//----测试PATTERN 1
//1.data_in不变，enable循环拉起控制:
//检测步骤:
//  1.enable间隔N个周期拉起，这里建议进行计时时间10us.
//  2.看LED输出是否一致.
//检测要点:
`elsif TEST_PATTERN == 1
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        enable <= 1'b0;
    end else if(cnt_time == 18'd25000) begin // 10us进行一次拉高
        enable <= 1'b1;
    end else begin
        enable <= 1'b0;
    end
end

assign data_in = 128'h5555_5555_5555_5555_5555_5555_5555_5555;//输出固定 用于测试波形.
//assign data_in = 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;//输出固定 用于上板灯亮度.

//2.enable、data循环变化:
`elsif TEST_PATTERN == 2


`endif


endmodule