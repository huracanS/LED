vlib    work   
vmap    -modelsimini "E:/Modelsim/modelsim.ini" work    work
vlog    -f ./dut.f 
vlog    tb_LED_send.sv
vsim    -novopt -L eg work.tb_LED_send 
#-t ns -l ./sim.log -wlf
log     -r /*
#add      wave    tb_LED_send/*
run     -all
#run 100us