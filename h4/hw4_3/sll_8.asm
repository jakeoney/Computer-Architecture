// Test a shift of -12 by 3.
// Result should be -96.

lbi r1, -12  // -12 = 1111 0100 = 0xF4.
lbi r2, 3
sll r3, r1, r2  // Should have that r3 = 96.
halt
