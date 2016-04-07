//Test with a positive register value and a negative immediate
//PC should be 0x08
//R7 should be 0x06
lbi r1, 127
nop
jalr r1, -121
halt
