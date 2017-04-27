:- use_module(library(lists)).

max_depth(1000).

% Reads line from stdin, terminates on LF or EOF.
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),
		% atom_codes(C,[Cd]),
		L = [C|LL]
		%(atom_number(C,X), L = [X|LL];
		%L = [0|LL])
	).

% Tests if character is EOF or LF.
isEOFEOL(C) :-
	C == end_of_file;
	(char_code(C,Code), Code==10).

read_lines(Ls) :-
	read_line(L,C),
	( C == end_of_file, Ls = [] ;
	  read_lines(LLs), Ls = [L|LLs]
	).



% rozdeli radek na podseznamy
split_line([],[[]]) :- !.
split_line([' '|T], [[]|S1]) :- !, split_line(T,S1).
split_line([32|T], [[]|S1]) :- !, split_line(T,S1).    % aby to fungovalo i s retezcem na miste seznamu
split_line([H|T], [[H|G]|S1]) :- split_line(T,[G|S1]). % G je prvni seznam ze seznamu seznamu G|S1

% vstupem je seznam radku (kazdy radek je seznam znaku)
split_lines([],[]).
split_lines([L|Ls],[H|T]) :- split_lines(Ls,T), split_line(L,H).

/** prevede seznam cislic na cislo */
% pr.: cislo([1,2,'.',3,5],X). X = 12.35
cislo(N,X) :- cislo(N,0,X).
cislo([],F,F).
cislo(['.'|T],F,X) :- !, cislo(T,F,X,10).
cislo([HH|T],F,X) :- (atom_number(HH, H), FT is 10*F+H, cislo(T,FT,X)); X = 0.
cislo([],F,F,_).
cislo([H|T],F,X,P) :- FT is F+H/P, PT is P*10, cislo(T,FT,X,PT).

convert_numlist([],[]):-!.
convert_numlist([H|T], [X|NL]) :-
	cislo(H, X),
	convert_numlist(T, NL).

convert_lines([],[]):-!.
convert_lines([H|S], [NumList|NL]) :-
	convert_numlist(H, NumList),
	convert_lines(S, NL).


print_lines([]).
print_lines([H|T]) :-
	print_line(H),
	write('\n'),
	print_lines(T).

print_line([H|[]]) :-
	(H == 0, write('*'));
	write(H).
print_line([H|T]) :-
	((H == 0, write('*'));
	write(H)),
	write(' '),
	print_line(T).

print_num(X) :- (X == 0, write('*')); write(X).

/**
  * flat_print/3
  *
  * Print the flattened layout
  */
flat_print(L, X, Y) :- flat_print(L, X, Y, 0, 0), !.
flat_print([H|[]], _, _, _, _) :- write("last"), print_num(H), nl.
/**
  * X, Y - dimensions
  */
flat_print([H|T], X, Y, AX, AY) :-
	format("number: ~w ~n", [H]),
	(X > AX ->
		(print_num(H), write(" "));
		(write("\n"), print_num(H))),
	AX is AX + 1,
	flat_print(T, X, Y, AX, AY).

parse_input(Lines) :-
	prompt(_, ''),
	read_lines(LL),
	split_lines(LL,S),
	convert_lines(S, NL),
	Lines = NL.

get_X_dim([H|_], Y_dim) :-	length(H, Y_dim).
get_Y_dim(Y, Y_dim) :- length(Y, Y_dim).

%%  coord(+P, +X, -Row, -Col)
%
%   from linear index to row, col
%   based on X (length of row)
%
coord(P, X, Row, Col) :-
    Row is P // X,
    Col is P mod X.

/**
  * get_move(+Board, +ZeroPos, +X, +Y, -Q) is semidet
  *
  * Board - the board where we are working
  * ZeroPos - current 0's position
  * X, Y - dimensions
  * Q - new 0's position
  *
  * based only on coordinations, get next empty cell index
  */
get_move(Board, ZeroPos, X, Y, Q) :-
	% get index of zero
	nth0(ZeroPos, Board, 0),
	format("Zero is at: ~w ~n", [ZeroPos]),
	coord(ZeroPos, X, Row, Col),
	(
		% shift down
		Row < Y - 1, Q is ZeroPos + X
		% shift up
	;	Row > 0, Q is ZeroPos - X
		% shift right
	;	Col < X - 1, Q is ZeroPos + 1
		% shift left
	;	Col > 0, Q is ZeroPos - 1
	).

%%  apply_move(+Current, +P, +M, -Update)
%
%   swap elements at position P and M
%
swap(Current, P, M, Update) :-
    assertion(nth0(P, Current, 0)), % constrain to this application usage
    ( P > M -> (F,S) = (M,P) ; (F,S) = (P,M) ),
    nth0(S, Current, Sv, A),
    nth0(F, A, Fv, B),
    nth0(F, C, Sv, B),
    nth0(S, Update, Fv, C).


/**
  * Get a solution for given length
  */
solution(Len, Seq) :-
	numlist(1, Len, X),
	append(X, [0], Seq).

main :-
	parse_input(NL),
	get_X_dim(NL, X_dim),
	get_Y_dim(NL, Y_dim),
	format("X: ~w, Y: ~w ~n", [X_dim, Y_dim]),
	print_lines(NL),
	writeln(NL),
	writeln("flattening"),
	flatten(NL, FL),
	writeln(FL),
	bagof(FL, (get_move(FL, P, X_dim, Y_dim, Q), swap(FL, P, Q, NQ)), Moves),
	%get_move(FL, P, X_dim, Y_dim, Q),
	format("Q: ~w ~n", [LLL]),
	%move_left(FL, X_dim, NFL),
	writeln(P),
	halt.

