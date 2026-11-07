# Day 6: Control logic and ready/valid transfers


**Goal:** count accepted input transfers and retain a completed transaction under backpressure.

### Learn (45–60 min)

Read LaForest's [handshake rules](https://fpgacpu.ca/fpga/handshake.html): Interfaces, Handshake Procedure, Avoiding Deadlocks and Livelocks. A transfer happens only at a rising edge with `valid && ready`. The producer holds valid and data stable until accepted. It must not wait for ready before asserting valid. A consumer can temporarily lower ready (backpressure).

Implement a two-state controller: COLLECT and HOLD. In COLLECT, `in_ready=1`. Count only accepted inputs, from count=0 through count=8. Accepting the ninth input enters HOLD; `out_valid=1` until a rising edge with `out_ready=1`. That edge returns to COLLECT with count=0. No input is accepted while HOLD, even on the output-consumption edge. This deliberate one-cycle boundary keeps the first design simple.

### Quick practice (25 min)

HDLBits: choose one introductory **Simple FSM** exercise from the FSM section. Draw your COLLECT/HOLD transition diagram and write a cycle table containing input gaps and three stalled output cycles.

### Local lab (60–75 min)

Implement `burst9` with the supplied ports. `count` means number of accepted inputs in the current collection (0–8), not elapsed cycles. During HOLD it may remain 8; reset it when leaving HOLD. Gate ready and valid low while reset is high, and clear sequential state on the next rising edge. Run `python3 scripts/run.py 6`.

### Exit check

Why is counting clocks wrong when `in_valid=0`? Why is a one-cycle done pulse insufficient if the receiver can stall? What prevents a tenth input from overwriting the completed transaction? One register holding a pending result will be enough for the Day 7 design.
