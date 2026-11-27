# Progress and design journal

- [ ] Day 1: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 2: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 3: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 4: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 5: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 6: lesson, drills, local test, one added test, verbal explanation
- [ ] Day 7: lesson, drills, local test, one added test, verbal explanation

For each day record: circuit inferred; bug encountered; failing test; fix; one remaining question.


## Day 1 Notes

### Lesson (iverilog getting started)
- Common file suffixes are `.v`, `.vl`, `.ver`, or `.vlg` (all work)
- To compile a program (e.g., hello.v) use `iverilog -o hello hello.v`
- Results of compilation are placed in a file called "hello" -> execute using `vvp hello`
- More complex designs gain hierarchy in form of modules that are instantiated within others (organize using multiple files)
- A common convention is to write a moderate sized module per file (or group related, small modules in a single file) and combine the files together during compilation
- To compile multi-file designs, you can run `iverilog -o my_design counter_tb.v counter.v` -> execute using `vvp my_design`
- You can also place multiple files in a `.txt` file and then run `iverilog -o my_design -c file_list.txt`
- Typically, you'll have a root file that instantiates other modules but isn't itself instantiated (you can designate a root with `-s` -> `iverilog -s main -o hello hello.v`)

### Lesson (REFERENCE doc)
- `assign` doesn't run just once; it is a constantly connected wire so changing values on the right of the statement immediately change the value on the left
- `pixel_mux dut(...)` in the testbench builds one copy of the circuit and then leaves it there (not a method call with a return value)
- `a` is exactly 8 bits -> `8'd255 + 8'd1` wraps to 0 if the result is stored in 8 bits
- `assign y = sel ? b : a` -> sel true selects b, otherwise a
- `always @*` and `always @(posedge clk)` are combinational logic and a register

### HDLBits

#### Simple Wire
- This module was very simple, just one line declaring a wire `assign out = in;`

#### Vector Part Select
- This module demonstrated how to assign specific bits of an input to an output (kind of like using splitters in Logisim)
- you can "index" bits from the input (e.g., `in[7:0]`) and send them to specific bits of the output (e.g., `out[15:8]`)

#### Vector Concatenate Operator
- This module demonstrated how to concatenate wires
- you can assign bits of one wire to bits of multiple other wires
- e.g., `assign y[7:0] = {x[3:0], y[10:9], 2'b11}`

#### Connecting Ports By Name
- This module taught me how to instantiate a module within a top module and map specific ports in the submodule to ones in the top module
- You can't use 'Instance' as the instance name since that's a keyword
- you use the format `mod_name inst_name(.mod_port(top_port), ...);`