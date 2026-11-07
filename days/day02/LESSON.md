# Day 2: Combinational logic without accidental memory


**Goal:** implement a complete combinational function with clear signed comparisons.

### Learn (45 min)

Read the combinational examples in [REFERENCE.md](../../docs/REFERENCE.md). `always @*` reevaluates when its read signals change. Use blocking `=` inside it. Assign every output on every path. A missing assignment means the old output must be retained, which can infer a latch. In a clocked block, holding a register is intentional; here it is not.

`if` and `case` describe mux/control logic. `output reg` permits assignment in a procedure; it does not by itself imply storage. A signed input must be compared with compatible signed values. Use `20'sd0` and `20'sd255` for this exercise.

### Quick practice (25–35 min)

HDLBits: **Always blocks (combinational)**, **If statement latches**, **Case statement**, **Avoiding latches**.

### Local lab (45–60 min)

Implement `pixel_clamp`: map signed 20-bit `value` to unsigned 8-bit `pixel`: negative → 0, greater than 255 → 255, otherwise → low eight bits. Use one `always @*` and blocking assignments. Run `python3 scripts/run.py 2`.

Manually check -1, 0, 1, 254, 255, 256. Add one new boundary test. Explain why simply taking `value[7:0]` is wrong for -1 and 256.

### Exit check

Identify the comparators and muxes this needs. What would a missing final `else` do? Does the declaration `reg [7:0] pixel` imply a clocked register? (No.)
