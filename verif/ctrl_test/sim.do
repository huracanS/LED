vlib    work   
vmap    -modelsimini "D:/Modelsim/modelsim.ini" work    work
vlog    -f ./dut.f 
vlog    tb_led_ctrl_top.sv
vsim    -novopt -L eg work.tb_led_ctrl_top 
#-t ns -l ./sim.log -wlf
log     -r /*
#add      wave    tb_LED_send/*
run     -all
#run 100us