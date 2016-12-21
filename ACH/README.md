# Proj1

* dosahnout aspon 14 GFLOPS pri optimalizaci (nejlepsi projekty jsou 18 GFLOPS).

* pridame jedno cislo aby se zarovnalo pole (0, nebo NaN) - tak aby radek mel velikost nasobnu SIMDu (16 B)

* zarovnat adresu (N - zarovnani)
	* heap: `_mm_malloc(size, N)` pro x86 a pak `_mm_free()`
	* zasobnik: `__declspec(align(N))`
	* `__asume_aligned(name, N)` jako argument nebo nad smycku `#pragma vector aligned`

--

`3 GHz x 16 operaci = 48 GFLOPS`

memory bound - omezuje me pamet

naroky na pamet: `48 GFLOPS x 8 B = 192 GB/s` - potrebujeme

mame pamet: `DDR3 > 2 GHz x 8 B (64 b sirka) = 16 GB/s x 4 kanaly = 64 GB/s`

vysoka numericka intenzita - hodne operaci na malo dat
cache blocking - cteni velke matice - nemame dost velkou cache - neustale generuje cache miss
* transponovat matici (cist po radcich, ne po sloupcich)
* rozdelit na mensi dlazdice

## roofline model
zavislost aritmeticke intenzity na GFLOPS
sikma lajna - propustnost pameti
rovna lajna - limit CPU

*problem:* dostat data do cache a udrzet je tam (kolize, zaplneni, …)

cache bypass - napriklad `a[i] = 0` -> nepotrebuji cist -> rovnou zapisu do pameti bez cache

**SSE2** : podporuji vsechny CPU a kompilatory

SIMD - problem: cim sirsi SIMD, tim slozitejsi je krmit daty

## SSE
* v prvni generaci pouze floating point
* SSE-2: doubles, bytes, shorts, ints, 128-bit int


# Vektorizace
```C
#pragma omp parallel for reduction (+ simd)
for (i = 0; i < N; i++)
	sum += a[i] * b[i] // zavislost v +=! >> musim pouzit reduction + simd
```

**vector intrinsics a ASM nepouzivat pro vektorizaci**

`#pragma declare simd` - tato funkce se da volat v ramci vektorove smycky

`#pragma omp parralel for` - rozbije na vlakna

# Co je vektorizovatelne (!! i pri statnicich)
### Countable
musime znat pocet opakovani v dobe kompilace
smycka se rozdeli na 3 casti: nabeh, vektorizovatelne, dobeh -> pouzivat `const`

### Single entry and exit
pouze jeden exit, bez break

### Straight line code
* bez `switch`, bez maskovani, bez `if else` (bez podminek)

	>> vyresit pomoci precondition (rozdelit na dane podminky dopredu)

* Bez vnitrnich smycek

* Bez 'function calls' - vyjimkou sin, log, inline, elemental, OMP SIMD fce

Proc nejde udelat barieru v CUDA bloku?
Protoze by vsichni zastavili na bariere a cekaji az se ostatni dostanou k bariere -> deadlock


# CUDA samples (anselm):
/apps/all/CUDA/7.5.18/samples

!!!nulovat musim mimo kernel (memset)!!!

bacha na kernel
	m[x] se nenacacheuje pokud m je parametr
	zarovnavat na 32*float
	nemusim mit 1 prvek na 1 vlakno
	x-souradnice vzdy 32
	nedelat divergenci v ramci jednoho warpu

Redukce
	* scitame dve hodnoty az nam vyjde jedna hodnota
	* *divergence kodu*: ruzna vlakna v jednom warpu vykonavaji ruzne instrukce


TEST
`if (blockIdx.x == 0 && threadIdx.x == 0) sum = 0.0f;`
	--> toto nemuzu udelat, protoze kernel mi nezajistuje spousteni vporadi u threadu a bloku > musim nulovat na host

