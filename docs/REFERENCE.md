# Verilog reference for a software programmer

| Software instinct | Hardware interpretation |
|---|---|
| Statements execute once in program order | Continuous assignments and separate always blocks operate concurrently |
| Function call | Module instance is a permanent piece of hardware; use named port connections |
| Variable | Signal with a fixed width; `reg` means procedural assignment, not necessarily a flip-flop |
| Loop performs work over time | A constant-bound combinational loop describes repeated hardware; use a counter/FSM to reuse one unit over cycles |
| Assignment stores a value | Combinational `=` builds logic; clocked `<=` describes register updates |
| Unlimited Python integer | Hardware truncates to its declared width |
| Print/log/file I/O | Testbench behavior, not physical on-chip I/O |

```verilog
wire [7:0] y;
assign y = sel ? b : a;

reg [7:0] next_value;
always @* begin
    next_value = 8'd0; // default covers every path
    if (enable) next_value = a;
end

reg [7:0] q;
always @(posedge clk) begin
    if (rst) q <= 8'd0;
    else if (enable) q <= next_value;
    // otherwise hold q: intended register enable
end
```

Use one procedural driver per register. Never gate a clock with ordinary logic in these exercises. Write a mux/enable instead. Avoid `casex`: it can hide unknown inputs. Give combinational `case` statements a default.

`a[7:0]` is a vector; `reg [7:0] mem [0:15]` is 16 eight-bit words. `mem[i]` selects a word. `{a,b}` concatenates; `{{12{x[7]}},x}` sign-extends an 8-bit bit pattern to 20 bits. A concatenation itself is unsigned unless cast or assigned into a signed signal. A slice also does not preserve the original signedness automatically.

`&` is bitwise AND; `&&` tests truth values; `&a` reduces all bits. `>>` shifts in zeros; `>>>` sign-fills only when the left operand is signed. An arithmetic right shift of a negative number rounds toward negative infinity, not toward zero.

Size literals (`8'd255`, `8'sd3`, `-8'sd2`) and explicitly widen intermediates. `$signed(pixel)` would treat 128–255 as negative. Use `$signed({1'b0,pixel})` to preserve a nonnegative pixel. Widen before an arithmetic operation where overflow matters; extending after truncation cannot recover lost bits.

## Simulation discipline

Signals can be 0, 1, X (unknown), or Z (undriven/high impedance). Use `!==` in testbench comparisons so X becomes a failure. Do not use X as a convenient RTL output default.

Drive synchronous inputs on the falling edge, inspect after the next rising edge plus `#1` in a bench. This avoids racing the DUT's nonblocking assignments. `#` delays, `$display`, `$dumpvars`, and file I/O in these benches are simulation helpers. They are not clock cycles or hardware delay elements in synthesizable RTL.

For `a <= in; b <= a;`, both RHS values are sampled from before the edge. `b` gets the old `a`. Separate always blocks obey the same model. Do not rely on their source order.

## Modern SystemVerilog bridge

`logic` covers most single-driver signal declarations; `always_comb` expresses combinational intent and adds checks; `always_ff @(posedge clk)` expresses sequential intent. These improve clarity, but do not change the circuit model. Learn them after the core week; defer classes, UVM, complex interfaces and advanced assertions.
