#reset the simulation
restart -force -nowave

#add all input and output signals to the wave file
add wave -logic S
add wave -logic InA
add wave -logic InB
add wave -logic Out

#force the input signals
#testing 0 0 0
force -freeze S 0 0
force -freeze InA 0 0
force -freeze InB 0 0

#testing 0 0 1
force -freeze InB 1 50

#testing 0 1 0
force -freeze InA 1 100
force -freeze InB 0 100

#testing 0 1 1
force -freeze InB 1 150

#testing 1 0 0
force -freeze S 1 200
force -freeze InA 0 200
force -freeze InB 0 200

#testing 1 0 1
force -freeze InB 1 250

#testing 1 1 0
force -freeze InA 1 300
force -freeze InB 0 300

#testing 1 1 1
force -freeze InB 1 350

#run the full simulation
run 400

#open the wave window
view wave
