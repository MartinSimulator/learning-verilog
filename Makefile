.PHONY: test solutions synth synth-solution
test:
	python3 scripts/run.py all
solutions:
	python3 scripts/run.py all --solution
synth:
	yosys -p 'read_verilog days/day07/starter.v; hierarchy -check -top mac9; proc; opt; check -assert; synth -top mac9; stat'
synth-solution:
	yosys -p 'read_verilog solutions/day07.v; hierarchy -check -top mac9; proc; opt; check -assert; synth -top mac9; stat'
