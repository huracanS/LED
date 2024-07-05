vlib    work   
vmap    -modelsimini "E:/Modelsim/modelsim.ini" work    work
vlog    -f ./dut.f 
vlog    fifo_fsm_tb.sv
vsim    -novopt -L eg work.fifo_fsm_tb 
#-t ns -l ./sim.log -wlf
log     -r /*
#add      wave    tb_LED_send/*
run     -all
#run 100us