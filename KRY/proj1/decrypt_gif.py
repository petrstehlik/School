"""Decrypt GIF hint.gif.enc"""

from helpers import xor, step
import utils

key = []

SUB = [0, 1, 1, 0, 1, 0, 1, 0]
N_B = 32
N = 8 * N_B

"""
with open('in/bis.txt', "rb") as a:
    with open('in/bis.txt.enc', "rb") as b:
        key = xor(a.read(), b.read())

with open('in/hint.gif.enc', 'rb') as g:
    hint = g.read()

    partial_key = key[:N_B]

    out = open('in/hint.gif', 'wb')

    new_key = []
    new_key_step = int.from_bytes(partial_key.encode(), 'little')

    for j in partial_key:
        new_key.append(ord(j))

    for i in range(0, len(hint), 32):

        res = xor(new_key, hint[i:i+32])

        out.write(res.encode())

        new_key_step = step(new_key_step)
        new_key = new_key_step.to_bytes(32, byteorder='little')
"""

c1 = open('in/bis.txt', 'rb').read()
c2 = open('in/bis.txt.enc', 'rb').read()
c3 = open('in/hint.gif.enc', 'rb').read()
c4 = open('in/hint.gif', 'wb')

k = utils.xor(c1,c2)[:N_B]
k = utils.from_bytes(k)
print k

for i in range(0, len(c3), 32):
    c4.write(utils.xor(utils.from_int(k), c3[i:i+32]))
    k = step(k)

c4.close()


