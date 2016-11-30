onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate /system_tb/DUT/CPU/CM0/cif/dload
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/valid1
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/valid2
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/daddr
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/tag1
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/tag2
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/block1
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM0/DCACHE/block2[1]} -expand {/system_tb/DUT/CPU/CM0/DCACHE/block2[0]} -expand} /system_tb/DUT/CPU/CM0/DCACHE/block2
add wave -noupdate /system_tb/DUT/CPU/DP1/PC
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP1/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/DP1/aluif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP1/aluif/portA
add wave -noupdate /system_tb/DUT/CPU/DP1/aluif/portB
add wave -noupdate -expand /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate /system_tb/DUT/CPU/CC/coco/state
add wave -noupdate -expand -subitemconfig {{/system_tb/DUT/CPU/CM1/DCACHE/block1[1]} -expand {/system_tb/DUT/CPU/CM1/DCACHE/block1[0]} -expand} /system_tb/DUT/CPU/CM1/DCACHE/block1
add wave -noupdate /system_tb/DUT/CPU/CM1/DCACHE/block2
add wave -noupdate /system_tb/DUT/CPU/CM1/cif/dstore
add wave -noupdate /system_tb/DUT/CPU/CC/c2c
add wave -noupdate /system_tb/DUT/CPU/DP0/cuif/MemtoReg
add wave -noupdate /system_tb/DUT/CPU/DP0/cuif/RegWr
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM0/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate /system_tb/DUT/CPU/DP0/rfif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP0/aluif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP0/aluif/portA
add wave -noupdate /system_tb/DUT/CPU/DP0/aluif/portB
add wave -noupdate /system_tb/DUT/CPU/DP0/aluif/portOut
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/link_success
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/link_fail
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/datomic
add wave -noupdate /system_tb/DUT/CPU/DP0/dpif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/DP0/PC
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 6} {2426324 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 301
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
WaveRestoreZoom {1962761 ps} {3286841 ps}
