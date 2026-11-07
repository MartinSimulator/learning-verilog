# Setup on an Apple Silicon Mac

## Required: Python 3, Icarus Verilog, editor

Use your existing editor. If Homebrew is installed:

```sh
brew install icarus-verilog
python3 --version
iverilog -V
vvp -V
```

If Homebrew is absent, follow [its official installation instructions](https://brew.sh/), then run the command above. Do not spend Day 1 configuring a large ASIC stack.

From this repository's root:

```sh
python3 scripts/run.py smoke
python3 scripts/run.py 1
```

The smoke test should print PASS. The unimplemented Day 1 should fail. Implement `days/day01/starter.v` and rerun. Exit code 0 means pass; `$fatal` or a timeout means failure. `--solution` compiles the reference instead of your starter. Never compile both together: they intentionally have the same module name.

## What the runner does

```sh
iverilog -g2012 -Wall -s tb -o build/day01/sim days/day01/starter.v days/day01/tb.sv
cd build/day01
vvp sim
```

`iverilog` compiles an event-driven simulation; `vvp` runs it. This does not create a physical chip. The runner builds in a separate directory and uses a timeout to catch stuck protocols. For Day 7 it first generates reference vectors using Python's standard library.

## Waveforms

Each bench writes `wave.vcd` into its build directory. Open it with a VCD-capable viewer such as [Surfer](https://surfer-project.org/) (optional), or inspect signal transitions in your editor's waveform extension. Add `clk`, `rst`, input data, valid/ready, accumulator and output. Follow one transaction edge by edge. Console checks suffice to begin.

## Optional on Day 7: Yosys

Use the [official Yosys installation guidance](https://yosyshq.readthedocs.io/projects/yosys/en/latest/getting_started/installation.html) for a supported distribution. Then:

```sh
make synth
```

This synthesizes your Day 7 starter to generic gates, checks the design, and prints statistics. `make synth-solution` checks the reference. Generic cell counts are not silicon area, power, or maximum frequency; those require a cell library, constraints and physical implementation.

## Troubleshooting

| Symptom | Likely cause |
|---|---|
| command not found | Install the required tool; restart terminal if PATH changed |
| duplicate module | Both starter and solution were compiled |
| all X output | Missing reset, undriven signal, or missing combinational assignment |
| output one cycle off | Misunderstood old register values/nonblocking updates |
| negative numbers wrong | Mixed signedness, truncation, or unsigned pixel cast as signed |
| test hangs | Handshake never completes; inspect timeout and ready/valid |
| tests pass but synthesis has latches | Incomplete combinational assignment; tests did not cover every path |
