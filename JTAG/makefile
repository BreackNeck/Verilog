FILE_tapController = TAP/tapController.v Testbenches/tap_controller_tb.v
FILE_Decode_state = TAP/Decode_state.v Testbenches/state_decoder_tb.v
FILE_TOPMODULE = TAP/TOPMODULE.v TAP/tapController.v TAP/IR.v TAP/DR.v TAP/IR_DEFINES.v TAP/Decode_state.v TAP/BYPASS.v TAP/CORE_LOGIC.v Testbenches/topmodule_tb.v 


tapController_compile:
	iverilog -o tapController $(FILE_tapController)

tapController_vvp:
	vvp tapController

tapController_gtk:
	gtkwave tapController_tb.vcd

Decode_state_compile:
	iverilog -o Decode_state $(FILE_Decode_state)

Decode_state_vvp:
	vvp Decode_state

Decode_state_gtk:
	gtkwave state_decoder_tb.vcd

CORE_LOGIC_compile:
	iverilog -o CORE_LOGIC $(FILE_CORE_LOGIC)

CORE_LOGIC_vvp:
	vvp CORE_LOGIC

CORE_LOGIC_gtk:
	gtkwave CORE_LOGIC_tb.vcd

TOPMODULE_compile:
	iverilog -o TOPMODULE $(FILE_TOPMODULE)

TOPMODULE_vvp:
	vvp TOPMODULE

TOPMODULE_gtk:
	gtkwave topmodule_tb.vcd

TOPMODULE_make:
	iverilog -o TOPMODULE $(FILE_TOPMODULE)
	vvp TOPMODULE
	gtkwave topmodule_tb.vcd