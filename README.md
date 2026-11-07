# Seven days of Verilog → an image-filter accelerator

For a programmer comfortable with C/Java/Python and the RV32I datapath. Budget **3–4 focused hours/day**, about 24 hours total. A week builds the RTL and verification foundation; the remaining break is for the image system and an initial synthesis flow. A fabricated ASIC is a separate milestone.

## Start here

1. Read [setup](docs/SETUP.md) and run the supplied smoke test.
2. Follow the days below in order. Each folder has a short lesson, a `starter.v`, and a self-checking `tb.sv`.
3. Edit only the starter initially. Run `python3 scripts/run.py 1` (replace 1 with the day).
4. Add one test of your own before looking at [solutions](solutions/README.md).
5. Record your explanations in [progress](PROGRESS.md). Passing tests alone is not mastery.

| Day | Focus | Local exercise | Project connection |
|---|---|---|---|
| [1](days/day01/LESSON.md) | Hardware semantics, ports, vectors, hierarchy | Pixel mux + full-width sum | Wiring a datapath |
| [2](days/day02/LESSON.md) | Combinational procedures, widths, latches | Signed-to-pixel clamp | Output conversion |
| [3](days/day03/LESSON.md) | Registers, reset, enables, simulation time | Three-sample shift register | Sliding windows |
| [4](days/day04/LESSON.md) | Signed multiplication, widening, verification | Pixel × coefficient | Filter arithmetic |
| [5](days/day05/LESSON.md) | Pipelining, valid bits, latency/throughput | Two-stage multiply-add | Timing and alignment |
| [6](days/day06/LESSON.md) | FSMs, counters, ready/valid | Nine-beat transaction controller | Scheduling work |
| [7](days/day07/LESSON.md) | Integration, randomized testing, synthesis | Nine-tap MAC | One 3×3 output pixel |

Daily rhythm: **15 min recall → 45–60 min lesson/resources → 30 min short drills → 60–90 min local exercise/debugging → 15 min explain your circuit**. Day 1 includes 30–45 min setup; Day 7 may take 4–5 hours. If short on time, omit stretch exercises, not verification.

## Scope and conventions

- Design files use a portable **Verilog-2001 RTL subset**: `wire`, `reg`, `always @*`, `always @(posedge clk)`. Testbenches use `.sv` for `$fatal`; the runner enables SystemVerilog parsing. Modern equivalents (`logic`, `always_comb`, `always_ff`) are explained in the reference sheet.
- One rising-edge clock; active-high **synchronous reset** `rst`. Reset wins over enable/transfer.
- Grayscale pixels: unsigned 8 bits. Coefficients: signed 8 bits. Full results: signed 20 bits. Integer kernels first; fixed-point coefficients are an extension.
- No FPGA, paid tools, board purchase, or fabrication is needed to learn or simulate these labs.
- Materials are original lessons and exercises, with links to external readings rather than copied course content.

## After the week

Read [PROJECT.md](docs/PROJECT.md): start with a Python-driven window stream, then move window generation into hardware. The included Python reference produces input windows and exact expected sums; the Day 7 bench checks every result from a synthetic image as well as stress cases.

Useful commands: `python3 scripts/run.py all`, `python3 scripts/run.py all --solution`, `python3 scripts/reference.py`, `make synth`. Starter failures are intentional until you implement the TODOs. Solutions never overwrite your work.
