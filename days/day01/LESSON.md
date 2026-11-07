# Day 1: Circuits described with text


**Goal:** translate a small Logisim-style circuit into RTL and predict its wires and operators.

### Learn (45–60 min)

Read the Icarus getting-started compile/run examples and the first half of [REFERENCE.md](../../docs/REFERENCE.md). A module defines ports and internal hardware; instantiating it creates hardware, not a function invocation. An `assign` continuously drives its output as inputs change. No clock is needed for a mux or adder.

`wire [7:0]` is eight bits, indexed 7 down to 0. `8'hff` and `8'd255` are the same bits. An 8-bit sum can wrap; a 9-bit sum can retain the carry. Write `{1'b0,a} + {1'b0,b}` so your arithmetic intent is explicit.

### Quick practice (25–35 min)

From [HDLBits](https://hdlbits.01xz.net/wiki/Problem_sets): **Simple wire**, **Vector part select**, **Vector concatenation operator**, **Connecting ports by name**. Spend about 5–8 minutes each; read the explanation before coding.

### Local lab (45–60 min)

Implement `pixel_mux`: `y=a` when `sel=0`, otherwise `y=b`; `sum` is the full unsigned sum of `a+b`, independent of `sel`. Use continuous assignments. Run `python3 scripts/run.py 1`. Predict the outputs for `a=255,b=1` before running.

Then draw the circuit: an 8-bit mux and a 9-bit adder, operating simultaneously. Optional 15-minute extension: create a wrapper that instantiates two mux modules using named ports (not covered by the supplied bench).

### Exit check

Explain why changing the order of the two assigns does not change behavior. Why does `sum` need nine bits? Why is a module instance unlike calling a Java method?
