onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_LED_send/uut/clk
add wave -noupdate /tb_LED_send/uut/rstn
add wave -noupdate /tb_LED_send/uut/enable
add wave -noupdate /tb_LED_send/uut/data_in
add wave -noupdate /tb_LED_send/uut/cko
add wave -noupdate /tb_LED_send/uut/cko_o
add wave -noupdate /tb_LED_send/uut/sdo
add wave -noupdate /tb_LED_send/uut/rd
add wave -noupdate /tb_LED_send/uut/busy
add wave -noupdate /tb_LED_send/uut/wait_cnt
add wave -noupdate /tb_LED_send/uut/send_cnt
add wave -noupdate /tb_LED_send/uut/cko_p
add wave -noupdate /tb_LED_send/uut/sdo_2
add wave -noupdate /tb_LED_send/uut/cko_n
add wave -noupdate /tb_LED_send/uut/frame_reg
add wave -noupdate /tb_LED_send/uut/c_state
add wave -noupdate /tb_LED_send/uut/n_state
add wave -noupdate /tb_LED_send/uut/cnt
add wave -noupdate /tb_LED_send/uut/data_reg
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/clk
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/rst_n
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/led_num
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/done
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/result
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/state
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/next_state
add wave -noupdate -expand -group multi_cycle_calculator /tb_LED_send/uut/u_multi_cycle_calculator/temp_result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {629937 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {391328 ps} {928520 ps}
