// Test a shift of -61 by 1.
// Result should be -122.

lbi r1, -61  // -61 = 1100 0011 = 0xC3.
lbi r2, 1
sll r3, r1, r2  // Should have that r3 = -122.
halt
