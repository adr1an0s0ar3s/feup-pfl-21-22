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
Helper function that checks if a given cell can be played by the current player.
*/
owns(1, wk).
owns(1, wp).
owns(2, bk).
owns(2, bp).

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
push_right([H | T], Player, 0, [Em, H | NewT]) :-
    owns(Player, H),
    empty(Em),
    del_elem(Em, T, NewT).
push_right([H | T], Player, X, [H | NewT]) :-
    X > 0,
    NewX is X - 1,
    push_right(T, Player, NewX, NewT).

/*
The following set of functions move a given piece at a certain position to the given
direction, returning the resultant board in the last argument.
*/
move([L | R], Player, X, 0, e, [NewL | R]) :-
    push_right(L, Player, X, NewL).
move([L | R], Player, X, Y, e, [L | NewR]) :-
    NewY is Y - 1,
    move(R, Player, X, NewY, e, NewR).

move([L | R], Player, X, 0, o, [NewL | R]) :-
    length(L, A1),
    NewX is A1 - X - 1,
    reverse(L, L1),
    push_right(L1, Player, NewX, L2),
    reverse(L2, NewL).
move([L | R], Player, X, Y, o, [L | NewR]) :-
    NewY is Y - 1,
    move(R, Player, X, NewY, o, NewR).

move(Board, Player, X, Y, s, NewBoard) :-
    transpose(Board, B1),
    move(B1, Player, Y, X, e, B2),
    transpose(B2, NewBoard).

move(Board, Player, X, Y, n, NewBoard) :-
    transpose(Board, B1),
    move(B1, Player, Y, X, o, B2),
    transpose(B2, NewBoard).

move(Board, Player, X, Y, se, NewBoard) :-
    get_diagonal(Board, X, Y, D),
    min_member(A1, [X, Y]),
    push_right(D, Player, A1, NewD),
    set_diagonal(Board, X, Y, NewD, NewBoard).

move(Board, Player, X, Y, ne, NewBoard) :-
    reverse(Board, B1),
    length(Board, A1),
    NewY is A1 - Y - 1,
    move(B1, Player, X, NewY, se, B2),
    reverse(B2, NewBoard).

move(Board, Player, X, Y, no, NewBoard) :-
    get_diagonal(Board, X, Y, Diagonal),
    min_member(Index, [X, Y]),
    reverse(Diagonal, ReverseDiagonal),
    length(Diagonal, Length),
    ReverseIndex is Length - Index - 1,
    push_right(ReverseDiagonal, Player, ReverseIndex, NewReverseDiagonal),
    reverse(NewReverseDiagonal, NewDiagonal),
    set_diagonal(Board, X, Y, NewDiagonal, NewBoard).

move(Board, Player, X, Y, so, NewBoard) :-
    reverse(Board, B1),
    length(Board, A1),
    NewY is A1 - Y - 1,
    move(B1, Player, X, NewY, no, B2),
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
valid_moves([L | R], Player, Moves) :-
    length(L, A1), X is A1 - 1,
    length([L | R], A2), Y is A2 - 1,
    valid_moves([L | R], Player, X, Y, [], Moves).
valid_moves(_, _, 0, 0, R, R).
valid_moves([L | R], Player, 0, Y, Acc1, Moves) :-
    length(L, A1), NewX is A1 - 1,
    NewY is Y - 1,
    valid_moves([L | R], Player, NewX, NewY, Acc1, Moves).
valid_moves(Board, Player, X, Y, Acc1, Moves) :-
    valid_direction(D),
    \+ member([X-Y-D], Acc1),
    move(Board, Player, X, Y, D, _),
    append([[X-Y-D]], Acc1, Acc2),
    valid_moves(Board, Player, X, Y, Acc2, Moves).
valid_moves(Board, Player, X, Y, Acc1, Moves) :-
    NewX is X - 1,
    valid_moves(Board, Player, NewX, Y, Acc1, Moves).
    
