#!/usr/bin/python3

import argparse

SUB = [0, 1, 1, 0, 1, 0, 1, 0]
GROUP_SUB = {
    '0': [],
    '1': [],
}
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


def get_base_keystream():
    """Get the base keystream used for obtaining the key itself."""
    with open('in/bis.txt', 'rb') as bis:
        with open('in/bis.txt.enc', 'rb') as bis_enc:
            return xor(bis.read(), bis_enc.read())[0:N_B]


def generate_keystream(length):
    base = get_base_keystream()
    int_base = int.from_bytes(base, 'little')

    for i in range(length//N_B):
        int_base = step(int_base)
        base += int_base.to_bytes(N_B, 'little')

    return base


def generate_group_sub():
    """Generate all the possible solutions that can lead to the ending 0 or 1."""
    for bit in [0, 1]:
        for i in range(len(SUB)):
            if SUB[i] == bit:
                GROUP_SUB[str(bit)].append(convert_to_bin(i, fill=3))


def decrypt(ciphertext_path, opentext_path):
    enc = open(ciphertext_path, 'rb').read()

    with open(opentext_path, 'wb') as dec:
        keystream = generate_keystream(len(enc))
        dec.write(xor(enc, keystream))


def convert_to_bin(x, fill=N):
    """Convert number to binary representation, stretched to given lenght and reversed."""
    return bin(x)[2:].zfill(fill)[::-1]


def rev_next(x):
    bin_x = convert_to_bin(x)
    solutions = ['0']

    for i in range(0, len(bin_x)):
        valid = []
        bit = bin_x[i]

        if i == 0:
            valid = GROUP_SUB[bit]

        for solution in solutions:
            for group in GROUP_SUB[bit]:
                if solution[-2:] == group[:2]:
                    valid.append(solution[:-2] + group)
        solutions = valid

    for sol in solutions:
        if sol[:2] == sol[-2:]:
            """The symmetrical code is the solution whilst not caring for the LSB and MSB."""
            # convert the inverted solution to int
            x = int(sol[::-1], 2)

            # invert the step function
            return (x >> 1) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff | (x & 1) << (N - 1)

    return None


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--decrypt', '-d', dest='decrypt', action='store_true')
    args = parser.parse_args()

    if args.decrypt:
        decrypt('in/hint.gif.enc', 'in/hint.gif')
        decrypt('in/super_cipher.py.enc', 'in/super_cipher.py')

    generate_group_sub()

    # First key stream block
    keystream = int.from_bytes(get_base_keystream(), 'little')

    # Apply reversed next function to the starting keystream block
    for _ in range(N//2):
        keystream = rev_next(keystream)

    # print the secret which is represented as int
    print(keystream.to_bytes(32, byteorder='little')[:29].decode())
