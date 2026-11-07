# Day 3: Clocked state and testbench timing


**Goal:** reason about registers before and after a clock edge, including stalls and reset.

### Learn (45–60 min)

Read [Icarus simulation](https://steveicarus.github.io/iverilog/usage/simulation.html) selectively and the simulation section of [REFERENCE.md](../../docs/REFERENCE.md). Your CS61C pipeline registers map directly to clocked always blocks. Use nonblocking `<=`: all right-hand sides refer to old values. `a <= in; b <= a;` moves the old `a` into `b`, rather than moving the new input through both registers immediately.

Our reset is synchronous: asserting `rst` alone does not change the registers until the next rising edge. Reset wins over enable. Do not use `initial` register values as a substitute for ASIC reset.

### Quick practice (25–30 min)

HDLBits: **Always blocks (clocked)**, **DFF with reset**, **DFF with asynchronous reset**. Compare the two reset styles, but use synchronous reset locally.

### Local lab (60 min)

Implement `shift3`. On reset set all outputs to zero. On each rising edge with `en=1`: `q0` captures `pixel`, `q1` captures old `q0`, `q2` captures old `q1`. With `en=0`, hold all three. Run `python3 scripts/run.py 3`.

Predict the state after accepted inputs 10,20,(stall with 99),30: `(q0,q1,q2)=(30,20,10)`. Open the waveform and locate the stall. Then assert reset while `en=1`: reset must win.

### Exit check

Why would blocking assignments in the order q0,q1,q2 break the shift register? Why does the testbench drive on falling edges and check after rising edges? A three-sample horizontal window is not yet a 3×3 image window: what storage is missing?
