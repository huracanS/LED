//单比特快到慢“握手协议”
module cdc_sbit_handshake(
    input 		aclk,	//快时钟
    input 		arst_n,	//快时钟域复位信号
    input 		signal_a,//快时钟域信号
    input 		bclk,	//慢时钟
    input 		brst_n,	//慢时钟域复位信号
    output 		signal_b//慢时钟域输出信号
    );
                             
//慢时钟域信号展宽直至反馈信号回来再恢复
reg   req;//寄存慢时钟域展宽信号
reg   ack_r0;//反馈信号
always@(posedge aclk or negedge arst_n) begin
    if(!arst_n) begin
        req <= 1'b0;
    end
    else if(signal_a) begin
        req <= 1'b1;	//信号展宽
    end
    else if(ack_r0) begin
        req <= 1'b0; 	//反馈信号到来时恢复
    end
end

//展宽信号跨时钟同步至慢时钟域
reg   req_r0;
reg   req_r1; 
reg   req_r2;                          
always@(posedge bclk or negedge brst_n) begin
    if(!brst_n)begin
        {req_r2,req_r1,req_r0} <= 3'b0;
    end
    else begin        
        {req_r2,req_r1,req_r0} <=  {req_r1,req_r0,req};
    end
end

//生成反馈信号并同步至快时钟域
reg   ack;                          
always@(posedge aclk or negedge arst_n) begin
    if(!arst_n) begin
        {ack_r0,ack} <= 2'b0;
    end
    else begin
        {ack_r0,ack} <=  {ack,req_r1}; 
    end
end

//信号上升沿检测，让输出持续一个慢时钟周期
assign signal_b = ~req_r2 & req_r1;

endmodule