valid_direction(n).
valid_direction(s).
valid_direction(e).
valid_direction(o).
valid_direction(ne).
valid_direction(no).
valid_direction(se).
valid_direction(so).

change_player(1, 2).
change_player(2, 1).

play :-
    display_start_menu,
    read_option(Player1, Player2),
    initial_state(_B),
    game_loop(_B, Player1, Player2, 1).

game_loop(Board, player, player, CurrentPlayer) :-
    display_game(Board),
    read_move(Board, X, Y, D),
    move(Board, CurrentPlayer, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    change_player(CurrentPlayer, NewCurrentPlayer),
    game_loop(NewBoard2, player, player, NewCurrentPlayer).

game_loop(Board, player, computer, 1) :-
    display_game(Board),
    read_move(Board, X, Y, D),
    move(Board, 1, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    game_loop(NewBoard2, player, computer, 2).

game_loop(Board, player, computer, 2) :- 
    display_game(Board),
    choose_move(Board, 0, 1, X, Y, D),
    move(Board, 2, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    game_loop(NewBoard2, player, computer, 1).

game_loop(Board, computer, player, 1) :-
    display_game(Board),
    choose_move(Board, 0, 1, X, Y, D),
    move(Board, 1, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    game_loop(NewBoard2, computer, player, 2).

game_loop(Board, computer, player, 2) :-
    display_game(Board),
    read_move(Board, X, Y, D),
    move(Board, 2, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    game_loop(NewBoard2, computer, player, 1).

game_loop(Board, computer, computer, currentPlayer) :
    display_game(Board),
    choose_move(Board, 0, currentPlayer, X, Y, D),
    move(Board, currentPlayer, X, Y, D, NewBoard1),
    splinter(NewBoard1, NewBoard2),
    change_player(CurrentPlayer, NewCurrentPlayer),
    game_loop(NewBoard2, computer, computer, NewCurrentPlayer).

/*
Function that evaluates the current state of the board for a given player,
it returns the sum of the number of links that the player's pieces
have with the main group containing the two kings.
*/
value(Board, Player, Value) :-
    matrix_size(Board, X, Y),
    value(Board, Player, X, Y, 0, Value).
value(_, _, 0, 0, R, R).
value(Board, Player, -1, Y, Acc1, Value) :-
    matrix_size(Board, X, _),
    NewY is Y - 1,
    value(Board, Player, X, NewY, Acc1, Value).
value(Board, Player, X, Y, Acc1, Value) :-
    matrix_get_elem(Board, X, Y, E),
    owns(Player, E),
    link_count(Board, X, Y, A1),
    Acc2 is Acc1 + A1,
    NewX is X - 1,
    value(Board, Player, NewX, Y, Acc2, Value).
value(Board, Player, X, Y, Acc1, Value) :-
    NewX is X - 1,
    value(Board, Player, NewX, Y, Acc1, Value).

link_count(Board, X, Y, Value) :- link_count(Board, X, Y, [], 0, Value).
link_count(_, _, _, VisitedDirections, R, R) :-
    length(VisitedDirections, 8).
link_count(Board, X, Y, VisitedDirections, Acc1, Value) :-
    surrounding_delta(DeltaX, DeltaY),
    \+ member(DeltaX-DeltaY, VisitedDirections),
    NewX is X + DeltaX, NewY is Y + DeltaY,
    inside_matrix(Board, NewX, NewY),
    matrix_get_elem(Board, NewX, NewY, E),
    \+ empty(E),
    append(VisitedDirections, [DeltaX-DeltaY], NewVisitedDirections),
    Acc2 is Acc1 + 1,
    link_count(Board, X, Y, NewVisitedDirections, Acc2, Value).
link_count(Board, X, Y, VisitedDirections, Acc1, Value) :-
    surrounding_delta(DeltaX, DeltaY),
    \+ member(DeltaX-DeltaY, VisitedDirections),
    append(VisitedDirections, [DeltaX-DeltaY], NewVisitedDirections),
    link_count(Board, X, Y, NewVisitedDirections, Acc1, Value).