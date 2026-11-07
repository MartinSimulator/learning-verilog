# Day 7: Integrate the nine-tap filter core


**Goal:** combine signed arithmetic, registers and a transfer controller into a reusable filter engine.

### Learn/review (45 min)

Read [PROJECT.md](../../docs/PROJECT.md) through the first milestone and skim the [Yosys synthesis starter](https://yosyshq.readthedocs.io/projects/yosys/en/latest/getting_started/example_synth.html). Simulation checks specified behaviors; synthesis translates RTL to a circuit. A correct simulation is necessary but not proof of timing closure or fabrication readiness.

This accelerator does not fetch RV32I instructions. A counter/FSM sequences one multiplier and accumulator. Each accepted input contains one pixel and its matching coefficient. Nine accepted pairs make one output; the host/testbench provides windows in row-major order. Start from the Day 6 controller and Day 4 arithmetic.

### Quick practice (20 min)

On paper evaluate pixels `[1,2,3,4,5,6,7,8,9]` with kernel `[-1,0,1,-2,0,2,-1,0,1]`: result 8. What does the ninth clocked update need to use? `result <= acc` omits the ninth product; use the full next sum.

### Local lab (90–120 min)

Implement `mac9`. Reset discards partial/pending work. In COLLECT, accept only on `in_valid && in_ready`; sum nine widened products. On the ninth acceptance publish the full signed sum and enter HOLD. Keep `result` and `out_valid` stable while the output is stalled; accept no new input in HOLD. On output transfer clear accumulator and count, then collect the next window. There is no separate start or last signal: every nine accepted pairs define a window.

Run `python3 scripts/run.py 7`. The bench checks edge-filter image windows, random pairs, all-positive/all-negative extremes, input gaps, output stalls, and reset during work. Inspect one failed transaction in the waveform. Add one test of your own.

### Synthesis and design review (30–45 min)

If Yosys is installed, run `make synth`. Otherwise read the script and defer execution to the project setup day. Identify the multiplier, adder, count/state and result registers. Confirm there are no inferred latches. Generic synthesis gives no reliable silicon area or clock target.

### Exit check

Can you predict every transfer and explain why results survive backpressure? Can you justify the 20-bit accumulator? Can you explain why this engine needs at least nine input beats per output, while a sufficiently parallel streaming design might eventually deliver a pixel per cycle? Complete the readiness checklist in PROJECT.md before adding line buffers.
