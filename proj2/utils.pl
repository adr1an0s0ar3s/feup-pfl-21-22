:- use_module(library(lists)).

/*
Removes the first instance of the first argument in the list of the second argument
resulting in the list present in the third argument.
*/
del_elem(A1, [A1 | T], T) :- !.
del_elem(A1, [H | T1], [H | T2]) :- del_elem(A1, T1, T2).

/*
Retrieves to the third argument the element present in the index given in the first
argument in the list presented in the second argument.
*/
get_elem(0, [E | _], E).
get_elem(I, [_ | T], E) :-
    I > 0,
    NewI is I - 1,
    get_elem(NewI, T, E).

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
    get_elem(X, L, A1),
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
set_diagonal_aux([L | _], X, [], []) :-
    length(L, X).
set_diagonal_aux([L | R], X, [H | T], [NewL | NewR]) :-
    NewX is X + 1,
    set_elem(X, H, L, NewL),
    set_diagonal_aux(R, NewX, T, NewR).