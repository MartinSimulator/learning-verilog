# Day 4: Signed arithmetic and useful verification


**Goal:** multiply unsigned pixels by negative coefficients without silent overflow.

### Learn (45–60 min)

Pixels 0–255 are unsigned; coefficients -128–127 are signed. Casting the pixel directly with `$signed(pixel)` reinterprets values ≥128 as negative. First prepend a zero: `$signed({1'b0,pixel})`. Use an explicit signed 9-bit pixel, signed 8-bit coefficient, and signed 17-bit product. The actual restricted product range is -32640…32385; 17 bits is a conservative width derived from 9+8.

Sign-extend that product to the 20-bit accumulator domain. Nine full-range products are bounded by -293760…291465, inside signed 20-bit range (-524288…524287). A 16-bit accumulator is inadequate. Read the signedness section of [REFERENCE.md](../../docs/REFERENCE.md).

### Quick practice (25 min)

HDLBits: **Replication operator**, **Signed addition overflow**. On paper calculate 255×(-1), 255×(-128), and nine copies of the latter. Then explain why a Python model must enforce ranges even though Python itself cannot overflow here.

### Local lab (60 min)

Implement combinational `pixel_product`: expose the sign-extended product as signed 20-bit `product`. Run `python3 scripts/run.py 4`. The bench exhausts all 256×256 pixel/coefficient pairs using a wider integer expected value.

Read the bench: declarations, DUT instance, loops, `#1`, `!==`, `$fatal`. Deliberately use `$signed(pixel)` and verify the test fails, then restore the fix. This is a test-quality exercise, not just a syntax exercise.

### Exit check

Can you explain the value and signedness at every arithmetic intermediate? Why is extending an already truncated product too late? Optional: represent a coefficient of 0.5 as integer 64 with seven fractional bits; explain the final shift and rounding choice.
