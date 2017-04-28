:- module(puzzle,[]).

:- use_module(library(lists)).
:- use_module(print_utils).
:- use_module(parser).
:- use_module(library(plunit)).


%max_depth(1000).

cycle_limit(1000).

get_X_dim([H|_], Y_dim) :-	length(H, Y_dim).
get_Y_dim(Y, Y_dim) :- length(Y, Y_dim).

/**
  * coord(+P, +X, -Row, -Col)
  *
  * from linear index to row, col based on X (length of row)
  */
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
	% Get index of zero
	nth0(ZeroPos, Board, 0),
    % Get X,Y coordinations of zero
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

/**
  * swap(+Current, +P, +M, -Update)
  *
  * swap elements at position P and M
  */
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

/** isSolution(+List)
  * Check if given list is a puzzle solution
  */
isSolution([]) .
isSolution([_]) .
isSolution([X,Y|Z]) :- (X =< Y; Y =:= 0), X \= 0, isSolution( [Y|Z] ) .

/**
  * dfs(+S, +X, +Y, -Moves)
  *
  * Search with DFS algoritm for solution
  * Works only for small problems (2x2)
  */
  %dfs(S, X, Y, []) :- trace, dfs(S, X, Y, [S]).
dfs(S, X, Y, Moves):- isSolution(S), print_moves(Moves, X, Y).
dfs(Current, X, Y, Moves) :-
        get_move(Current, P, X, Y, M),
        swap(Current, P, M, Update),
        \+member(Update, Moves),
        % We want the sequence in correct order
        append(Moves, [Update], MM),
        dfs(Update, X, Y, MM).

dls(S, X, Y, _, Moves):- isSolution(S), print_moves(Moves, X, Y).
dls(Current, X, Y, D, Moves) :-
        D > 0,
        get_move(Current, P, X, Y, M),
        swap(Current, P, M, Update),
        \+member(Update, Moves),
        % We want the sequence in correct order
        append(Moves, [Update], MM),
        D1 is D - 1,
        dls(Update, X, Y, D1, MM).

start(F, X, Y, M) :- writeln("begin"), start(F, X, Y, M, 1).
start(F, X, Y, M, N) :-
    NN is N+1,
    writeln(NN),
    \+dls(F, X, Y, NN, M) -> start(F, X, Y, M, NN); !.
    %dls(F, X, Y, NN, M).

main :-
    parse_input(NL),

    % Get X, Y dimensions
    get_X_dim(NL, X_dim),
    get_Y_dim(NL, Y_dim),
    %X_dim is 2,
    %Y_dim is 2,
    format("X: ~w, Y: ~w ~n", [X_dim, Y_dim]),

    % Flatten the structure to one list
    flatten(NL, FL),
    %test_input(FL),

    % Print input puzzle
    %print_moves([FL], X_dim, Y_dim),
    %dfs(FL, X_dim, Y_dim, [FL]),
    start(FL, X_dim, Y_dim, [FL]),
    %writeln(Moves),

    % bye bye
    halt.

test_input2([1,2,3,4,5,6,7,0,8]). %,9,10,11,12,13,14,15]).
test_input([1,2,0,3]).

main_test :-
    X_dim is 2,
    Y_dim is 2,

    test_input(FL),

    %dls(FL, X_dim, Y_dim,25, [FL]),
    start(FL, X_dim, Y_dim, [FL]),

    % bye bye
    halt.

