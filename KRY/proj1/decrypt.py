"""Decrypt GIF hint.gif.enc"""

from helpers import xor, step, N_B


def get_base_keystream():
    """Get the base keystream used for obtaining the key itself."""
    with open('in/bis.txt', 'rb') as bis:
        with open('in/bis.txt.enc', 'rb') as bis_enc:
            return xor(bis.read(), bis_enc.read())[0:N_B]


def generate_keystream(len):
    base = get_base_keystream()
    int_base = int.from_bytes(base, 'little')

    for i in range(len//N_B):
        int_base = step(int_base)
        base += int_base.to_bytes(N_B, 'little')

    return base


def decrypt(ciphertext_path, opentext_path):
    enc = open(ciphertext_path, 'rb').read()

    with open(opentext_path, 'wb') as dec:
        keystream = generate_keystream(len(enc))
        dec.write(xor(enc, keystream))


if __name__ == '__main__':
    print(int.from_bytes(get_base_keystream(), 'little'))

    decrypt('in/hint.gif.enc', 'in/hint.gif')
    decrypt('in/super_cipher.py.enc', 'in/super_cipher.py')
