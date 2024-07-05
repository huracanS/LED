onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fifo_fsm_tb/uut/clk
add wave -noupdate /fifo_fsm_tb/uut/rstn
add wave -noupdate /fifo_fsm_tb/uut/en
add wave -noupdate /fifo_fsm_tb/uut/start
add wave -noupdate /fifo_fsm_tb/uut/we
add wave -noupdate /fifo_fsm_tb/uut/fifo_data
add wave -noupdate /fifo_fsm_tb/uut/send_start
add wave -noupdate /fifo_fsm_tb/uut/c_state
add wave -noupdate /fifo_fsm_tb/uut/n_state
add wave -noupdate /fifo_fsm_tb/uut/wr_done
add wave -noupdate -radix unsigned /fifo_fsm_tb/uut/wr_cnt
add wave -noupdate /fifo_fsm_tb/uut/block_choose
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {401698 ps} 0}
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
WaveRestoreZoom {384 ns} {640 ns}
