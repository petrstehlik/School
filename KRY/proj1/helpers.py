SUB = [0, 1, 1, 0, 1, 0, 1, 0]
N_B = 32
N = 8 * N_B


def xor(x, y):
    # XOR 2 bytearrays into one
    result = []
    for a, b in zip(x, y):
        result.append(a ^ b)
    return bytearray(result)


# Next keystream
def step(x):
  x = (x & 1) << N+1 | x << 1 | x >> N-1
  y = 0
  for i in range(N):
    y |= SUB[(x >> i) & 7] << i
  return y