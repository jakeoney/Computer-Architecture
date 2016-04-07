//Test with no value in r1 and an immediate
//PC should be 0x0c
//R7 should be 0x04
lbi r1, 0 
jalr r1, 10 
halt
