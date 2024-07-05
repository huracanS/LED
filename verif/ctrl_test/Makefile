CURRENT_USER := $(shell whoami)
ifeq ($(CURRENT_USER),32863)
	SIM_DO_MODIFY := D:

else
	SIM_DO_MODIFY := E:

endif

run:
	sed -i "s#\([A-Z]\):/Modelsim/modelsim.ini#${SIM_DO_MODIFY}/Modelsim/modelsim.ini#g" sim.do
	vsim -c -do "./sim.do"

clean:
	rm -rf work transcript vsim.wlf sim.log modelsim.ini 

view:
	vsim -view vsim.wlf -do wave.do -gui
