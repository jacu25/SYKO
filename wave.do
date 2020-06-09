onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /mbr_tb/clk
add wave -noupdate /mbr_tb/r_e
add wave -noupdate /mbr_tb/rst
add wave -noupdate /mbr_tb/re
add wave -noupdate /mbr_tb/we
add wave -noupdate /mbr_tb/mbr_data
add wave -noupdate /mbr_tb/mbr_mem
add wave -noupdate /mbr_tb/present_state
add wave -noupdate /mbr_tb/we
add wave -noupdate /mbr_tb/storex
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {43 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {150 ns}
