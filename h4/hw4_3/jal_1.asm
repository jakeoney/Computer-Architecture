//Should jump over nop and halt, then got back to halt
//PC should end at 0x08
//R7 should have 0x0A
nop
jal 4
nop
halt
jal -4
nop
nop
halt
