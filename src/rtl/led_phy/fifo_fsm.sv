module fifo_fsm #(
//发送灯带分区帧格式
    parameter FRAME_N7_front = 4,
    parameter FRAME_N6       = 4,
    parameter FRAME_N5_front = 4,
    parameter FRAME_N3       = 4,
    parameter FRAME_N0_front = 1,
    parameter FRAME_N0_back  = 4,
    parameter FRAME_N1       = 4,
    parameter FRAME_N2_front = 4,
    parameter FRAME_N2_back  = 1,
    parameter FRAME_N4       = 4,
    parameter FRAME_N7       = 1
)(
    input logic clk,
    input logic rstn,

    input logic en,//中断开启fifo功能.
    input logic start,//main_cac开始传输.
    input  logic [3:0]  MeanR [7:0], //8分区的总共R像素 8bit
    input  logic [3:0]  MeanG [7:0], //8分区的总共G像素 8bit
    input  logic [3:0]  MeanB [7:0], //8分区的总共B像素 8bit

    output logic we,//输出写FIFO
    output logic [11:0] fifo_data,
    output logic send_start//开启物理PHY.
);

//状态定义
typedef enum logic[3:0]
{
    IDLE, //空闲状态.
    WAIT_START, //等待发送状态.
    FIFO_WR, //填充fifo
    SEND // 发送状态
}send_state_t;

send_state_t c_state,n_state ;
logic [3:0] block_choose;
logic wr_done;
parameter TOTAL_CNT = FRAME_N7_front + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front +  FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back + FRAME_N4 + FRAME_N7;
logic [5:0] wr_cnt;

//状态转移
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        c_state <= IDLE;
    end else begin
        c_state <= n_state;
    end
end

//状态生成
always @(*) begin
    case(c_state) 
        IDLE: begin 
            if(en) begin//给中断信号.
                n_state = WAIT_START;
            end else begin
                n_state = IDLE;
            end
        end 
    
        WAIT_START: begin
            if(start) begin
                n_state = FIFO_WR;
            end else begin
                n_state = WAIT_START;
            end
        end

        FIFO_WR: begin
            if(wr_done) begin
                n_state = SEND;
            end else begin
                n_state = FIFO_WR;
            end
        end

        SEND: begin
            n_state = IDLE;
        end

        default: begin
            n_state = IDLE;
        end 
    endcase
end

//send_start
// always @(posedge clk or negedge rstn) begin
//     if(!rstn) begin
//         send_start <= 1'b0;
//     end else if(c_state == SEND) begin
//         send_start <= 1'b1;
//     end else begin
//         send_start <= 1'b0;
//     end
// end
assign send_start = (c_state == SEND) ;

//写fifo使能.
always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        we <= 1'b0;
    end else if(c_state == FIFO_WR && wr_cnt < TOTAL_CNT)begin
        we <= 1'b1;
    end else begin
        we <= 1'b0;
    end
end
//assign we = c_state == FIFO_WR;

//写fifo计数.


always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        wr_cnt <= 'd0;
    end else if(c_state == FIFO_WR) begin
        if (wr_cnt < TOTAL_CNT) begin 
            wr_cnt <= wr_cnt + 1;
        end else begin
            wr_cnt <= wr_cnt;
        end
    end else begin
        wr_cnt <= 'd0;
    end
end

assign wr_done = (wr_cnt == TOTAL_CNT) && (c_state == FIFO_WR);

//
// always @(posedge clk or negedge rstn) begin
//     if(!rstn) begin
//         fifo_data <= 12'b0;
//     end else if(c_state == FIFO_WR)begin
//         fifo_data <= {MeanR[block_choose],MeanG[block_choose],MeanB[block_choose]};
//     end else begin
//         fifo_data <= fifo_data;
//     end
// end
assign fifo_data = {MeanR[block_choose],MeanG[block_choose],MeanB[block_choose]};
//选中区块.

logic condition_n0,condition_n1,condition_n2,condition_n3,condition_n4,condition_n5,condition_n6,condition_n7,condition_n8,condition_n9,condition_na;
assign condition_n0 = wr_cnt < (FRAME_N7_front + 1 - 1);
assign condition_n1 =  (wr_cnt >= (FRAME_N7_front + 1 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 - 1)) ;
assign condition_n2 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front - 1)) ;
assign condition_n3 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 - 1)) ;
assign condition_n4 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front - 1)) ;
assign condition_n5 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back - 1)) ;
assign condition_n6 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 - 1)) ;
assign condition_n7 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front - 1)) ;
assign condition_n8 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back - 1)) ;
assign condition_n9 =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back + FRAME_N4 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back + FRAME_N4 - 1)) ;
assign condition_na =  (wr_cnt >= (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back + FRAME_N4 + FRAME_N7 - 1)) && (wr_cnt < (FRAME_N7_front + 1 + FRAME_N6 + FRAME_N5_front + FRAME_N3 + FRAME_N0_front + FRAME_N0_back + FRAME_N1 + FRAME_N2_front + FRAME_N2_back + FRAME_N4 + FRAME_N7 - 1)) ;

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        block_choose <= 4'b0;
    end else begin
        if(condition_n0) //0-3 FRAME_N7_front
            block_choose <= 4'h7;
        else if(condition_n1) //4-7 FRAME_N6
            block_choose <= 4'h6;
        else if(condition_n2)//8-11 FRAME_N5_front
            block_choose <= 4'h5;
        else if(condition_n3) //12-15 FRAME_N3
            block_choose <= 4'h3;
        else if(condition_n4) //16 FRAME_N0_front
            block_choose <= 4'h0;
        else if(condition_n5) //17-20 FRAME_N0_back
            block_choose <= 4'h0;
        else if(condition_n6) //FRAME_N1
            block_choose <= 4'h1;
        else if(condition_n7) //FRAME_N2_front
            block_choose <= 4'h2;
        else if(condition_n8) //FRAME_N2_back
            block_choose <= 4'h2;
        else if(condition_n9) //FRAME_N4
            block_choose <= 4'h3;
        else if(condition_na) //FRAME_N7
            block_choose <= 4'h7;
        else begin
            block_choose <= 4'b0;
        end    
    end
end
endmodule
