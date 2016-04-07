//  Test shift of 0 by 1.
//  Result should be 0.

lbi r1, 0
lbi r2, 1
sll r3, r1, r2  // Should have that r3 = 0.
halt
