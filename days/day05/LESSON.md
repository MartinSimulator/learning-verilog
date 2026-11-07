# Day 5: Pipelines and valid-data alignment


**Goal:** pipeline arithmetic while preserving which metadata belongs to each sample.

### Learn (45 min)

Think of your RV32I pipeline: data and its control information must advance together. Here the metadata is `valid` and a small bias. Stage 1 registers pixel×coefficient AND the corresponding bias. Stage 2 adds the registered product and registered bias. Each stage also registers its valid bit.

If a tuple is sampled at rising edge E, its output is visible just after E+1 (the next rising edge), with `out_valid=1`. There are two register stages; exactly one full clock period elapses between input sampling and output update. A fresh tuple can be accepted every edge: initiation interval 1. State latency using these edges to avoid ambiguous “two-cycle” terminology.

### Quick practice (20–30 min)

Draw a timing table for inputs A, B, bubble, C. Show `valid1`, `out_valid`, and the matching bias at each edge. Explain why using the live input bias in stage 2 corrupts back-to-back samples.

### Local lab (60–75 min)

Implement `pipe_madd`: inputs are unsigned 8-bit pixel, signed 8-bit coefficient and signed 8-bit bias; output is signed 20-bit `result`. No ready signal: the consumer always accepts valid outputs. Advance valid bits every edge, including bubbles. On reset clear both valid bits and data registers. Output data on invalid cycles is unspecified to the consumer.

Run `python3 scripts/run.py 5`. Add a reset while data is in flight and confirm stale outputs are discarded (the supplied test also covers this). Inspect a waveform for three consecutive inputs with distinct biases.

### Exit check

Explain throughput versus latency, why bias needs a register, and why a bubble must advance rather than freezing a valid bit. Timing must ultimately include clock-to-Q, combinational delay, setup and clock uncertainty; functional simulation alone cannot establish maximum frequency.
