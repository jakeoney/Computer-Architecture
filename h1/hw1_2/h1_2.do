#reset the simulation
restart -force -nowave

#add all input and output signals to the wave file
add wave -logic A
add wave -logic B
add wave -logic Cin
add wave -logic S
add wave -logic Cout

#force the input signals
#testing 0 0 0
force -freeze A 0 0
force -freeze B 0 0
force -freeze Cin 0 0

#testing 0 0 1
force -freeze Cin 1 50

#testing 0 1 0
force -freeze B 1 100
force -freeze Cin 0 100

#testing 0 1 1
force -freeze Cin 1 150

#testing 1 0 0
force -freeze A 1 200
force -freeze B 0 200
force -freeze Cin 0 200

#testing 1 0 1
force -freeze Cin 1 250

#testing 1 1 0
force -freeze B 1 300
force -freeze Cin 0 300

#testing 1 1 1
force -freeze Cin 1 350

#run the full simulation
run 400

#open the wave window
view wave
