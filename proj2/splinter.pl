
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
    NewX is 2 - X, % Pass length as argument!
    revert(L, L1),
    move_right(L1, NewX, L2),
    revert(L2, NewL).
move([L | R], X, Y, 'O', [L | NewR]) :-
    NewY is Y - 1,
    move(R, X, NewY, 'O', NewR).

move(Board, X, Y, 'S', NewBoard) :-
    transpose(Board, 3, 3, B1),
    move(B1, Y, X, 'E', B2),
    transpose(B2, 3, 3, NewBoard).

move(Board, X, Y, 'N', NewBoard) :-
    transpose(Board, 3, 3, B1),
    move(B1, Y, X, 'O', B2),
    transpose(B2, 3, 3, NewBoard).







/*
Removes the first instance of the first argument in the list of the second argument
resulting in the list present in the third argument.
*/
del_elem(A1, [A1 | T], T) :- !.
del_elem(A1, [H | T1], [H | T2]) :- del_elem(A1, T1, T2).

/*
Reverts the list in the first argument resulting in the list present in the second
argument.
*/
revert([], []).
revert([H | T], L2) :-
    revert(T, L1),
    append(L1, [H], L2).


get_elem(0, [E | _], E).
get_elem(I, [_ | T], E) :-
    I > 0,
    NewI is I - 1,
    get_elem(NewI, T, E).

set_elem(0, E, [_ | T], [E | T]).
set_elem(I, E, [H | T], [H | NewT]) :-
    I > 0,
    NewI is I - 1,
    set_elem(NewI, E, T, NewT).

get_column(X, Height, Matrix, C) :- get_column(X, Height, Matrix, [], C).
get_column(_, 0, _, R, R).
get_column(X, Height, [L | R], Acc1, C) :-
    Height > 0,
    get_elem(X, L, A1),
    append(Acc1, [A1], Acc2),
    NewHeight is Height - 1,
    get_column(X, NewHeight, R, Acc2, C).

transpose(Matrix, Length, Height, NewMatrix) :- transpose(Matrix, Length, Height, [], NewMatrix).
transpose(_, 0, _, R, R).
transpose(Matrix, Length, Height, Acc1, NewMatrix) :-
    Length > 0,
    X is Length - 1,
    get_column(X, Height, Matrix, L1),
    append([L1], Acc1, Acc2),
    NewLength is Length - 1,
    transpose(Matrix, NewLength, Height, Acc2, NewMatrix).


get_matrix_elem(Matrix, X, Y, E) :-
    get_elem(Y, Matrix, L),
    get_elem(X, L, E).

set_matrix_elem([L | T], X, 0, E, [NewL | T]) :-
    set_elem(X, E, L, NewL).
set_matrix_elem([L | R], X, Y, E, [L | NewR]) :-
    NewY is Y - 1,
    set_matrix_elem(R, X, NewY, E, NewR).

get_diagonal(Matrix, X, Y, Length, Height, Diagonal) :-
    X >= Y,
    NewX is X - Y,
    get_diagonal_aux(Matrix, NewX, 0, Length, Height, Diagonal).
get_diagonal(Matrix, X, Y, Length, Height, Diagonal) :-
    X < Y,
    NewY is Y - X,
    get_diagonal_aux(Matrix, 0, NewY, Length, Height, Diagonal).

get_diagonal_aux(Matrix, X, Y, Length, Height, Diagonal) :- get_diagonal_aux(Matrix, X, Y, Length, Height, [], Diagonal).
get_diagonal_aux(_, X, _, X, _, R, R).
get_diagonal_aux(_, _, Y, _, Y, R, R).
get_diagonal_aux(Matrix, X, Y, Length, Height, Acc1, Diagonal) :-
    X < Length,
    Y < Height,
    get_matrix_elem(Matrix, X, Y, E),
    append(Acc1, [E], Acc2),
    NewX is X + 1,
    NewY is Y + 1,
    get_diagonal_aux(Matrix, NewX, NewY, Length, Height, Acc2, Diagonal).

set_diagonal_aux(Matrix, X, Y, Length, Height, Diagonal, NewMatrix) :- set_diagonal_aux(Matrix, X, Y, Length, Height, Diagonal, [], NewMatrix).
set_diagonal_aux(_, X, _, X, _, R, R).
set_diagonal_aux(_, _, Y, _, Y, R, R).
set_diagonal_aux(Matrix, X, Y, Length, Height, Diagonal, Acc1, NewMatrix) :-
    X < Length,
    Y < Height,
    set_matrix_elem(Matrix, X, Y, E, NewMatrix),
    append(Acc1, [E], Acc2),
    NewX is X + 1,
    NewY is Y + 1,
    set_diagonal_aux(Matrix, NewX, NewY, Length, Height, Diagonal, Acc2, NewMatrix).

/*
[empty, empty, empty, empty, empty, empty, empty]
[empty, empty, empty, empty, empty, empty, empty]
[empty, empty, empty, empty, empty, >HERE, empty]
[empty, empty, empty, empty, empty, empty, empty]
[empty, empty, empty, empty, empty, empty, empty]
[empty, empty, empty, empty, empty, empty, empty]
[empty, empty, empty, empty, empty, empty, empty]

Board Size: 7x7
(5,2) -> (3,0)
x > y -> x - y
x < y -> y - x
(3,0) -> (4,1) -> (5,2) -> (6,3) -> (7,4) X
*/