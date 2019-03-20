onerror {exit -code 1}
vlib work
vlog -work work frequencyfinder.vo
vlog -work work Waveform1.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.frequencyfinder_vlg_vec_tst -voptargs="+acc"
vcd file -direction frequencyfinder.msim.vcd
vcd add -internal frequencyfinder_vlg_vec_tst/*
vcd add -internal frequencyfinder_vlg_vec_tst/i1/*
run -all
quit -f
