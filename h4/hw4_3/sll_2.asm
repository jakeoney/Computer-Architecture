//  Test a shift of 1 by 0.
//  Result should equal 1.

lbi r1, 1
lbi r2, 0
sll r3, r1, r2  // Should have that r3 = 1.
halt
