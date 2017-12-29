transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules {/home/jovan/quartusWorkspace/CPU/CPU/modules/RSFlipFlop.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/tests/cpu {/home/jovan/quartusWorkspace/CPU/CPU/tests/cpu/SimpleInstructionTestBench.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules {/home/jovan/quartusWorkspace/CPU/CPU/modules/ClockGenerator.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/memory {/home/jovan/quartusWorkspace/CPU/CPU/modules/memory/MemoryInterface.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/memory {/home/jovan/quartusWorkspace/CPU/CPU/modules/memory/Memory.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/alu {/home/jovan/quartusWorkspace/CPU/CPU/modules/alu/Divider.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/alu {/home/jovan/quartusWorkspace/CPU/CPU/modules/alu/Adder.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/interruptModules {/home/jovan/quartusWorkspace/CPU/CPU/modules/interruptModules/InterruptEncoder.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/LedController {/home/jovan/quartusWorkspace/CPU/CPU/modules/LedController/ledController.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/SevenSegment {/home/jovan/quartusWorkspace/CPU/CPU/modules/SevenSegment/sevenSegmentController.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/interruptModules {/home/jovan/quartusWorkspace/CPU/CPU/modules/interruptModules/InterruptHandler.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu {/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu/InstructionDecoder.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu {/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu/CPU.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu {/home/jovan/quartusWorkspace/CPU/CPU/modules/cpu/ConditionDecoder.v}
vlog -vlog01compat -work work +incdir+/home/jovan/quartusWorkspace/CPU/CPU/modules/alu {/home/jovan/quartusWorkspace/CPU/CPU/modules/alu/ALU.v}

