/*
 * KRY project 2
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Description:
 * License: GNU GPL
 *
 * Acknowledgment: this program uses external library GMP
 **/

#include <iostream>
#include <unistd.h>
#include <string>
#include <vector>
#include <gmp.h>
#include <gmpxx.h>
#include <random>
#include <chrono>

using namespace std;

gmp_randclass rand_generator(gmp_randinit_mt);
mpz_class two = 2;

void printHelp() {
    cout << "Print help" << endl;
}

mpz_class modInverse(mpz_class a, mpz_class m) {
    a = a % m;
    for (mpz_class x = 1; x < m; x++)
       if ((a*x) % m == 1)
          return x;

    throw MATH_ERREXCEPT;
}

// https://stackoverflow.com/questions/23745526/calculate-the-multiplicative-inverse-of-large-numbers-using-c
mpz_class mulInverse(mpz_class a, mpz_class n)
{
    mpz_class t = 0;
    mpz_class newt = 1;
    mpz_class r = n;
    mpz_class newr = a;
    mpz_class quotient;

    while (newr != 0) {
        quotient = r / newr;
        tie(t, newt) = make_tuple(newt, t - quotient * newt);
        tie(r, newr) = make_tuple(newr, newr = r - quotient * newr);
    }

    if (r > 1)
        throw runtime_error("this number is not invertible");
    if (t < 0)
        t += n;

    return t;
}

// https://www.sanfoundry.com/cpp-program-implement-miller-rabin-primality-test/
bool millerRabinPrimeCheck(mpz_class n) {
    if (n == 1 || n == 3) {
        return true;
    } else if(n < 0) {
        throw MATH_ERREXCEPT;
    }

    mpz_class s, p;

    s = 0;
    p = n - 1;

    while (p % 2 == 0) {
        p /= 2;
        s++;
    }

    for (int i = 0; i < 128; i++) {
        mpz_class a = rand_generator.get_z_range(n - 2) % (n - 1) + 1;
        mpz_class tmp = p;
        mpz_class mod;

        mpz_powm(mod.get_mpz_t(), a.get_mpz_t(), p.get_mpz_t(), n.get_mpz_t());

        for (int j = 1; j < s; j++) {
            mpz_powm_ui(mod.get_mpz_t(), mod.get_mpz_t(), 2, n.get_mpz_t());

            if (mod == 1)
                return false;

            if (mod == n - 1)
                break;
        }

        if (mod != (n-1))
            return false;
    }

    return true;
}

// generate a prime number with checks by Miller-Rabin algorithm
mpz_class generatePrime(mpz_class start, mpz_class end) {
    mpz_class prime = (rand_generator.get_z_range(end - start) + start + 1) | 1;

    while(!millerRabinPrimeCheck(prime))
        prime += 2;

    return prime;
}

// find greatest common divisor
// this one is really slow
mpz_class findGCD(mpz_class a, mpz_class b) {
    mpz_class gcd;
    for (mpz_class i = 1; i <= a && i <= b; i++) {
        if (a % i == 0 && b % i == 0) {
            gcd = i;
        }
    }
    return gcd;
}

// fast GCD
// https://www.codeproject.com/tips/156748/fast-greatest-common-divisor-gcd-algorithm
mpz_class binaryGCD(mpz_class a, mpz_class b) {
    mpz_class gcd;
	while (b != 0) {
		gcd = b;
		b = a % b;
		a = gcd;
	}
	return gcd;
}

void generate(int b) {
    if (b > 96) {
        cerr << "Too many bits to generate" << endl;
        exit(1);
    } else if (b < 6) {
        cerr << "Too little bits to generate" << endl;
        exit(1);
    }

    mpz_class s, end, n, start, phi, d;

    mpz_pow_ui(s.get_mpz_t(), two.get_mpz_t(), b - 1);
    mpz_pow_ui(end.get_mpz_t(), two.get_mpz_t(), b);

    start = s * sqrt(2);

    // generate P and Q
    mpz_class p = generatePrime(start, end);
    mpz_class q = generatePrime(start, end);

    // calculate PHI
    phi = (p-1) * (q-1);

    // calculate E
    mpz_class e = rand_generator.get_z_range(phi);

    while(binaryGCD(e, phi) != 1) {
        e = rand_generator.get_z_range(phi);
    }

    // calculate D
    d = mulInverse(e, phi);

    // print everything
    cout << hex << showbase << p << " ";        // P
    cout << hex << showbase << q << " ";        // Q
    cout << hex << showbase << p * q << " ";    // N
    cout << hex << showbase << e << " ";        // E
    cout << hex << showbase << d << endl;       // D
}

void encrypt(mpz_class e, mpz_class n, mpz_class m) {
    mpz_class ciphertext;

    mpz_powm_sec(ciphertext.get_mpz_t(), m.get_mpz_t(), e.get_mpz_t(), n.get_mpz_t());

    cout << hex << showbase << ciphertext << endl;
}

void decrypt(mpz_class d, mpz_class n, mpz_class ciphertext) {
    mpz_class plaintext;

    mpz_powm_sec(plaintext.get_mpz_t(), ciphertext.get_mpz_t(), d.get_mpz_t(), n.get_mpz_t());

    cout << hex << showbase << plaintext << endl;
}

int main (int argc, char *argv[])
{
    rand_generator.seed(time(NULL));
    char c;

    while ((c = getopt (argc, argv, "hgedb")) != -1) {
		switch (c) {
			case 'g':
                while (true) {
                    try {
                        generate(stoi(argv[2]));
                        break;
                    } catch (const runtime_error &e) {}
                }
                break;
            case 'e': {
                mpz_class e, n, m;
                e = argv[2];
                n = argv[3];
                m = argv[4];
                encrypt(e, n, m);
                break;
            }
            case 'd': {
                mpz_class d, n, c;
                d = argv[2];
                n = argv[3];
                c = argv[4];
                decrypt(d, n, c);
                break;
            }
			case 'h':
				printHelp();
				return EXIT_SUCCESS;
			default:
				cerr << "Unsupported argument"<< endl;
				printHelp();
				return EXIT_FAILURE;
		}
	}
}

