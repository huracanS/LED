vlib    work   
vmap    -modelsimini "D:/Modelsim/modelsim.ini" work    work
vlog    -f ./dut.f 
vlog    tb_mean.sv
vsim    -novopt -L eg work.tb_mean 
#-t ns -l ./sim.log -wlf
log     -r /*
#add      wave    tb_mean/*
run     -all
#run 100us