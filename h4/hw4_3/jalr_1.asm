//Test with value in r1 and no immediate
//PC should be 0x0c
//R7 should be 0x04
lbi r1, 10 
jalr r1, 0 
halt
