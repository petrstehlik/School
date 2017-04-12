
% mnozina vsetkych podmnozin
% subbags([a,b,c],S).
% append - vstavany predikat spaja dva zoznamy
subbags([], [[]]).
subbags([X|XS], P) :- subbags(XS,A), addOneToAll(X,A,B), append(A,B,P).

% addOneToAll(a, [[a,b],[c,d],[10,5]], H).
addOneToAll(_, [], []).
addOneToAll(E, [L|LS], [[E|L]|T]) :- addOneToAll(E,LS,T).





:- dynamic robot/2, dira/1.

obsazeno(P) :- robot(_, P); dira(P).
vytvor(I, P) :- not(obsazeno(P)), assertz(robot(I, P)).
vytvor(P) :- not(obsazeno(P)), assertz(dira(P)).

odstran(P) :- retract(dira(P)); retract(robot(_,P)).

% TODO
% svet(S, 0, 20).

obsazene_pozice(X) :- bagof(P, obsazeno(P), X).
obsazene_roboty(X) :- bagof(P, I^robot(I,P), X).

inkrementuj(X,Y) :- Y is X+1.
dekrementuj(X,Y) :- Y is X-1.

pohni(I, Operace) :-
	robot(I,P),
	retract(robot(I,P)),
	call(Operace, P, Q),
	(obsazeno(Q) -> 
		(robot(_, Q) ->	 odstran(Q); true)
	;
		assertz(robot(I,Q))	
	).

doleva(I) :- pohni(I, dekrementuj).
doprava(I) :- pohni(I, inkrementuj).

armageddon :- forall(robot(_,P), vybuch(P)).
vybuch(P) :- odstran(P), vytvor(P).




g_size(3).

g_test(X:Y) :-
	g_size(S),
	X > 0, X =< S,
	Y > 0, Y =< S.

g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 + 0, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 - 1, Y2 is Y1 + 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 0, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 0, Y2 is Y1 + 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 - 1, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 + 0, g_test(X2:Y2).
g_move(X1:Y1, X2:Y2) :- X2 is X1 + 1, Y2 is Y1 + 1, g_test(X2:Y2).

g_one(X:Y, Len, L, Res) :-
	Res = [X:Y|L], % neni pozpatku?
	length(Res, Len).

g_one(X:Y, Len, L, R) :-
	g_move(X:Y, Xn:Yn),
	\+ memberchk(Xn:Yn, L),
	g_one(Xn:Yn, Len, [X:Y|L], R).

g_all(R, Len) :- g_one(2:2, Len, [], R).
g_all(R, Len) :-
	g_move(2:2, X:Y),
	g_one(X:Y, Len, [], R).
	
g_allLength(R) :- g_allLength(R, 1).
g_allLength(R, Len) :- g_all(R, Len).
g_allLength(R, Len) :- 
	Len1 is Len + 1,
	g_allLength(R, Len1).