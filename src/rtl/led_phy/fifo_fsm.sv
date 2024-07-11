module fifo_fsm #(
//发送灯带分区帧格式
    parameter FRAME_N15_f = 4, 
    parameter FRAME_N14   = 3, 
    parameter FRAME_N13   = 3, 
    parameter FRAME_N12   = 3, 
    parameter FRAME_N11_f = 3, 
    parameter FRAME_N11_b = 1, 
    parameter FRAME_N9    = 2, 
    parameter FRAME_N7    = 2, 
    parameter FRAME_N5    = 2, 
    parameter FRAME_N0_f  = 1, 
    parameter FRAME_N0_b  = 3, 
    parameter FRAME_N1    = 3, 
    parameter FRAME_N2    = 3, 
    parameter FRAME_N3    = 3, 
    parameter FRAME_N4_f  = 3, 
    parameter FRAME_N4_b  = 1, 
    parameter FRAME_N6    = 2, 
    parameter FRAME_N8    = 2, 
    parameter FRAME_N10   = 2, 
    parameter FRAME_N15_b = 1 
)(
    input logic clk,
    input logic rstn,

    input logic en,//中断开启fifo功能.
    input logic start,//main_cac开始传输.
    input  logic [3:0]  MeanR [15:0], //8分区的总共R像素 8bit
    input  logic [3:0]  MeanG [15:0], //8分区的总共G像素 8bit
    input  logic [3:0]  MeanB [15:0], //8分区的总共B像素 8bit

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
logic [3:0] block_choose_real;
logic wr_done;
localparam TOTAL_CNT = 47;
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

//写fifo计数.


always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        wr_cnt <= 'd0;
    end else if(c_state == FIFO_WR) begin
        if (wr_cnt < TOTAL_CNT) begin 
            wr_cnt <= wr_cnt + 1;
        end else begin
            wr_cnt <= 'd0;
        end
    end else begin
        wr_cnt <= 'd0;
    end 
end

assign wr_done = (wr_cnt == TOTAL_CNT) && (c_state == FIFO_WR);

assign fifo_data = {MeanB[block_choose_real],MeanG[block_choose_real],MeanR[block_choose_real]} & {12{c_state == FIFO_WR}};

//选中区块.
logic condition_n0,condition_n1,condition_n2,condition_n3,condition_n4,condition_n5,condition_n6,condition_n7,condition_n8,condition_n9,
      condition_na,condition_nb,condition_nc,condition_nd,condition_ne,condition_nf,condition_ng,condition_nh,condition_ni,condition_nj;
assign condition_n0 =   wr_cnt <  4;                                                   
assign condition_n1 =  (wr_cnt >= 4) &&                                          (wr_cnt < 4+3)                                     ;                                              
assign condition_n2 =  (wr_cnt >= 4+3) &&                                        (wr_cnt < 4+3+3)                                   ;         
assign condition_n3 =  (wr_cnt >= 4+3+3) &&                                      (wr_cnt < 4+3+3+3)                                 ;       
assign condition_n4 =  (wr_cnt >= 4+3+3+3) &&                                    (wr_cnt < 4+3+3+3+3)                               ;                        
assign condition_n5 =  (wr_cnt >= 4+3+3+3+3) &&                                  (wr_cnt < 4+3+3+3+3+1)                             ;   
assign condition_n6 =  (wr_cnt >= 4+3+3+3+3+1) &&                                (wr_cnt < 4+3+3+3+3+1+2)                           ;   
assign condition_n7 =  (wr_cnt >= 4+3+3+3+3+1+2) &&                              (wr_cnt < 4+3+3+3+3+1+2+2)                         ;           
assign condition_n8 =  (wr_cnt >= 4+3+3+3+3+1+2+2) &&                            (wr_cnt < 4+3+3+3+3+1+2+2+2)                       ;       
assign condition_n9 =  (wr_cnt >= 4+3+3+3+3+1+2+2+2) &&                          (wr_cnt < 4+3+3+3+3+1+2+2+2+1)                     ;           
assign condition_na =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1) &&                        (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3)                   ;               
assign condition_nb =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3) &&                      (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3)                 ;                   
assign condition_nc =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3) &&                    (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3)               ;               
assign condition_nd =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3) &&                  (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3)             ;                   
assign condition_ne =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3) &&                (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3)           ;               
assign condition_nf =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3) &&              (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1)         ;               
assign condition_ng =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1) &&            (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2)       ;               
assign condition_nh =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2) &&          (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2+2)     ;       
assign condition_ni =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2+2) &&        (wr_cnt < 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2+2+2)   ;       
assign condition_nj =  (wr_cnt >= 4+3+3+3+3+1+2+2+2+1+3+3+3+3+3+1+2+2+2);         
  

always @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        block_choose <= 4'b0;
    end else begin
        if(condition_n0) //0-3 FRAME_N7_front
            block_choose <= 4'd15;
        else if(condition_n1) //4-7 FRAME_N6
            block_choose <= 4'd14;
        else if(condition_n2)//8-11 FRAME_N5_front
            block_choose <= 4'd13;
        else if(condition_n3)//8-11 FRAME_N5_front
            block_choose <= 4'd12;
        else if(condition_n4) //12-15 FRAME_N3
            block_choose <= 4'd11;
        else if(condition_n5) //16 FRAME_N0_front
            block_choose <= 4'd11;
        else if(condition_n6) //17-20 FRAME_N0_back
            block_choose <= 4'd9;
        else if(condition_n7) //FRAME_N1
            block_choose <= 4'd7;
        else if(condition_n8) //FRAME_N2_front
            block_choose <= 4'd5;
        else if(condition_n9) //FRAME_N2_back
            block_choose <= 4'd0;
        else if(condition_na) //FRAME_N4
            block_choose <= 4'd0;
        else if(condition_nb) //FRAME_N7
            block_choose <= 4'd1;
        else if(condition_nc) //FRAME_N7
            block_choose <= 4'd2;
        else if(condition_nd) //FRAME_N7
            block_choose <= 4'd3;
        else if(condition_ne) //FRAME_N7
            block_choose <= 4'd4;
        else if(condition_nf) //FRAME_N7
            block_choose <= 4'd4;    
        else if(condition_ng) //FRAME_N7
            block_choose <= 4'd6; 
        else if(condition_nh) //FRAME_N7
            block_choose <= 4'd8; 
        else if(condition_ni) //FRAME_N7
            block_choose <= 4'd10; 
        else if(condition_nj) //FRAME_N7
            block_choose <= 4'd15;         
        else begin
            block_choose <= 4'b0000;
        end    
    end
end

assign block_choose_real = block_choose & {4{c_state == FIFO_WR}};

endmodule
