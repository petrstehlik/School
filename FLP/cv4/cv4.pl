% FLP CVICENI 4 - PROLOG 1 - UVOD

% ukazka predikatu pro vypocet funkce faktorial
factorial( 0, 1 ).
factorial( N, Value ) :-
     N > 0,
     Prev is N - 1,
     factorial( Prev, Prevfact ),
     Value is Prevfact * N.

% databaze rodinnych vztahu
muz(jan).
muz(pavel).
muz(robert).
muz(tomas).
muz(petr).

zena(marie).
zena(jana).
zena(linda).
zena(eva).

otec(tomas,jan).
otec(jan,robert).
otec(jan,jana).
otec(pavel,linda).
otec(pavel,eva).

matka(marie,robert).
matka(linda,jana).
matka(eva,petr).

% Implementujte nasledujici predikaty:

rodic(X,Y) :- matka(X,Y);otec(X,Y).
sourozenec(X,Y) :- rodic(R,X), rodic(R,Y), X\=Y.
sestra(X,Y) :- zena(X), sourozenec(X,Y).
deda(X,Y) :- otec(X,T),rodic(T,Y).
je_matka(X) :- zena(X),matka(X,_).
teta(X,Y) :- sestra(X,Y).


% Seznamy:
neprazdny([_|_]) :- true.
hlavicka([H|_], H).
posledni([H], H) :- !.
posledni([_|T], Res) :- posledni(T, Res).


% Dalsi ukoly:
spoj([],L,L).
spoj([H|T], L, [H|TT]) :- spoj(T,L,TT).
obrat([],[]).
obrat([H|T], Res) :- spoj(N,[H],Res),obrat(T,N).

% Ref reseni
% obrat([H|T], Res) :- obrat(T,N),spoj(N,[H],Res).

sluc(L, [], L).
sluc([], L, L).
sluc([X|XS], [Y|YS], [X|T]) :- X @< Y,spoj(XS,[Y|YS], T).
sluc([X|XS], [Y|YS], [Y|T]) :- X @>= Y,spoj([X|XS], YS, T).

serad([], []).
serad([H|T], SL) :- serad(T,ST), sluc([H], ST, SL).


plus(X,Y,Z) :- Z is X + Y.

split([],[[]]) :- !.
split([' '|T], [[]|S1]) :- !,split(T,S1).
split([H|T], [[H|G]|S1]) :- split(T,[G,S1]).

% zipWith()
