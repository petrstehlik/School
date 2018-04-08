#!/usr/bin/python3

SUB = [0, 1, 1, 0, 1, 0, 1, 0]
ISUB = {
    '0': [],
    '1': [],
}
N_B = 32
N = 8 * N_B


def convert_to_bin(x, fill=N):
    """Convert number to binary representation, stretched to given lenght and reversed."""
    return bin(x)[2:].zfill(fill)[::-1]


def stretch(y):
    """Stretch from 32 to 34 bytes"""
    return (y >> 1) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff


def rev_next(x):
    binin = convert_to_bin(x)
    valid = ['']
    for i in range(0, len(binin)):
        bit = binin[i]
        newvalid = []

        for v in valid:
            for group in ISUB[bit]:
                if i > 0 and v[-2:] == group[:2]:
                    newvalid.append(v[:-2] + group)
                elif i == 0:
                    newvalid.append(group)
        valid = newvalid

    for v in valid:
        """Return the one which is symmetrical"""
        if v[:2] == v[-2:]:
            return int(v[::-1], 2)

    return None


if __name__ == '__main__':
    for bit in [0, 1]:
        for i in range(len(SUB)):
            if SUB[i] == bit:
                ISUB[str(bit)].append(convert_to_bin(i, fill=3))

    # First key stream block
    y = 76211941219306483308438160659696441778580117862091753644088139169460760844864

    for c in range(N//2):
        step = rev_next(y)
        x = stretch(step)
        y = x

    # print the secret which is represented as int
    print(y.to_bytes(32, byteorder='little')[:29].decode())
