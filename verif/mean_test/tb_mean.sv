`timescale 1ns / 100ps
module tb_mean;

// Parameters
localparam  ROW_LEN = 1080;
localparam  COL_LEN = 1920;
integer  a;
reg tmp;
logic [23:0] data_buffer;
integer  file_in       ; 
integer  file_out      ;
//-----------------------------Inputs-------------------------------
logic clk;
logic rst_n;
logic data_en;
logic [23:0] data;
//--------------------------------------------------------------------


//-----------------------------Outputs------------------------------
logic [3:0]  MeanR [15:0];
logic [3:0]  MeanG [15:0];
logic [3:0]  MeanB [15:0];
logic start_o;
logic [23:0]  Mean0;
logic [23:0]  Mean1;
logic [23:0]  Mean2;
logic [23:0]  Mean3;
logic [23:0]  Mean4;
logic [23:0]  Mean5;
logic [23:0]  Mean6;
logic [23:0]  Mean7;
logic [23:0]  Mean8;
logic [23:0]  Mean9;
logic [23:0]  Mean10;
logic [23:0]  Mean11;
logic [23:0]  Mean12;
logic [23:0]  Mean13;
logic [23:0]  Mean14;
logic [23:0]  Mean15;
assign Mean0  = {MeanR[0 ],4'b1111,MeanG[0 ],4'b1111,MeanB[0 ],4'b1111};
assign Mean1  = {MeanR[1 ],4'b1111,MeanG[1 ],4'b1111,MeanB[1 ],4'b1111};
assign Mean2  = {MeanR[2 ],4'b1111,MeanG[2 ],4'b1111,MeanB[2 ],4'b1111};
assign Mean3  = {MeanR[3 ],4'b1111,MeanG[3 ],4'b1111,MeanB[3 ],4'b1111};
assign Mean4  = {MeanR[4 ],4'b1111,MeanG[4 ],4'b1111,MeanB[4 ],4'b1111};
assign Mean5  = {MeanR[5 ],4'b1111,MeanG[5 ],4'b1111,MeanB[5 ],4'b1111};
assign Mean6  = {MeanR[6 ],4'b1111,MeanG[6 ],4'b1111,MeanB[6 ],4'b1111};
assign Mean7  = {MeanR[7 ],4'b1111,MeanG[7 ],4'b1111,MeanB[7 ],4'b1111};
assign Mean8  = {MeanR[8 ],4'b1111,MeanG[8 ],4'b1111,MeanB[8 ],4'b1111};
assign Mean9  = {MeanR[9 ],4'b1111,MeanG[9 ],4'b1111,MeanB[9 ],4'b1111};
assign Mean10 = {MeanR[10],4'b1111,MeanG[10],4'b1111,MeanB[10],4'b1111};
assign Mean11 = {MeanR[11],4'b1111,MeanG[11],4'b1111,MeanB[11],4'b1111};
assign Mean12 = {MeanR[12],4'b1111,MeanG[12],4'b1111,MeanB[12],4'b1111};
assign Mean13 = {MeanR[13],4'b1111,MeanG[13],4'b1111,MeanB[13],4'b1111};
assign Mean14 = {MeanR[14],4'b1111,MeanG[14],4'b1111,MeanB[14],4'b1111};
assign Mean15 = {MeanR[15],4'b1111,MeanG[15],4'b1111,MeanB[15],4'b1111}; 
//--------------------------------------------------------------------

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
always #(13.33/2) clk = ~clk;  // 产生75MHz的时钟信号

initial begin
    // 初始化输入
    clk      <= 0;
    rst_n    <= 0;
    data_en  <= 0;
    data     <= 24'h0;

    file_in = $fopen("../../software_sim/output/img.bin", "rb"); //读取RGB图像（bin格式）
    file_out = $fopen("../../software_sim/output/rtl_rgb_means.bin", "wb"); // 输出
    if (file_in == 0 || file_out == 0) begin
        $display("Error: Unable to open file.");
        $finish;
    end
    // 等待几个时钟周期以应用复位
    #100;
    rst_n = 1;  // 释放复位
    forever begin
        @(posedge clk)begin
            tmp = $random;
            if(tmp)begin
                if (!$feof(file_in)) begin
                    a=$fread(data_buffer, file_in);
                    data    <= data_buffer;
                    data_en <= 1'b1;
                end
                else begin
                    data_en <= 1'b0;
                    break;
                end                
            end
            else begin
                data_en <= 1'b0;
            end


            if(start_o == 1)begin
                $fwrite(file_out, "%c%c%c", Mean0 [23:16], Mean0 [15:8], Mean0 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean1 [23:16], Mean1 [15:8], Mean1 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean2 [23:16], Mean2 [15:8], Mean2 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean3 [23:16], Mean3 [15:8], Mean3 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean4 [23:16], Mean4 [15:8], Mean4 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean5 [23:16], Mean5 [15:8], Mean5 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean6 [23:16], Mean6 [15:8], Mean6 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean7 [23:16], Mean7 [15:8], Mean7 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean8 [23:16], Mean8 [15:8], Mean8 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean9 [23:16], Mean9 [15:8], Mean9 [7:0]);
                $fwrite(file_out, "%c%c%c", Mean10[23:16], Mean10[15:8], Mean10[7:0]);
                $fwrite(file_out, "%c%c%c", Mean11[23:16], Mean11[15:8], Mean11[7:0]);
                $fwrite(file_out, "%c%c%c", Mean12[23:16], Mean12[15:8], Mean12[7:0]);
                $fwrite(file_out, "%c%c%c", Mean13[23:16], Mean13[15:8], Mean13[7:0]);
                $fwrite(file_out, "%c%c%c", Mean14[23:16], Mean14[15:8], Mean14[7:0]);
                $fwrite(file_out, "%c%c%c", Mean15[23:16], Mean15[15:8], Mean15[7:0]);
            end
        end
    end
    repeat(2000)begin
        @(posedge clk)begin
            a=a;
        end
    end
    // 结束仿真
    $finish;
end

endmodule