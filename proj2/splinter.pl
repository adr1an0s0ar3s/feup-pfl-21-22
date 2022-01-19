:- use_module(library(lists)).
:- [utils].

/*
Pushes to the right all the elements of the list in the first argument after the index
given in the second argument until an empty, resulting in the list present in the third
argument.
*/
push_right([H | T], 0, [<>, H | NewT]) :-
    \+ H = <>,
    del_elem(<>, T, NewT).
push_right([H | T], X, [H | NewT]) :-
    X > 0,
    NewX is X - 1,
    push_right(T, NewX, NewT).


move([L | R], X, 0, 'E', [NewL | R]) :-
    push_right(L, X, NewL).
move([L | R], X, Y, 'E', [L | NewR]) :-
    NewY is Y - 1,
    move(R, X, NewY, 'E', NewR).

move([L | R], X, 0, 'O', [NewL | R]) :-
    length(L, A1),
    NewX is A1 - X - 1,
    reverse(L, L1),
    push_right(L1, NewX, L2),
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
    push_right(D, A1, NewD),
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
    push_right(ReverseDiagonal, ReverseIndex, NewReverseDiagonal),
    reverse(NewReverseDiagonal, NewDiagonal),
    set_diagonal(Board, X, Y, NewDiagonal, NewBoard).

move(Board, X, Y, 'SO', NewBoard) :-
    reverse(Board, B1),
    length(Board, A1),
    NewY is A1 - Y - 1,
    move(B1, X, NewY, 'NO', B2),
    reverse(B2, NewBoard).


find_one_king(Board, X, Y) :-
    find_one_king(Board, X, Y, [X-Y]).

/*
Verifying that the element is a BK, WK or an empty
*/
find_one_king(Board, X, Y, [_, _ | _]) :-
    matrix_get_elem(Board, X, Y, E),
    is_king(E).

/*
Searching BK and WK in neighbours
*/
find_one_king(Board, X, Y, V) :-
    surrounding_delta(DeltaX, DeltaY),
    NewX is X + DeltaX,
    NewY is Y + DeltaY,
    inside_board(Board, NewX, NewY),
    \+ member(NewX-NewY, V),
    \+ matrix_get_elem(Board, NewX, NewY, <>),
    find_one_king(Board, NewX, NewY, [NewX-NewY | V]).

surrounding_delta(-1, -1).
surrounding_delta(0, -1).
surrounding_delta(1, -1).
surrounding_delta(1, 0).
surrounding_delta(1, 1).
surrounding_delta(0, 1).
surrounding_delta(-1, 1).
surrounding_delta(-1, 0).

inside_board([L | R], X, Y) :-
    X >= 0,
    length(L, A1),
    X < A1,
    Y >= 0,
    length([L | R], A2),
    Y < A2.

is_king(bk).
is_king(wk).

splinter(Board, NewBoard) :- splinter(Board, 0, 0, Board, NewBoard).
splinter([L | T], X, Y, R, R) :-
    length(L, A1),
    X = A1,
    length([L | T], A2),
    Y = A2.
splinter([L | R], X, Y, Acc1, NewBoard) :-
    length(L, A1),
    X = A1,
    NewY is Y + 1,
    splinter([L | R], 0, NewY, Acc1, NewBoard).
splinter(Board, X, Y, Acc1, NewBoard) :-
    \+ find_one_king(Board, X, Y),
    matrix_set_elem(Acc1, X, Y, <>, Acc2),
    NewX is X + 1,
    splinter(Board, NewX, Y, Acc2, NewBoard). 
splinter(Board, X, Y, Acc1, NewBoard) :-
    NewX is X + 1,
    splinter(Board, NewX, Y, Acc1, NewBoard).    


find_king(Board, X, Y) :- find_king(Board, 0, X, Y).
find_king([L | _], Y, X, Y) :-
    nth0(X, L, E),
    is_king(E).
find_king([_ | R], Acc1, X, Y) :-
    Acc2 is Acc1 + 1,
    find_king(R, Acc2, X, Y).


game_over(Board) :-
    find_king(Board, X, Y),
    \+ find_one_king(Board, X, Y).
       