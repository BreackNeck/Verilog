FILE_tap_controller = TAP/tap_controller.v Testbenches/tap_controller_tb.v
FILE_state_decoder = TAP/state_decoder.v Testbenches/state_decoder_tb.v
FILE_TOPMODULE = TAP/TOPMODULE.v TAP/tap_controller.v TAP/ir.v TAP/dr.v TAP/IR_DEFINES.v TAP/state_decoder.v TAP/bypass.v TAP/core_logic.v TAP/Bist.v Testbenches/bist_tb.v 


tap_controller_compile:
	iverilog -o tap_controller $(FILE_tap_controller)

tap_controller_vvp:
	vvp tap_controller

tap_controller_gtk:
	gtkwave tap_controller_tb.vcd

state_decoder_compile:
	iverilog -o state_decoder $(FILE_state_decoder)

state_decoder_vvp:
	vvp state_decoder

state_decoder_gtk:
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
	gtkwave bist_tb.vcd

TOPMODULE_make:
	iverilog -o TOPMODULE $(FILE_TOPMODULE)
	vvp TOPMODULE
	