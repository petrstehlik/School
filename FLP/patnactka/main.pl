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

initialize(Target, Start, Moves, X, Y) :-
    empty_nb_set(E),
    writeln("E set emptied"),
    solve(E, Target, Start, Moves, X, Y).

solve(_, Target, Target, [], _, _) :- !.
solve(S, Target, Current, [Move|Ms], X, Y) :-
    trace,
    add_to_seen(S, Current),
    setof(Dist-M-Update,
        (
            trace,
            get_move(Current, P, X, Y, M),
            swap(Current, P, M, Update),
            distance(Target, Update, Dist, X)
            %writeln(Dist-M-Update)
        ), Moves),
    trace,
    member(_-Move-U, Moves),
    solve(S, Target, U, Ms, X, Y).

%%  distance(+Current, +Target, -Dist)
%
%   compute Manatthan distance between equals values
%
distance(Current, Target, Dist, X) :-
    aggregate_all(sum(D),
    (
        nth0(P, Current, N),
        coord(P, X, Rp, Cp),
        nth0(Q, Target, N),
        coord(Q, X, Rq, Cq),
        D is abs(Rp - Rq) + abs(Cp - Cq)
    ), Dist).


%%  add_to_seen(+S, +Current)
%
%   fail if already in, else store
%
add_to_seen(S, L) :-
    %term_to_atom(L, A),
    format("Add to seen: ~w ~n", [L]),
    findall(C, (nth0(I, L, D), C is D*10^I), Cs),
    sum_list(Cs, A),
    add_nb_set(A, S, true).

test_input([1,2,3,4,5,6,7,8,9,10,11,12,13,0,14,15]).

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

