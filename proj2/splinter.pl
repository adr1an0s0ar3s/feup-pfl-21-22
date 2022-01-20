:- use_module(library(lists)).
:- [utils].

/*
Definition of empty cell for ease of change if needed.
*/
empty(<>).  % To DEBUG change it to 'empty(empty).'

/*
Helper function that checks if a given cell content is one of the kings.
*/
is_king(bk).
is_king(wk).

/*
Game board, 18x15, it's initialized with these pieces at the center:
bp (Black Pawn), wp (White Pawn), bk (Black King) and wk (White King).
*/
initial_state( [[Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,bp,wp,bp,wp,bp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,wp,bp,wp,bp,wp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,bp,wp,bk,wp,bp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,wp,bp,wk,bp,wp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,bp,wp,bp,wp,bp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,wp,bp,wp,bp,wp,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em],
                [Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em,Em]] ) :- empty(Em).

/*
Pushes to the right all the elements of the list in the first argument after the index
given in the second argument until an empty, resulting in the list present in the third
argument.
*/
push_right([H | T], 0, [Em, H | NewT]) :-
    \+ empty(H),
    empty(Em),
    del_elem(Em, T, NewT).
push_right([H | T], X, [H | NewT]) :-
    X > 0,
    NewX is X - 1,
    push_right(T, NewX, NewT).

/*
The following set of functions move a given piece at a certain position to the given
direction, returning the resultant board in the last argument.
*/
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

/*
The following set of functions try to find a king beggining in a given position
by performing a depth-first search. If the starting position is already a king
the function will ignore it and it'll try to find the opponent's king.
*/
find_one_king(Board, X, Y) :-
    find_one_king(Board, X, Y, [X-Y]).

find_one_king(Board, X, Y, [_, _ | _]) :-   % Verifying that the element is a BK, WK or an empty
    matrix_get_elem(Board, X, Y, E),
    is_king(E).

find_one_king(Board, X, Y, V) :-            % Searching BK and WK in neighbours
    surrounding_delta(DeltaX, DeltaY),
    NewX is X + DeltaX,
    NewY is Y + DeltaY,
    inside_matrix(Board, NewX, NewY),
    \+ member(NewX-NewY, V),
    matrix_get_elem(Board, NewX, NewY, E),
    \+ empty(E),
    find_one_king(Board, NewX, NewY, [NewX-NewY | V]).

/*
Helper function that returns the delta to sum to the coordinates resulting in all
eight directions that we can search.
*/
surrounding_delta(-1, -1).
surrounding_delta(0, -1).
surrounding_delta(1, -1).
surrounding_delta(1, 0).
surrounding_delta(1, 1).
surrounding_delta(0, 1).
surrounding_delta(-1, 1).
surrounding_delta(-1, 0).

/*
Function that removes the pieces that aren't connected to any king in all directions,
returns the resultant board in the last argument.
*/
splinter(Board, NewBoard) :- splinter(Board, 0, Board, NewBoard).
splinter([], _, _, []).
splinter([L | R], Y, StaticBoard, [NewL | NewR]) :-
    splinter(L, 0, Y, StaticBoard, NewL),
    NewY is Y + 1,
    splinter(R, NewY, StaticBoard, NewR).

splinter([], _, _, _, []).
splinter([H | T], X, Y, StaticBoard, [E | NewT]) :-
    \+ is_king(H),
    \+ find_one_king(StaticBoard, X, Y),
    empty(E),
    NewX is X + 1,
    splinter(T, NewX, Y, StaticBoard, NewT), !.
splinter([H | T], X, Y, StaticBoard, [H | NewT]) :-
    NewX is X + 1,
    splinter(T, NewX, Y, StaticBoard, NewT).

/*
Helper function that returns the position of the first king that it finds in the
board presented in the first argument.
*/
find_king(Board, X, Y) :- find_king(Board, 0, X, Y).
find_king([L | _], Y, X, Y) :-
    nth0(X, L, E),
    is_king(E).
find_king([_ | R], Acc1, X, Y) :-
    Acc2 is Acc1 + 1,
    find_king(R, Acc2, X, Y).

/*
Game over checker, the game ends when both kings can't reach each other.
*/
game_over(Board) :-
    find_king(Board, X, Y),
    \+ find_one_king(Board, X, Y).

/*
Obtains the valid moves at a given moment of the game board.
*/
valid_moves(Board, Moves) :- valid_moves(Board, 0, 0, [], Moves).
valid_moves([L | R], X, Y, R, R) :-
    length(L, A1), A1 = X,
    length([L | R], A2), A2 = Y.
valid_moves([L | R], X, Y, Acc1, Moves) :-
    length(L, A1), A1 = X,
    NewY is Y + 1,
    valid_moves([L | R], 0, NewY, Acc1, Moves).
valid_moves(Board, X, Y, Acc1, Moves) :-
    valid_direction(D),
    \+ member([X-Y,D], Acc1),
    move(Board, X, Y, D, _),
    append(Acc1, [[X-Y,D]], Acc2),
    valid_moves(Board, X, Y, Acc2, Moves).
valid_moves(Board, X, Y, Acc1, Moves) :-
    NewX is X + 1,
    valid_moves(Board, NewX, Y, Acc1, Moves).

valid_direction('N').
valid_direction('S').
valid_direction('E').
valid_direction('O').
valid_direction('NE').
valid_direction('NO').
valid_direction('SE').
valid_direction('SO').