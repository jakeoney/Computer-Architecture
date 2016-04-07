//  Tests a shift of 0 by 0.  Only external instruction dependency is lbi.
//  Result should be 0.

lbi r1, 0
lbi r2, 0
sll r3, r1, r2  //  Should have that r3 = 0.
halt
