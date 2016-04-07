// Test a shift of 1 by 15.
// Result should be 0x8000 = -32768.

lbi r1, 1
lbi r2, 15
sll r3, r1, r2  // Should have that r3 = 0x8000.
halt
