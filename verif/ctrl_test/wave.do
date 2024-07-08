onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/clk
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/rstn
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/fifo_data_in
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/rd
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/enable
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/cko_o
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/sdo
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/busy
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/wait_cnt
add wave -noupdate -group LED_send -radix unsigned /tb_led_ctrl_top/uut/u_LED_send/send_cnt
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/cnt
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/cko_p
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/cko_n
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/cko
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/c_state
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/n_state
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/en
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/frame_reg
add wave -noupdate -group LED_send /tb_led_ctrl_top/uut/u_LED_send/send_vld
add wave -noupdate -group LED_send -radix unsigned /tb_led_ctrl_top/uut/u_LED_send/bit_cnt
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/clk
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/rstn
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/en
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/start
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/we
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/fifo_data
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/send_start
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/c_state
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/n_state
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/block_choose_real
add wave -noupdate -group fifo_fsm /tb_led_ctrl_top/uut/u_fifo_fsm/wr_done
add wave -noupdate -group fifo_fsm -radix unsigned /tb_led_ctrl_top/uut/u_fifo_fsm/wr_cnt
add wave -noupdate -group top /tb_led_ctrl_top/uut/clk_fast
add wave -noupdate -group top /tb_led_ctrl_top/uut/clk_slow
add wave -noupdate -group top /tb_led_ctrl_top/uut/rstn
add wave -noupdate -group top /tb_led_ctrl_top/uut/en
add wave -noupdate -group top /tb_led_ctrl_top/uut/start
add wave -noupdate -group top /tb_led_ctrl_top/uut/we
add wave -noupdate -group top /tb_led_ctrl_top/uut/fifo_data_in
add wave -noupdate -group top /tb_led_ctrl_top/uut/send_start
add wave -noupdate -group top /tb_led_ctrl_top/uut/rd
add wave -noupdate -group top /tb_led_ctrl_top/uut/fifo_data_out
add wave -noupdate -group top /tb_led_ctrl_top/uut/send_start_sync
add wave -noupdate -group top /tb_led_ctrl_top/uut/empty_flag
add wave -noupdate -group top /tb_led_ctrl_top/uut/cko_o
add wave -noupdate -expand -group clk /tb_led_ctrl_top/clk_fast
add wave -noupdate -expand -group clk /tb_led_ctrl_top/clk_slow
add wave -noupdate /tb_led_ctrl_top/start
add wave -noupdate /tb_led_ctrl_top/en
add wave -noupdate /tb_led_ctrl_top/uut/u_fifo_fsm/c_state
add wave -noupdate /tb_led_ctrl_top/uut/cko_o
add wave -noupdate /tb_led_ctrl_top/uut/sdo_o
add wave -noupdate -expand -group fifo_wr /tb_led_ctrl_top/uut/we
add wave -noupdate -expand -group fifo_wr -color Magenta /tb_led_ctrl_top/uut/u_fifo_fsm/wr_cnt
add wave -noupdate -expand -group fifo_wr /tb_led_ctrl_top/uut/u_fifo_fsm/block_choose_real
add wave -noupdate -expand -group fifo_wr /tb_led_ctrl_top/uut/fifo_data_in
add wave -noupdate /tb_led_ctrl_top/uut/rd
add wave -noupdate /tb_led_ctrl_top/uut/fifo_data_out
add wave -noupdate /tb_led_ctrl_top/uut/u_hasyncfifo_ahead12to12/empty_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {888948555 ps} 0} {{Cursor 2} {137597614 ps} 0} {{Cursor 3} {37993704 ps} 0} {{Cursor 4} {418449165 ps} 0}
quietly wave cursor active 4
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {298911059 ps} {696991871 ps}
