"""Integer reference and deterministic test vectors; Python standard library only."""
from pathlib import Path
import random
import sys

def dot(pixels, coeffs):
    assert len(pixels) == len(coeffs) == 9
    assert all(0 <= p <= 255 for p in pixels)
    assert all(-128 <= c <= 127 for c in coeffs)
    return sum(p*c for p,c in zip(pixels, coeffs))

def correlate_valid(image, kernel):
    """3x3 correlation, stride 1, no padding; output shape (H-2,W-2)."""
    h,w = len(image),len(image[0])
    assert h >= 3 and w >= 3 and all(len(row)==w for row in image)
    return [[dot([image[y+dy][x+dx] for dy in range(3) for dx in range(3)],kernel)
             for x in range(w-2)] for y in range(h-2)]

def write_pgm(path, image):
    # Visualization only: preserve raw signed results separately for verification.
    h,w = len(image),len(image[0])
    values = [min(255,abs(v)) for row in image for v in row]
    path.write_text('P2\n%d %d\n255\n%s\n' % (w,h,' '.join(map(str,values))))

def generate(destination):
    destination=Path(destination); destination.mkdir(parents=True,exist_ok=True)
    # A vertical edge, asymmetric in location, with minor row variation.
    image=[[10+y if x<3 else 200+y for x in range(6)] for y in range(6)]
    kernel=[-1,0,1,-2,0,2,-1,0,1]
    filtered=correlate_valid(image,kernel)
    cases=[]
    for y in range(4):
        for x in range(4):
            pixels=[image[y+dy][x+dx] for dy in range(3) for dx in range(3)]
            cases.append((pixels,kernel[:]))
    cases += [([0]*9,[127]*9),([255]*9,[127]*9),([255]*9,[-128]*9),
              (list(range(1,10)),kernel[:]),([255]*9,[-1,1,-1,1,0,1,-1,1,-1])]
    rng=random.Random(2026)
    cases += [([rng.randrange(256) for _ in range(9)],
               [rng.randrange(-128,128) for _ in range(9)]) for _ in range(100)]
    with (destination/'pairs.txt').open('w') as f:
        for pixels,coeffs in cases:
            for p,c in zip(pixels,coeffs): f.write(f'{p} {c}\n')
    expected=[dot(p,c) for p,c in cases]
    (destination/'expected.txt').write_text(str(len(cases))+'\n'+'\n'.join(map(str,expected))+'\n')
    write_pgm(destination/'input.pgm',image)
    write_pgm(destination/'golden_edge.pgm',filtered)
    (destination/'golden_signed.txt').write_text('\n'.join(' '.join(map(str,r)) for r in filtered)+'\n')
    assert dot(list(range(1,10)),kernel)==8
    assert dot([255]*9,[-128]*9)==-293760
    assert filtered==[[0,760,760,0]]*4
    return len(cases)

if __name__ == '__main__':
    dest=Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).resolve().parents[1]/'build/reference'
    print(f'Generated {generate(dest)} cases in {dest}')
