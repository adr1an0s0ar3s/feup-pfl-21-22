:- [utils].

/*
Displays the matrix given as argument with column and row identification.
*/
display_game([L | R]) :-
    nl,
    length(L, X),
    display_header(X),
    nl, nl,
    display_matrix([L | R]).

/*
Displays collumn identification by characters.
*/
display_header(X) :- display_header(X, 0).
display_header(X, X) :- !.
display_header(X, Acc1) :-
    number_to_char(Acc1, Char),
    write('    '), write(Char),
    Acc2 is Acc1 + 1,
    display_header(X, Acc2).

/*
Displays the matrix given as argument.
*/
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

/*
Displays the matrix line (list) given as argument.
*/
display_line([]).
display_line([H | T]) :-
    write(H),
    write('   '),
    display_line(T).

/*
Displays the colour of the pieces of the current turn.
*/
display_turn(0) :- write('White\'s turn.\n').
display_turn(1) :- write('Black\'s turn.\n').

/*
Displays an AI move.
*/
display_ai_move(X, Y, D) :-
    number_to_char(X, C),
    write('The AI choose to move:\n'),
    sleep(1), write(C-Y-D), sleep(3), nl.

display_winner(player, Turn) :-
    Player is Turn + 1,
    write('Player '), write(Player), write(' won!\n').
display_winner(_, Turn) :-
    Player is Turn + 1,
    write('AI'), write(Player), write(' won!\n').