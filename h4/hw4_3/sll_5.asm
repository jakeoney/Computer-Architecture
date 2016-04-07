// Test a shift of 1 by 16.
// Result should be 1, since we only shift by the lowest 4 bits of the shift operand.

lbi r1, 1
lbi r2, 16  // First 4 bits of 16:  0000 = 0.
sll r3, r1, r2  // Should have that r3 = 1.
halt
