:- module(print_utils,
      [print_num/1,
          print_num_space/1,
          print_line/1,
          part/3,
          print_matrix/2,
          print_moves/3
      ]).

print_num(X) :- (X == 0, write('*')); write(X).
print_num_space(X) :- write(" "), print_num(X).

print_line([H|L]) :-
    print_num(H),
    maplist(print_num_space, L),
    nl.

part([], _, []).
part(L, N, [DL|DLTail]) :-
   length(DL, N),
   append(DL, LTail, L),
   part(LTail, N, DLTail).

print_matrix(M, X) :-
    part(M, X, NM),
    maplist(print_line, NM).

print_moves([], _, _):-!.
print_moves([M|[]], X, _) :- print_matrix(M, X).
print_moves([M|Moves], X, Y) :-
    %writeln(M),
    print_matrix(M, X),
    nl,
    print_moves(Moves, X, Y).

