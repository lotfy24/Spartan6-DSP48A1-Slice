vlib work
vlog reg_to_mux.v Spartan6_DSP48A1.v test_bench.v 
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
//quit -sim