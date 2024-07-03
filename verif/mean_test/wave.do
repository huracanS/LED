onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group clk /tb_mean/clk
add wave -noupdate /tb_mean/rst_n
add wave -noupdate /tb_mean/data_en
add wave -noupdate /tb_mean/data
add wave -noupdate /tb_mean/start_o
add wave -noupdate /tb_mean/Mean
add wave -noupdate -expand /tb_mean/uut/u_sa/mean_aera
add wave -noupdate /tb_mean/uut/dbg_R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {11479558700 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {26233952500 ps}
