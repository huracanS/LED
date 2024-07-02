create_clock -name SYSCLK -period 40 -waveform {0 20} [get_ports {sysclk_i}] -add
derive_pll_clocks
rename_clock -name {clk_150m} -source [get_ports {sysclk_i}] -master_clock {SYSCLK} [get_pins {u_PLL_150M/pll_inst.clkc[0]}]