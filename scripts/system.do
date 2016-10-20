onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/state
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dwait
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dREN
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dWEN
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dload
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dstore
add wave -noupdate /system_tb/DUT/CPU/CM/cif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/force_write1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/force_write2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/next_state
add wave -noupdate -subitemconfig {{/system_tb/DUT/CPU/CM/DCACHE/block1[1]} -expand} /system_tb/DUT/CPU/CM/DCACHE/block1
add wave -noupdate -subitemconfig {{/system_tb/DUT/CPU/CM/DCACHE/block2[1]} -expand} /system_tb/DUT/CPU/CM/DCACHE/block2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/valid1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/valid2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dirty1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dirty2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/lru1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/lru2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/tag1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/tag2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block1_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block2_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/flush_index
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/next_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5095524 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {11680 ns}
