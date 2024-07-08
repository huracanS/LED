module LED_send #(
    parameter LED_NUM = 4,//LED帧个数：发送LED帧图像的个数.
    parameter WAIT_CNT = 5,//等待时间：发送开始和结束等待的时间.
    parameter DIV_CNT = 5//分频系数: 150M/30M = 5.
)(
    input logic clk,//150M
    input logic rstn,
    
    //控制fifo.
    input logic [23:0] fifo_data_in,//输入的数据 RGB
    output logic rd,//fifo读使能.

    //输入数据使能和数据.
    input logic enable,//发送的数据使能


    //输出信号.
    output logic cko_o,//输出的时钟信号
    output logic sdo//输出的数据信号
);

//>>>>>协议格式:
//1.先发送Start Frame 32bit 0.
//2.发送LED Frame LED_NUM * 32bit (struture:111 bright(5'bxxxxx) BLUE(8'bxxxxxxxx) GREEN(8'bxxxxxxxx) RED(8'bxxxxxxxx))
//3.发送END Frame 32bit 1.
//>>>>>

//>>功能描述:
//1.enable之后进入WAIT_SEND状态.
//2.进入等待状态后，计算当前需要发送的总帧数量,然后等待时间结束且算完了总帧数量，进入SEND状态.
//3.发送完一帧进入给出rd使能，发送下一帧.

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
logic [5:0] bit_cnt;
logic busy; /*synthesis keep*/
logic [4:0] wait_cnt; /*synthesis keep*/
logic [10:0] send_cnt; /*synthesis keep*/
logic [5:0] cnt;
logic cko_p,cko_n;
logic cko;
send_state_t c_state; /*synthesis keep*/
send_state_t n_state; /*synthesis keep*/
//logic SEND_length;
//>>>>>
 assign cko_o = cko && (c_state == SEND || (c_state == SEND_DONE && wait_cnt == 'd0));
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
            if(wait_cnt >= WAIT_CNT && cko_n) begin
                n_state = SEND;
            end else begin
                n_state = WAIT_SEND;
            end
        end

        SEND: begin
            if((send_cnt >= LED_NUM + 2) && (bit_cnt == 'd31) && cko_n) begin//(32bit)Start_frame + Led_frame(LED_NUM * 32bit) + End_frame(32bit). 
                n_state = SEND_DONE;
            end else begin
                n_state = SEND;
            end
        end

        SEND_DONE: begin
            if((wait_cnt >= WAIT_CNT) && cko_n) begin
                n_state = IDLE;
            end else begin
                n_state = SEND_DONE;
            end
        end

        default: begin
            n_state = IDLE;
        end
    endcase
end

//wait_cnt
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        wait_cnt <= 'd0;
    end else if((c_state == SEND || c_state == IDLE) && cko_n) begin
        wait_cnt <= 'd0;
    end else if((c_state == WAIT_SEND || c_state == SEND_DONE) && cko_n) begin //cko_p开始一次计数
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
    end else if((cnt == DIV_CNT * 2 - 1)) begin //0-9
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

//>>>>> 增加功能
//读使能
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        rd <= 'd0;
    end else if(c_state == SEND && cko_n)begin
        if(( send_cnt != LED_NUM + 1 && send_cnt != LED_NUM + 2) && bit_cnt == 'd31)//有头帧和尾帧，不读fifo -2.
            rd <= 1'b1;
        else 
            rd <= 1'b0;
    end else begin
        rd <= 1'b0;
    end
end

logic en;
assign en = rd;

//锁存每一帧的数据.
logic [31:0] frame_reg;
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        frame_reg <= 32'd0;
    end else if(en) begin
        if(send_cnt == 32'd0) //第一帧 0000_0000.
            frame_reg <= 32'h0000_0000;
            //frame_reg <= 32'h5555_5555;
        else 
        // if(send_cnt == LED_NUM + 2)
        //     frame_reg <= 32'hffff_ffff;
        // else
            //frame_reg <= 32'h5555_5555;
            frame_reg <= {8'hff,fifo_data_in};
    end 
    else if(send_cnt == LED_NUM + 2)
        frame_reg <= 32'hffff_ffff;
    else begin
        frame_reg <= frame_reg;
    end
end

logic send_vld;//发送vld.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        send_vld <= 1'b0;
        sdo <= 1'b1;
    end else if(c_state != SEND) begin
        send_vld <= 1'b0;
        sdo <= 1'b1;
    end else if( ((c_state == WAIT_SEND && n_state == SEND) || c_state == SEND) && cko_n) begin
        if((send_cnt == LED_NUM + 2) && bit_cnt == 'd31) begin
            send_vld <= 1'b0;
            sdo <= 1'b1;
        end else begin
            send_vld <= 1'b1;
            sdo <= frame_reg[ 31 - bit_cnt];
            $display("Sending data:frame_reg = %h, sdo = %b, send_cnt = %d ,bit_cnt = %d",frame_reg, frame_reg[ 31 - bit_cnt], send_cnt,31 - bit_cnt);
        end
    end
end
//>>>>>

//发送数据计数. 计发送的帧数量.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        send_cnt <= 'd0;
    end else if(c_state != SEND) begin
        send_cnt <= 'd0;
    end else if(c_state == SEND && cko_n) begin
            if(bit_cnt < 'd31)
                send_cnt <= send_cnt;
            else begin
                if(send_cnt == LED_NUM + 2)
                    send_cnt <= 'd0;
                else 
                    send_cnt <= send_cnt + 1;
            end
    end else begin
        send_cnt <= send_cnt;
    end
end

//发送数据计数.计发送的bit数.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bit_cnt <= 6'd0;
    end else if(c_state == SEND && cko_n)begin
        if(bit_cnt < 6'd31) 
            bit_cnt <= bit_cnt + 1;
        else 
            bit_cnt <= 6'd0;
    end else begin
        bit_cnt <= bit_cnt;
    end
end

endmodule