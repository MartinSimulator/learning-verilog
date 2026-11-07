# Reference solutions — use after an attempt

Run a solution without changing your starter: `python3 scripts/run.py 4 --solution`.

1. Attempt the exercise and inspect a failing waveform.
2. Write down the expected circuit and the mismatch.
3. Compare only the relevant solution, then close it and implement your own fix.

Key ideas: Day 1 widens before adding; Day 2 assigns all branches; Day 3 uses old register values; Day 4 zero-extends the unsigned pixel before signed multiplication; Day 5 pipelines bias and valid alongside the product; Day 6 counts handshakes; Day 7 includes the final product and retains results under backpressure.

These are small reference architectures, not optimized tapeout blocks. Passing supplied tests is not exhaustive proof except for the combinational input combinations explicitly enumerated.
