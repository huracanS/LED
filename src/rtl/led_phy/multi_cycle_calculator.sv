module multi_cycle_calculator(
    input wire clk,          // 时钟信号
    input wire rst_n,        // 复位信号（低电平有效）
    input wire [4:0] led_num,// 输入LED的frame数量,这里假设最大32.
    output reg done,         // 计算完成.
    output reg [9:0] result  // 最大1024.
);

//状态定义
typedef enum logic[3:0]
{
    IDLE, //空闲状态.
    LOAD_CONSTANT, //导入常量.
    ADD, //加法运算.
    MULTIPLY,// 乘法运算.
    DONE //计算完成
}send_state_t;

// 状态变量
send_state_t state,next_state;

// 临时变量用于中间计算
reg [9:0] temp_result;

// 状态转移逻辑
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// 下一个状态逻辑
always @(*) begin
    case (state)
        IDLE: next_state = LOAD_CONSTANT;
        LOAD_CONSTANT: next_state = ADD;
        ADD: next_state = MULTIPLY;
        MULTIPLY: next_state = DONE;
        DONE: next_state = DONE; // 完成后回到初始状态
        default: next_state = IDLE;
    endcase
end

// 数据路径逻辑
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        temp_result <= 'd0;
        result      <= 'd0;
    end else begin
        case (state)
            LOAD_CONSTANT:begin
                temp_result <= 'd32; // 直接加载常量32
                result      <= 'd0;
            end

            ADD: begin
                // 假设LED_NUM已经在之前的某个时刻被加载到led_num寄存器中
                temp_result <= temp_result + (1 + led_num + 1); // 执行加法操作
                result      = 'd0;
            end

            MULTIPLY: begin
                temp_result = temp_result * 32; // 执行乘法操作
                result = temp_result; // 输出结果
            end

            DONE: begin
                temp_result = 'd0;
                result = result;
            end
            default: begin
                temp_result = 'd0;
                result = 'd0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        done <= 1'b0;
    end else if (state == DONE) begin
        done <= 1'b1;
    end else begin
        done <= done;
    end
end

// // 假设LED_NUM是同步更新的
// always @(posedge clk) begin
//     if (state == IDLE) begin
//         led_num <= /* 从某个地方获取LED_NUM的值 */;
//     end
// end

endmodule