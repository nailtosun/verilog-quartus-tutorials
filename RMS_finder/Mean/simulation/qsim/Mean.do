onerror {exit -code 1}
vlib work
vlog -work work Mean.vo
vlog -work work Waveform8.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Mean_vlg_vec_tst -voptargs="+acc"
vcd file -direction Mean.msim.vcd
vcd add -internal Mean_vlg_vec_tst/*
vcd add -internal Mean_vlg_vec_tst/i1/*
run -all
quit -f
