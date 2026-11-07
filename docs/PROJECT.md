# From the course to the winter-break project

## First specification

Build a synthesizable **3×3 grayscale image-filter accelerator**. Treat simulation, synthesis, physical design, and fabrication as separate deliverables. A one-month goal is a verified RTL image demo plus synthesis results; place-and-route is a stretch goal. Do not promise tapeout before choosing a process, interface and area budget.

| Decision | Initial choice |
|---|---|
| Pixels | Unsigned 8-bit, row-major |
| Coefficients | Nine signed 8-bit integers |
| Arithmetic | Signed 20-bit accumulator, no intermediate saturation |
| Operation | Cross-correlation: sum image[y+dy][x+dx] × kernel[dy][dx] |
| True convolution | Reverse the kernel in both axes before sending coefficients |
| Shape | Valid output only: H−2 rows by W−2 columns; stride 1, no padding |
| First compute unit | One multiplier reused for nine accepted pairs |
| First interface | Testbench ready/valid streams; no CPU instruction set |
| Display | Keep signed sums for exact comparison; abs then clamp only for edge visualization |

For a Sobel horizontal derivative use `[-1,0,1,-2,0,2,-1,0,1]`. This is one directional edge response, not full Sobel magnitude. Later add a vertical kernel and define a magnitude approximation. With nonsymmetric kernels, kernel reversal matters: correlation and convolution are different operations.

## Week 2: prove images work end to end

1. Reuse the Day 7 engine. Python extracts each 3×3 window, sends nine pixel/coefficient pairs through a simulation bench, and collects one signed result. This sends redundant pixels but makes verification straightforward.
2. Add PGM input/output to the harness (the included reference already writes tiny synthetic PGM files). Add PNG/JPEG conversion only in host Python, never in RTL.
3. Record DUT results to a file with `$fdisplay`; reconstruct the (H−2)×(W−2) result image. Compare raw integer results against Python before visualizing. `golden_edge.pgm` in the starter harness is a Python expected image, not proof that RTL produced it.
4. Demonstrate identity-center, all-zero, signed edge and asymmetric kernels; all-zero, constant, impulse, ramp, checkerboard and random images. Use at least two non-square dimensions and check exact output count/order.

**Deliverable:** reproducible command that generates expected and RTL images, reports zero mismatches, and saves an example waveform. The included 6×6 → 4×4 Day 7 tests establish the first small case; building a full image-file harness is your project work.

## Week 3: put window generation into hardware

Store coefficients in nine registers loaded before an image. Reject or defer coefficient writes while processing so a frame cannot mix kernels. Use a fixed image width first (e.g. 32), then parameterize it.

Add two line delays plus horizontal taps to assemble a 3×3 neighborhood from a raster pixel stream. A two-row storage budget starts at roughly `2 × width × 8` bits, plus taps/control; actual organization depends on memory read latency. Maintain row/column counters and suppress outputs until the first complete window. Handle row transitions explicitly: horizontal neighbors cannot wrap into the next row.

Because a serial MAC cannot consume one new window every cycle, either stall the pixel/window producer until work is accepted or add adequate buffering. A FIFO cannot fix a permanent throughput mismatch. Do not shift line buffers on unaccepted input beats. Decide memory read-first/write-first behavior and model synchronous memory latency explicitly; a Verilog array is not automatically an ASIC SRAM macro.

**Deliverable:** same exact Python comparison, now with hardware-generated windows and randomized backpressure. Preserve alignment of coordinates, window data and valid signals.

## Week 4: measure and improve one thing

Synthesize the baseline. Document constraints and tool versions. Compare a serial MAC against a partially parallel version only after both pass the same functional tests. Measure cycles per image and generic resource counts. If pursuing a real ASIC flow, select a supported PDK and standard-cell library, constrain the clock/I/O, and learn floorplanning, placement, clock-tree synthesis, routing and static timing analysis. Apple Silicon support for the chosen physical-design flow may require a Linux environment.

An actual chip also needs a practical host interface (for example SPI or a small parallel protocol), reset/clock planning, pin budgets, power delivery and a verification/signoff plan. Keep UART/SPI and chip packaging out of the learning week. Recheck current shuttle requirements before choosing any tapeout target.

## Ready to start the project when you can…

- [ ] Explain blocking versus nonblocking assignments using a waveform.
- [ ] Identify every state element, combinational path and possible latch.
- [ ] Derive arithmetic widths and explain signed/unsigned conversions.
- [ ] Write a self-checking test and demonstrate that it catches a deliberate bug.
- [ ] Keep data and valid aligned through a pipeline.
- [ ] Handle reset, input bubbles and output backpressure without losing work.
- [ ] Explain the serial MAC's throughput limitation and its ninth-term update.
- [ ] Distinguish working RTL from a synthesized netlist and a timing-closed physical chip.

If one item is weak, spend another day on that topic. Defer UVM, advanced buses, clock-domain crossing, floating point and CPU design until the first image works.
