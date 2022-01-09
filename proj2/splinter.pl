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
    NewX is A1 - 1 - X,
    revert(L, L1),
    move_right(L1, NewX, L2),
    revert(L2, NewL).
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
    X >= Y,
    get_diagonal(Board, X, Y, D),
    move_right(D, Y, NewD),
    set_diagonal(Board, X, Y, NewD, NewBoard).
move(Board, X, Y, 'SE', NewBoard) :-      % When X < Y
    get_diagonal(Board, X, Y, D),
    move_right(D, X, NewD),
    set_diagonal(Board, X, Y, NewD, NewBoard).