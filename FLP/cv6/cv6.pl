:- dynamic velikost/2, pozice/2.

/**
  * @brief check if element in array
  */
prvek(H, [H|_]) :- !.
prvek(H, [_|T]) :- prvek(H,T).

/**
  * @brief Get a difference of two groups
  */
rozdil([], _, []).
rozdil([H|T], S, R) :- prvek(H, S), !, rozdil(T, S, R).
rozdil([H|T], S, [H|P]) :- rozdil(T, S, P).


sequence(0, []) :- !.
sequence(N, [N|T]) :- NewN is N -1, sequence(NewN, T).
/**
vygeneruje vsechny mozne
 sequence(1, L), permutation(L, R).
 */

queens(Solution) :- queens(8, Solution).
queens(N, Solution) :-
    sequence(N, List),
    permutation(List, Solution),
    test(Solution).


test([]) :- !.
test([H|T]) :- test(H,1,T), test(T).

test(_, _, []) :- !.
test(Pos, Dist, [H|T]) :-
Pos \= H,
X is abs(Pos-H),
X \= Dist,
Dn is Dist+1,
test(Pos, Dn, T).
/*    H #\= Pos + Dist,
    H #\= Pos - Dist,
    M is Dist+1,
    test(Pos, M, T).
*/


testPoz(X,Y) :- velikost(XR, YR),
X > 0, Y > 0,
X =< XR, Y =< YR.

skok(X,Y,XN,YN) :- XN is X + 2, YN is Y + 1, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X + 2, YN is Y - 1, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X - 2, YN is Y + 1, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X - 2, YN is Y - 1, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X + 1, YN is Y + 2, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X + 1, YN is Y - 2, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X - 1, YN is Y + 2, testPoz(XN, YN).
skok(X,Y,XN,YN) :- XN is X - 1, YN is Y - 2, testPoz(XN, YN).

% assert(velikost(3,3)).

cesta(X,Y,X,Y,[X:Y]) :- !.
% prida pozici a zanori se do rekurze a pak pri vynorovani je odmazava
cesta(X,Y,XE,YE,[X:Y|T]) :-
    assert(poz(X,Y)),
    skok(X,Y, XN, YN),
    \+ poz(XN, YN), % not
    cesta(XN, YN, XE, YE, T).

% odebere pozici
cesta(X, Y, XE, YE, _) :-
    retract(poz(X,Y)), fail.

cesty(XR, YR, XS, YS, XE, YE, N) :-
    XR > 0, YR > 1,
    assert(velikost(XR, YR)),
    testPoz(XS, YS),
    testPoz(XE, YE),
    findall(C, cesta(XS, YS, XE, YE, C), B),
    lenght(B, N),
    retractall(poz(_,_)),
    retract(velikost(_,_)).


% jmeno, klic, hodnota
% kontroly - volna promenna, konci neuspechem a nic nedelej
slovnik(D, _, _) :- var(D), !, fail;
% to stejne jako pred tim
slovnik(_, K, V) :- var(K), var(V), !, fail.
% vyhledani hodnoty - nejdi nikam dal
slovnik(D, K, V) :- var(V), !, call(D,K,V).
% vyhledani klicu pomoci bagof
slovnik(D, K, V) :- var(K), !,
    G =.. [D,X,V], bagof(X, G, K).
% modifikace
slovnik(D, K, V) :-
    O =.. [D, K, _], call(O), !, retract(O),
    N =.. [D, K, V], assert(N).
% vlozeni
slovnik(D, K, V) :- N =.. [D, K, V], assert(N).



