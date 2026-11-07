"""Compile one RTL implementation with its bench; fail on tool errors/timeouts."""
from pathlib import Path
import argparse
import shutil
import subprocess
import sys
from reference import generate

ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser()
parser.add_argument('day',choices=['smoke','all']+[str(i) for i in range(1,8)])
parser.add_argument('--solution',action='store_true')
args=parser.parse_args()
for tool in ('iverilog','vvp'):
    if not shutil.which(tool):
        sys.exit(f'{tool} missing. See docs/SETUP.md; on Homebrew: brew install icarus-verilog')
days=list(range(1,8)) if args.day=='all' else [args.day if args.day=='smoke' else int(args.day)]
try:
    for day in days:
        label='smoke' if day=='smoke' else f'day{day:02}'
        dest=ROOT/'build'/((label+'-solution') if args.solution else label)
        dest.mkdir(parents=True,exist_ok=True)
        if day=='smoke': files=[ROOT/'scripts/smoke.sv']
        else:
            rtl=ROOT/'solutions'/f'{label}.v' if args.solution else ROOT/'days'/label/'starter.v'
            files=[rtl,ROOT/'days'/label/'tb.sv']
        if day==7: generate(dest)
        subprocess.run(['iverilog','-g2012','-Wall','-s','tb','-o',str(dest/'sim')]+list(map(str,files)),check=True,timeout=60,cwd=dest)
        subprocess.run(['vvp',str(dest/'sim')],check=True,timeout=60,cwd=dest)
except (subprocess.CalledProcessError,subprocess.TimeoutExpired) as error:
    sys.exit(f'FAIL {label}: {error}')
