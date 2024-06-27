create_clock -name SYSCLK -period 40 -waveform {0 20} [get_ports {sysclk_i}] -add
derive_pll_clocks
create_generated_clock -add -name clk_150m -source [get_ports {sysclk_i}] -master_clock {SYSCLK} -divide_by 6 -phase 0 [get_ports {sysclk_i}]