:- module(puzzle,[]).

:- use_module(library(lists)).
:- use_module(print_utils).
:- use_module(parser).
:- use_module(library(plunit)).


%max_depth(1000).


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

