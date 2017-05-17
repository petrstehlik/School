faktorial(0,1).
faktorial(N, Vysledek) :-
    N > 0,
    N1 is N-1,
    faktorial(N1, PredchoziVysledek),
    Vysledek is PredchoziVysledek * N.
