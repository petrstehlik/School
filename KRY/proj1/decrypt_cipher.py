from helpers import xor

key = []

with open('in/bis.txt', "rb") as a:
    with open('in/bis.txt.enc', "rb") as b:
        key = xor(a.read(), b.read())


# Decrypt the super cipher
with open('in/super_cipher.py.enc', 'rb') as f:
    content = f.read()

    res = xor(key, list(content))

    res = [chr(i) for i in res]

    with open('in/super_cipher.py', 'w') as sc:
        sc.write(''.join(res))