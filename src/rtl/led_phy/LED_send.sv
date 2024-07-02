module LED_send #(
    parameter LED_NUM = 4,//LED帧个数：发送LED帧图像的个数.
    parameter WAIT_CNT = 5,//等待时间：发送开始和结束等待的时间.
    parameter DIV_CNT = 5//分频系数: 150M/30M = 5.
)(
    input logic clk,//150M
    input logic rstn,
    
    //输入数据使能和数据.
    input logic enable,//发送的数据使能
    input logic [127:0] data_in,//发送的数据

    //输出信号.
    output logic cko,//输出的时钟信号
    output logic sdo//输出的数据信号
);

//>>>>>协议格式:
//1.先发送Start Frame 32bit 0.
//2.发送LED Frame LED_NUM * 32bit (struture:111 bright(5'bxxxxx) BLUE(8'bxxxxxxxx) GREEN(8'bxxxxxxxx) RED(8'bxxxxxxxx))
//3.发送END Frame 32bit 1.
//>>>>>

//>>>>>状态信号定义
//状态定义
typedef enum logic[3:0]
{
    IDLE, //空闲状态.
    WAIT_SEND, //等待发送状态.
    SEND, //发送状态
    SEND_DONE // 发送完成，等待时间进入空闲.
}send_state_t;
//信号定义.
logic busy; /*synthesis keep*/
logic done;//发送完成
logic [4:0] wait_cnt; /*synthesis keep*/
logic [10:0] send_cnt; /*synthesis keep*/
logic [5:0] cnt;
logic cko_p,cko_n;
send_state_t c_state; /*synthesis keep*/
send_state_t n_state; /*synthesis keep*/
//logic SEND_length;
//>>>>>

//>>>>>
//标志信号.
//busy标志位.
assign busy = c_state != IDLE;

//>>>>>状态机
//状态转移.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end

//状态产生
always @(*) begin
    case(c_state)
        IDLE: begin
            if(!busy && enable) begin //模块不忙且有使能的时候,进入WAIT_SEND状态.
                n_state = WAIT_SEND;
            end else begin
                n_state = IDLE;
            end
        end

        WAIT_SEND: begin
            if(wait_cnt <= WAIT_CNT && cac_done) begin
                n_state = WAIT_SEND;
            end else begin
                n_state = SEND;
            end
        end

        SEND: begin
            if(send_cnt < cac_result ) begin//(32bit)Start_frame + Led_frame(LED_NUM * 32bit) + End_frame(32bit). 
                n_state = SEND;
            end else begin
                n_state = SEND_DONE;
            end
        end

        SEND_DONE: begin
            if(wait_cnt <= WAIT_CNT) begin
                n_state = SEND_DONE;
            end else begin
                n_state = IDLE;
            end
        end

        default: begin
            n_state = IDLE;
        end
    endcase
end

//WAIT_SEND流水线计算发送数量:
// logic [10:0] send_length;
// logic [10:0] send_c0;
// logic [10:0] send_c1;
// logic [10:0] send_c2;
// logic cac_done;
// assign SEND_length = (1 + LED_NUM + 1)*32;


// always @(posedge clk or negedge rstn) begin
//     if(!rstn) begin
//         send_c0 <= 'd0;
//     end else if(!cac_done)begin
//         send_c0 <= (1 + LED_NUM + 1);
//         send_c1 <= send_c0 * 32;
//     end else begin

//     end
// end

//wait_cnt
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        wait_cnt <= 'd0;
    end else if(c_state == SEND || c_state == IDLE) begin
        wait_cnt <= 'd0;
    end else if((c_state == WAIT_SEND || c_state == SEND_DONE) && cko_p) begin //cko_p开始一次计数
        wait_cnt <= wait_cnt + 1;
    end
end

//>>>>>输出时钟

// 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6  
// 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1
//         1                   1               上升沿
//分频计数
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cnt <= 6'd0;
    end else if(cnt == DIV_CNT * 2 - 1) begin //0-9
        cnt <= 6'd0;
    end else begin
        cnt <= cnt + 1;
    end 
end
//输出ck.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cko <= 1'b0;
    end else if( (cnt == (DIV_CNT - 1)) || (cnt == (DIV_CNT * 2 - 1)) ) begin //4 
        cko <= ~cko;
    end else begin
        cko <= cko;
    end
end
//产生上升沿
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cko_p <= 1'b0;
    end else if(cnt == (DIV_CNT - 1) - 1) begin //3 
        cko_p <= 1'b1;
    end else begin
        cko_p <= 1'b0;
    end
end
//产生下降沿
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cko_n <= 1'b0;
    end else if(cnt == ((DIV_CNT * 2) - 1) - 1) begin //8
        cko_n <= 1'b1;
    end else begin
        cko_n <= 1'b0;
    end
end
//>>>>>

//>>>>>发送数据
//锁存数据
logic [(1+LED_NUM+1)*32-1:0] data_reg;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        data_reg <= 'd0;
    end else if(c_state == IDLE && !busy && enable) begin
        data_reg <= {32'h00000000,data_in,32'hffffffff};
    end else begin
        data_reg <= data_reg;
    end
end

//发送数据计数.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        send_cnt <= 'd0;
    end else if(c_state != SEND) begin
        send_cnt <= 'd0;
    end else if(c_state == SEND && cko_n) begin
        send_cnt <= send_cnt + 1;
    end else begin
        send_cnt <= send_cnt;
    end
end

//发送数据.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        sdo <= 1'b1;
    end else if(c_state != SEND) begin
        sdo <= 1'b1;
    end else if(c_state == SEND && cko_n) begin
        //sdo <= data_reg[( (1 + LED_NUM + 1)*32 -1) - send_cnt];
        sdo <= data_reg[( cac_result -1) - send_cnt];
        //$display("Sending data: sdo = %b, send_cnt = %d", data_reg[((1 + LED_NUM + 1)*32-1) - send_cnt], ((1 + LED_NUM + 1)*32-1) - send_cnt);
    end
end


//多步计算乘法结果,优化时序
logic cac_done;//计算完成.
logic [9:0] cac_result;//计算的结果最大1024.
multi_cycle_calculator u_multi_cycle_calculator(
    .clk(clk),          // 时钟信号
    .rst_n(rstn),        // 复位信号（低电平有效）
    .led_num(LED_NUM),// 输入LED的frame数量,这里假设最大32.
    .done(cac_done),         // 计算完成.
    .result(cac_result)  // 最大1024.
);

endmodule