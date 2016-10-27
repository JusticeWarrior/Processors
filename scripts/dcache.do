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
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iaddr
add wave -noupdate -expand /system_tb/DUT/CPU/CM/ICACHE/valid
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/tag
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/data
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/iaddr
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/state
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/ihit_wait
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iwait
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dwait
add wave -noupdate /system_tb/DUT/CPU/DP/PC
add wave -noupdate /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dREN
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dWEN
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dload
add wave -noupdate /system_tb/DUT/CPU/CM/cif/dstore
add wave -noupdate /system_tb/DUT/CPU/CM/cif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/force_write1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/force_write2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/next_state
add wave -noupdate -expand /system_tb/DUT/CPU/CM/DCACHE/block1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block2
add wave -noupdate -expand /system_tb/DUT/CPU/CM/DCACHE/valid1
add wave -noupdate -expand /system_tb/DUT/CPU/CM/DCACHE/valid2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dirty1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/dirty2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/lru1
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/lru2
add wave -noupdate -expand /system_tb/DUT/CPU/CM/DCACHE/tag1
add wave -noupdate -expand /system_tb/DUT/CPU/CM/DCACHE/tag2
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block1_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block2_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/flush_index
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portA
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portB
add wave -noupdate /system_tb/DUT/CPU/DP/aluif/portOut
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/hitcount
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/next_dirty
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block1_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/block2_flushed
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/flush_index
add wave -noupdate /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate /system_tb/DUT/RAM/ramif/ramWEN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2133742 ps} 0}
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
WaveRestoreZoom {1408243 ps} {2868243 ps}
