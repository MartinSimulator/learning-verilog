# Validation status

Prepared on 2026-11-07.

- Python scripts compile; reference generation succeeds for 121 cases.
- Hand-calculated checks: 1…9 dotted with the directional Sobel kernel = 8; nine 255×(-128) terms = -293760; the synthetic edge image has raw output rows [0,760,760,0].
- Local Markdown links and RTL/testbench module connections were checked structurally.
- **RTL simulations and Yosys synthesis have not been executed:** neither tool is installed in the preparation environment. Reference RTL is reviewed, but passing results are not claimed.

After setup, run:

```sh
python3 scripts/run.py smoke
python3 scripts/run.py all --solution
make synth-solution
```

Then confirm each unimplemented starter fails its tests, and begin Day 1. Every bench has a watchdog; the runner also enforces a wall-clock timeout. Day 1 exhausts mux/sum inputs, Day 2 exhausts the clamp input range, and Day 4 exhausts pixel/coefficient combinations. Sequential tests cover directed scenarios plus deterministic pseudo-random stimuli where included; they are not formal proofs.
