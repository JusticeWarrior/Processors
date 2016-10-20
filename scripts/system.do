onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/ALUCtr
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Rs
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Rt
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Rd
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portOut
add wave -noupdate /system_tb/DUT/CPU/DP/elif/out_rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/mlif/dload
add wave -noupdate /system_tb/DUT/CPU/DP/mlif/out_dload
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/huif/wsel_ex
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/elif/wsel
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/out_dREN
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/out_regWEN
add wave -noupdate /system_tb/DUT/CPU/DP/elif/out_dREN
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/huif/wsel_mem
add wave -noupdate -radix unsigned /system_tb/DUT/CPU/DP/elif/out_wsel
add wave -noupdate /system_tb/DUT/CPU/DP/elif/out_regWEN
add wave -noupdate /system_tb/DUT/CPU/DP/huif/stall
add wave -noupdate /system_tb/DUT/CPU/DP/bsel
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/Jmp
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/JR
add wave -noupdate /system_tb/DUT/CPU/DP/flif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/elif/flush
add wave -noupdate /system_tb/DUT/CPU/DP/flif/en
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/en
add wave -noupdate /system_tb/DUT/CPU/DP/elif/en
add wave -noupdate /system_tb/DUT/CPU/DP/elif/out_baddr
add wave -noupdate /system_tb/DUT/CPU/DP/PC
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/forwardB
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portA
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portB
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/out_porta
add wave -noupdate /system_tb/DUT/CPU/DP/dlif/out_rdat2
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/regWEN_ex
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/regWEN_mem
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/Rd_mem
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/Rs_dec
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/Rt_dec
add wave -noupdate /system_tb/DUT/CPU/DP/fuif/Rd_ex
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/JAL
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2708013 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 306
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2271672 ps} {3177728 ps}
