:- use_module(library(lists)).

/*
Valid directions.
*/    
valid_direction(n).
valid_direction(s).
valid_direction(e).
valid_direction(o).
valid_direction(ne).
valid_direction(no).
valid_direction(se).
valid_direction(so).

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
Sets the element present at the coordinates given in the second and third argument in the
matrix given in the first argument to the value presented in the fourth argument, the
resultant board is returned in the last argument.
*/
matrix_set_elem([L | R], X, 0, E, [NewL | R]) :-
    set_elem(X, E, L, NewL).
matrix_set_elem([L | R], X, Y, E, [L | NewR]) :-
    Y > 0,
    NewY is Y - 1,
    matrix_set_elem(R, X, NewY, E, NewR).

/*
Checks if the coordinates given in the second and third argument are inside the boundaries
of the matrix presented in the first argument.
*/
inside_matrix([L | R], X, Y) :-
    X >= 0,
    length(L, A1),
    X < A1,
    Y >= 0,
    length([L | R], A2),
    Y < A2.

/*
Returns the width and height of the matrix given in the first argument.
*/
matrix_size([L | R], Width, Height) :- length(L, Width), length([L | R], Height).

/*
Converts a character to a number, using its ASCII code.
*/
char_to_number(Char, Number) :-
    \+ integer(Char),
    char_code(Char, N),
    Number is N - 97.

/*
Converts a number to a character.
*/
number_to_char(Number, Char) :-
    integer(Number),
    N is Number + 97,
    char_code(Char, N).