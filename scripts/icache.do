onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/DUT/state
add wave -noupdate /icache_tb/DUT/iaddr
add wave -noupdate /icache_tb/DUT/dcif/ihit
add wave -noupdate /icache_tb/DUT/dcif/imemREN
add wave -noupdate /icache_tb/DUT/dcif/imemload
add wave -noupdate /icache_tb/DUT/dcif/imemaddr
add wave -noupdate /icache_tb/DUT/ccif/iwait
add wave -noupdate /icache_tb/DUT/ccif/iREN
add wave -noupdate -radix binary /icache_tb/DUT/ccif/iload
add wave -noupdate /icache_tb/DUT/ccif/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {132285 ps} 0}
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
WaveRestoreZoom {0 ps} {357 ns}
