from z3 import Solver, Bool, And, Not, Or, sat
from binascii import unhexlify

BYTE = 8


solver = Solver()

# Generate seed for 32 bytes
seed = [Bool(str(i)) for i in range(256)]


def generate_rule(x, y, z):
    return Or(
        And(Not(x), Not(y), z), # 001 = 1 -> 1
        And(Not(x), y, Not(z)), # 010 = 2 -> 1
        And(x, Not(y), Not(z)), # 100 = 4 -> 1
        And(x, y, Not(z))       # 110 = 6 -> 1
    )


def next(x):
    x = [x[-1]] + x + [x[0]]
    return [generate_rule(x[i + 2], x[i + 1], x[i]) for i in range(256)]


target = 76211941219306483308438160659696441778580117862091753644088139169460760844864
next_value = seed

for i in range(BYTE):
    next_value = next(next_value)

for i in range(256 // BYTE):
    found = False
    # take a snapshots of the solver constraints
    solver.push()
    for j in range(256):
        bit = ((1 << j) & target) >= 1
        solver.add(next_value[j] == bit)
    if solver.check() == sat:
        m = solver.model()
        ans = 0
        for j in range(256):
            ans |= (1 if m[seed[j]] else 0) << j
        # renew the target
        target = ans

        if b'KRY' in unhexlify('%064x' % ans)[::-1]:
            found = True
            print(ans.to_bytes(32, byteorder='little')[:29].decode())
    # restore the snapshot
    solver.pop()

    if found:
        break
