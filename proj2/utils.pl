:- use_module(library(lists)).

/*
Removes the first instance of the first argument in the list of the second argument
resulting in the list present in the third argument.
*/
del_elem(A1, [A1 | T], T) :- !.
del_elem(A1, [H | T1], [H | T2]) :- del_elem(A1, T1, T2).

/*
Sets the element of index given in the first argument of the list given in the third
argument to the value presented in the second argument, the resultant list is presented
in the fourth argument.
*/
set_elem(0, E, [_ | T], [E | T]).
set_elem(I, E, [H | T], [H | NewT]) :-
    I > 0,
    NewI is I - 1,
    set_elem(NewI, E, T, NewT).

/*
Mirrors the matrix given in the first argument by the y-axis, the resultant matrix is
returned in the second argument.
*/
matrix_mirror_x([], []).
matrix_mirror_x([L | R], [NewL | NewR]) :-
    reverse(L, NewL),
    mirror(R, NewR).

/*
Obtains the Beta 2/4 diagonal of the matrix presented in the first argument that includes
the element of the coordinates given in the second and third argument, the result is
returned by the fourth argument.
*/
get_diagonal(Matrix, X, Y, Diagonal) :-
    X >= Y,
    NewX is X - Y,
    get_diagonal_aux(Matrix, NewX, [], Diagonal).
get_diagonal([_ | R], X, Y, Diagonal) :-
    X < Y,
    NewY is Y - 1,
    get_diagonal(R, X, NewY, Diagonal).
get_diagonal_aux([], _, R, R).
get_diagonal_aux([L | _], X, R, R) :-
    length(L, X).
get_diagonal_aux([L | R], X, Acc1, Diagonal) :-
    NewX is X + 1,
    nth0(X, L, A1),
    append(Acc1, [A1], Acc2),
    get_diagonal_aux(R, NewX, Acc2, Diagonal).

/*
Sets the Beta 2/4 diagonal of the matrix presented in the first argument that includes
the element of the coordinates given in the second and third argument with the list of
values given in the fourth argument, the resultant matrix is returned by the fourth argument.
*/
set_diagonal(Matrix, X, Y, Diagonal, NewMatrix) :-
    X >= Y,
    NewX is X - Y,
    set_diagonal_aux(Matrix, NewX, Diagonal, NewMatrix).
set_diagonal([L | R], X, Y, Diagonal, [L | NewR]) :-
    X < Y,
    NewY is Y - 1,
    set_diagonal(R, X, NewY, Diagonal, NewR).
set_diagonal_aux([], _, [], []).
set_diagonal_aux([L | T], X, [], [L | T]) :-
    length(L, X).
set_diagonal_aux([L | R], X, [H | T], [NewL | NewR]) :-
    NewX is X + 1,
    set_elem(X, H, L, NewL),
    set_diagonal_aux(R, NewX, T, NewR).

/*
Retrieves to the fourth argument the element present in the position given in the second
and third argument in the matrix presented in the first argument.
*/
matrix_get_elem([L | _], X, 0, E) :-
    nth0(X, L, E).
matrix_get_elem([_ | R], X, Y, E) :-
    Y > 0,
    NewY is Y - 1,
    matrix_get_elem(R, X, NewY, E).

/*
As the name implies this function slices the array given in the third argument and slices
it begining in the index given in the first argument and size presented in the second
argument, the resultant slice is returned in the fourth argument. If index is negative
it will add one to it and subtract one to the size and the resultant array will be empty
until it reaches the first element. If the slice reaches the end of the list it'll return
until the last element.
*/
slice(_, _, [], []) :- !.
slice(0, 0, _, []) :- !.
slice(0, Size, [H | T1], [H | T2]) :-
    Size > 0,
    NewSize is Size - 1,
    slice(0, NewSize, T1, T2).
slice(Index, Size, [_ | T], List2) :-
    Index > 0,
    NewIndex is Index - 1,
    slice(NewIndex, Size, T, List2).
slice(Index, Size, List1, List2) :-
    Index < 0,
    NewIndex is Index + 1,
    NewSize is Size - 1,
    slice(NewIndex, NewSize, List1, List2).

/*
This function returns all the elements surrounding an element (given by it's coordinates,
second argument = x, third argument = y), including it, in a Matrix given in the first
argument, resulting in a list of elements in the fourth argument.
*/
matrix_elements_surrounding(Matrix, X, Y, Surrounding) :-
    matrix_elements_surrounding(Matrix, X, Y, 0, [], Surrounding).
matrix_elements_surrounding(_, _, Y, CurrentY, R, R) :-
    NewY is Y + 2,
    CurrentY = NewY.
matrix_elements_surrounding([L | R], X, Y, CurrentY, Acc1, Surrounding) :-
    CurrentY >= Y - 1,
    CurrentY =< Y + 1,
    Index is X - 1,
    slice(Index, 3, L, L1),
    append(Acc1, L1, Acc2),
    NewCurrentY is CurrentY + 1,
    matrix_elements_surrounding(R, X, Y, NewCurrentY, Acc2, Surrounding).