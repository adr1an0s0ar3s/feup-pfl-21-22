:- [utils].

display_game([L | R]) :-
    nl,
    length(L, X),
    display_header(X),
    nl, nl,
    display_matrix([L | R]).

display_header(X) :- display_header(X, 0).
display_header(X, X) :- !.
display_header(X, Acc1) :-
    number_to_char(Acc1, Char),
    write('    '), write(Char),
    Acc2 is Acc1 + 1,
    display_header(X, Acc2).

display_matrix(Board) :- display_matrix(Board, 0).
display_matrix([], _).
display_matrix([L | R], Acc1) :-
    Acc1 < 10,
    write(Acc1), write('   '),
    display_line(L), nl, nl,
    Acc2 is Acc1 + 1,
    display_matrix(R, Acc2).
display_matrix([L | R], Acc1) :-
    Acc1 >= 10,
    write(Acc1), write('  '),
    display_line(L), nl, nl,
    Acc2 is Acc1 + 1,
    display_matrix(R, Acc2).

display_line([]).
display_line([H | T]) :-
    write(H),
    write('   '),
    display_line(T).