onerror {exit -code 1}
vlib work
vlog -work work square.vo
vlog -work work Waveform1.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.square_vlg_vec_tst -voptargs="+acc"
vcd file -direction square.msim.vcd
vcd add -internal square_vlg_vec_tst/*
vcd add -internal square_vlg_vec_tst/i1/*
run -all
quit -f
