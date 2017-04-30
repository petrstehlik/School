/**
  * \brief Parser for n-puzzle matrices where * is represented with 0
  *
  * \author Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
  * \date 2017/04/30
  */

:- module(parser,
      [
          parse_input/1,
          remove_duplicates/2
      ]).

/** FLP 2015
Toto je ukazkovy soubor zpracovani vstupu v prologu.
Tento soubor muzete v projektu libovolne pouzit.

autor: Martin Hyrs, ihyrs@fit.vutbr.cz


preklad: swipl -q -g start -o flp16-log -c input2.pl
*/

% Reads line from stdin, terminates on LF or EOF.
read_line(L,C) :-
	get_char(C),
	(isEOFEOL(C), L = [], !;
		read_line(LL,_),
		[C|LL] = L).

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

parse_input(Lines) :-
	prompt(_, ''),
	read_lines(LL),
	split_lines(LL,S),
	convert_lines(S, NL),
	Lines = NL.


/**
  * Original source: https://stackoverflow.com/questions/39435709/
  *
  * Remove duplicates from a list
  */
remove_duplicates([],[]).
remove_duplicates([H], [H]).
remove_duplicates([H | T], List) :-
	member(H, T),
	remove_duplicates(T, List).

remove_duplicates([H|T], [H|T1]) :-
	\+member(H, T),
	remove_duplicates(T, T1).

remove_duplicates([H, H|T], List) :-
	remove_duplicates([H|T], List).

remove_duplicates([H, Y|T], [H|T1]) :-
	Y \= H,
	remove_duplicates([Y|T], T1).


