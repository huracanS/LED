// Verilog netlist created by Tang Dynasty v5.6.71036
// Mon Jul  8 17:51:58 2024

`timescale 1ns / 1ps
module hasyncfifo_12to12  // hasyncfifo_ahead12to12.v(14)
  (
  clkr,
  clkw,
  di,
  re,
  rst,
  we,
  aempty_flag,
  afull_flag,
  do,
  empty_flag,
  full_flag
  );

  input clkr;  // hasyncfifo_ahead12to12.v(25)
  input clkw;  // hasyncfifo_ahead12to12.v(24)
  input [11:0] di;  // hasyncfifo_ahead12to12.v(23)
  input re;  // hasyncfifo_ahead12to12.v(25)
  input rst;  // hasyncfifo_ahead12to12.v(22)
  input we;  // hasyncfifo_ahead12to12.v(24)
  output aempty_flag;  // hasyncfifo_ahead12to12.v(28)
  output afull_flag;  // hasyncfifo_ahead12to12.v(29)
  output [11:0] do;  // hasyncfifo_ahead12to12.v(27)
  output empty_flag;  // hasyncfifo_ahead12to12.v(28)
  output full_flag;  // hasyncfifo_ahead12to12.v(29)

  wire empty_flag_syn_2;  // hasyncfifo_ahead12to12.v(28)
  wire full_flag_syn_2;  // hasyncfifo_ahead12to12.v(29)

  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  not empty_flag_syn_1 (empty_flag_syn_2, empty_flag);  // hasyncfifo_ahead12to12.v(28)
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000000000001100000),
    .AEP1(32'b00000000000000000000000001110000),
    .AF(32'b00000000000000000001111110100000),
    .AFM1(32'b00000000000000000001111110010000),
    .ASYNC_RESET_RELEASE("ASYNC"),
    .DATA_WIDTH_A("18"),
    .DATA_WIDTH_B("18"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000010000),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111110000),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("ASYNC"))
    fifo_inst_syn_2 (
    .clkr(clkr),
    .clkw(clkw),
    .csr({2'b11,empty_flag_syn_2}),
    .csw({2'b11,full_flag_syn_2}),
    .dia(di[8:0]),
    .dib({open_n47,open_n48,open_n49,open_n50,open_n51,open_n52,di[11:9]}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .aempty_flag(aempty_flag),
    .afull_flag(afull_flag),
    .doa(do[8:0]),
    .dob({open_n53,open_n54,open_n55,open_n56,open_n57,open_n58,do[11:9]}),
    .empty_flag(empty_flag),
    .full_flag(full_flag));  // hasyncfifo_ahead12to12.v(43)
  not full_flag_syn_1 (full_flag_syn_2, full_flag);  // hasyncfifo_ahead12to12.v(29)

endmodule 

