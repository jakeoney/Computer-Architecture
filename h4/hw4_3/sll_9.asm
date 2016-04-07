// Test a shift of 11 by -93.
// Result should be 88.

lbi r1, 11  // 11 = 0000 1011
lbi r2, -93  // -93 = 1010 0011
sll r3, r1, r2  // Should have that r3 = r1*2^(lowest 4 bits of r2) = 11*2^3=88.
halt
