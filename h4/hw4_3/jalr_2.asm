//Test with no value in r1 and an immediate
//PC should be 0x100
//R7 should be 0x06
lbi r1, 127
nop
jalr r1, 127 
halt
