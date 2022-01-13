:- use_module(library(lists)).
:- [utils].

/*
Tabuleiro de jogo, 18x15, é iniciado com as seguintes peças ao centro:
- bp - Black Pawn
- wp - White Pawn
- bk - Black King
- wk - White King
*/
initial_state([[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bp,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wp,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bk,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wk,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bp,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wp,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty]]).


/*
Pushes to the right all the elements of the list in the first argument after the index
given in the second argument until an empty, resulting in the list present in the third
argument.
*/
move_right([H | T], 0, [empty, H | NewT]) :-
    \+ H = empty,
    del_elem(empty, T, NewT).
move_right([H | T], X, [H | NewT]) :-
    X > 0,
    NewX is X - 1,
    move_right(T, NewX, NewT).


move([L | R], X, 0, 'E', [NewL | R]) :-
    move_right(L, X, NewL).
move([L | R], X, Y, 'E', [L | NewR]) :-
    NewY is Y - 1,
    move(R, X, NewY, 'E', NewR).

move([L | R], X, 0, 'O', [NewL | R]) :-
    length(L, A1),
    NewX is A1 - X - 1,
    reverse(L, L1),
    move_right(L1, NewX, L2),
    reverse(L2, NewL).
move([L | R], X, Y, 'O', [L | NewR]) :-
    NewY is Y - 1,
    move(R, X, NewY, 'O', NewR).

move(Board, X, Y, 'S', NewBoard) :-
    transpose(Board, B1),
    move(B1, Y, X, 'E', B2),
    transpose(B2, NewBoard).

move(Board, X, Y, 'N', NewBoard) :-
    transpose(Board, B1),
    move(B1, Y, X, 'O', B2),
    transpose(B2, NewBoard).

move(Board, X, Y, 'SE', NewBoard) :-
    get_diagonal(Board, X, Y, D),
    min_member(A1, [X, Y]),
    move_right(D, A1, NewD),
    set_diagonal(Board, X, Y, NewD, NewBoard).

move(Board, X, Y, 'NE', NewBoard) :-
    reverse(Board, B1),
    length(Board, A1),
    NewY is A1 - Y - 1,
    move(B1, X, NewY, 'SE', B2),
    reverse(B2, NewBoard).

move(Board, X, Y, 'NO', NewBoard) :-
    get_diagonal(Board, X, Y, Diagonal),
    min_member(Index, [X, Y]),
    reverse(Diagonal, ReverseDiagonal),
    length(Diagonal, Length),
    ReverseIndex is Length - Index - 1,
    move_right(ReverseDiagonal, ReverseIndex, NewReverseDiagonal),
    reverse(NewReverseDiagonal, NewDiagonal),
    set_diagonal(Board, X, Y, NewDiagonal, NewBoard).

move(Board, X, Y, 'SO', NewBoard) :-
    reverse(Board, B1),
    length(Board, A1),
    NewY is A1 - Y - 1,
    move(B1, X, NewY, 'NO', B2),
    reverse(B2, NewBoard).

display_game(Board) :- % This is gonna be a pain in the ass
    nl,
    write('    A   B   C   D   E   F   G   H   I   J   K   L   M   N   O    '),
    nl, nl,
    write_numbers(1,18),
    write_matrix(Board).

write_numbers(N1, N2) :-
    N2 >= N1,
    write(N1),
    nl, nl,
    N3 is N1 + 1,
    write_numbers(N3, N2).

write_matrix([H | T]) :-
    write('    '),
    write_line(H),
    nl, nl,
    write_matrix(T).

write_line([]).
write_line([H | T]) :-
    write(H),
    write('   '),
    write_line(T).