def xor(a, b):
    """XOR two strings together.

    :param a:
    :param b:
    :return:
    """
    res = ''
    for i, j in zip(a, b):
        res += chr(i ^ j)
    return res


SUB = [0, 1, 1, 0, 1, 0, 1, 0]
N_B = 32
N = 8 * N_B

# Next keystream
def step(x):
  x = (x & 1) << N+1 | x << 1 | x >> N-1
  y = 0
  for i in range(N):
    y |= SUB[(x >> i) & 7] << i
  return y