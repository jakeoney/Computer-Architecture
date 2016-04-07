// Test a shift of 1 by 20.
// Result should be 16, since we only shift by the lowest 4 bits of the shift operand.

lbi r1, 1
lbi r2, 20  // First 4 bits of 20:  0100 = 4.
sll r3, r1, r2  // Should have that r3 = r1*2^(lowest 4 bits of r2) = 1*2^4 = 16.
halt
