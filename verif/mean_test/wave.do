onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group clk /tb_mean/clk
add wave -noupdate /tb_mean/rst_n
add wave -noupdate /tb_mean/data_en
add wave -noupdate /tb_mean/data
add wave -noupdate /tb_mean/start_o
add wave -noupdate -expand /tb_mean/uut/u_sa/mean_aera
add wave -noupdate /tb_mean/Mean0
add wave -noupdate /tb_mean/Mean1
add wave -noupdate /tb_mean/Mean2
add wave -noupdate /tb_mean/Mean3
add wave -noupdate /tb_mean/Mean4
add wave -noupdate /tb_mean/Mean5
add wave -noupdate /tb_mean/Mean6
add wave -noupdate /tb_mean/Mean7
add wave -noupdate /tb_mean/Mean8
add wave -noupdate /tb_mean/Mean9
add wave -noupdate /tb_mean/Mean10
add wave -noupdate /tb_mean/Mean11
add wave -noupdate /tb_mean/Mean12
add wave -noupdate /tb_mean/Mean13
add wave -noupdate /tb_mean/Mean14
add wave -noupdate /tb_mean/Mean15
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {27786340500 ps} 1} {{Cursor 2} {27785936300 ps} 0}
quietly wave cursor active 2
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
WaveRestoreZoom {27785202900 ps} {27787788 ns}
