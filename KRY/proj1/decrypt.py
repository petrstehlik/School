from .cipher import step, N

key = []

with open('in/bis.txt', "rb") as a:
    with open('in/bis.txt.enc', "rb") as b:
        key = [chr(a ^ b) for a,b in zip(list(a.read()), list(b.read()))]


with open('in/super_cipher.py.enc', 'rb') as f:
    content = list(f.read())

    a = [chr(a) for a in content]

    code = []

    for idx, val in enumerate(content):
        try:
            res = val ^ ord(key[idx])
            code.append(chr(res))
        except:
            if idx % 32 == 0:
                print(idx)
                res = step(int.from_bytes(''.join(key[0:32]).encode(), 'little'))

                for i in range(N):
                    res = step(res)

                c = []
                # print(res)
                print(int.from_bytes(content[idx:idx+32], 'little') ^ res)


print("".join(code))
# for idx, i in enumerate(key):
#    print(i, end='')
