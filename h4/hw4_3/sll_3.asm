// Test a shift of 1 by 1.
// Result should be 2.

lbi r1, 1
lbi r2, 1
sll r3, r1, r2  // Should have that r3 = 2.
halt
