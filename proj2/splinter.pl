:- use_module(library(lists)).
:- use_module(library(random)).
:- [utils].
:- [output].
:- [input].

/*
Function responsible for initializing the game, displays the start menu, reads
the option(s) and starts the game loop.
*/
play :-
    repeat,
    display_start_menu,
    read_option(Player1, Player2),
    initial_state(InitialBoard),
    game_loop(InitialBoard, [Player1, Player2], 0).

/*
Game loop, function mainly responsible for displaying the game board and inquiring
the user/AI for a move to be played, it checks if the move is valid and, if it is,
plays it and checks if any splinter has occured. Additionally, checks if a game over
has occured and displays the final game board and winner. After an arbitrary input it
returns to the main menu.
*/
game_loop(Board, _, _) :-
    game_over(Board),
    display_game(Board),
    winner(Board, Player),
    display_winner(Player),
    input_to_continue,
    play.

game_loop(Board, Players, Turn) :-
    display_game(Board),
    display_turn(Turn),
    nth0(Turn, Players, Player),
    get_move(Board, Player, Turn, X, Y, D),
    move(Board, Turn, X, Y, D, UnsplinteredBoard),
    splinter(UnsplinteredBoard, NewBoard),
    NewTurn is 1 - Turn,
    game_loop(NewBoard, Players, NewTurn).

/*
Auxiliary function that handles the inquiring of the move to be made, if it's a
player's turn it ask for an input, if it's the AI's turn it calculates the move
depending on the AI difficulty choosen in play/0.
*/
get_move(Board, player, _, X, Y, D) :-
    read_move(Board, X, Y, D).

get_move(Board, AIDifficulty, Turn, X, Y, D) :-
    choose_move(Board, AIDifficulty, Turn, X, Y, D),
    display_ai_move(X, Y, D).   % DEBUG: To test the AI's difficulty difference more easily we can comment this line and play a AI vs AI game with different difficulties.

/*
Game over checker, the game ends when both kings can't reach each other.
*/
game_over(Board) :-
    get_king_position(Board, X, Y),
    \+ find_a_king(Board, X, Y, _).

/*
IMPORTANT NOTE: This function should only be called after a game over.
Function that determines the winner after checking if a game over has occured
by comparing the number of pieces in the same group as the corresponding king.
*/
winner(Board, Player) :-
    count_group_pieces(Board, WhiteCount, BlackCount),
    winner_aux(Player, WhiteCount, BlackCount).

winner_aux(0, WhiteCount, BlackCount) :-
    WhiteCount > BlackCount.
winner_aux(1, WhiteCount, BlackCount) :-
    WhiteCount < BlackCount.
winner_aux(-1, WhiteCount, BlackCount) :-
    WhiteCount = BlackCount.

/*
Definition of empty cell for ease of change if needed.
*/
empty(<>).

/*
Helper function that checks if a given cell content is one of the kings.
*/
is_king(bk).
is_king(wk).

/*
Helper function that checks if a given cell can be played by the current player.
*/
owns(0, wk).
owns(0, wp).
owns(1, bk).
owns(1, bp).

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
find_a_king(Board, X, Y, King) :-
    find_a_king(Board, X, Y, [X-Y], King).

find_a_king(Board, X, Y, [_, _ | _], E) :-   % Verifying that the element is a BK, WK or an empty
    matrix_get_elem(Board, X, Y, E),
    is_king(E).

find_a_king(Board, X, Y, V, King) :-            % Searching BK and WK in neighbours
    surrounding_delta(DeltaX, DeltaY),
    NewX is X + DeltaX,
    NewY is Y + DeltaY,
    inside_matrix(Board, NewX, NewY),
    \+ member(NewX-NewY, V),
    matrix_get_elem(Board, NewX, NewY, E),
    \+ empty(E),
    find_a_king(Board, NewX, NewY, [NewX-NewY | V], King).

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
    \+ find_a_king(StaticBoard, X, Y, _),
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
get_king_position(Board, X, Y) :- get_king_position(Board, 0, X, Y).
get_king_position([L | _], Y, X, Y) :-
    nth0(X, L, E),
    is_king(E).
get_king_position([_ | R], Acc1, X, Y) :-
    Acc2 is Acc1 + 1,
    get_king_position(R, Acc2, X, Y).

/*
Obtains the valid moves at a given moment of the game board.
*/
valid_moves(Board, Player, Moves) :-
    matrix_size(Board, A1, A2),
    X is A1 - 1, Y is A2 - 1,
    valid_moves(Board, Player, X, Y, [], Moves).
valid_moves(_, _, -1, 0, R, R).
valid_moves(Board, Player, -1, Y, Acc1, Moves) :-
    matrix_size(Board, A1, _),
    X is A1 - 1,
    NewY is Y - 1,
    valid_moves(Board, Player, X, NewY, Acc1, Moves).
valid_moves(Board, Player, X, Y, Acc1, Moves) :-
    valid_direction(D),
    \+ member(X-Y-D, Acc1),
    move(Board, Player, X, Y, D, _),
    append([X-Y-D], Acc1, Acc2),
    valid_moves(Board, Player, X, Y, Acc2, Moves).
valid_moves(Board, Player, X, Y, Acc1, Moves) :-
    NewX is X - 1,
    valid_moves(Board, Player, NewX, Y, Acc1, Moves).

/*
Function that evaluates the current state of the board and returns a value
that can be negative or positive. If it's high it means that the player
given has a better chance of winning, if it's low it means that it'll probably
lose. Value 0 means that it's a draw at the moment (can be tested with the
initial board).
*/
value(Board, Player, Value) :-
    evaluate(Board, Player, PlayerValue),
    Opponent is 1 - Player,
    evaluate(Board, Opponent, OpponentValue),
    Value is PlayerValue - OpponentValue.

/*
Function that evaluates the current state of the board for a given player,
it returns the sum of the number of links that the player's pieces have with
the main group containing the two kings.
*/
evaluate(Board, Player, Value) :-
    matrix_size(Board, A1, A2),
    X is A1 - 1, Y is A2 - 1,
    evaluate(Board, Player, X, Y, 0, Value).
evaluate(_, _, -1, 0, R, R) :- !.
evaluate(Board, Player, -1, Y, Acc1, Value) :-
    matrix_size(Board, A1, _),
    X is A1 - 1,
    NewY is Y - 1,
    evaluate(Board, Player, X, NewY, Acc1, Value).
evaluate(Board, Player, X, Y, Acc1, Value) :-
    inside_matrix(Board, X, Y),
    matrix_get_elem(Board, X, Y, E),
    owns(Player, E),
    link_count(Board, X, Y, A1),
    Acc2 is Acc1 + A1,
    NewX is X - 1,
    evaluate(Board, Player, NewX, Y, Acc2, Value).
evaluate(Board, Player, X, Y, Acc1, Value) :-
    inside_matrix(Board, X, Y),
    NewX is X - 1,
    evaluate(Board, Player, NewX, Y, Acc1, Value).

/*
Function that counts the number of connections that a given position has
with it's surroundings (the higher the value, the less probable it is to
splinter it).
*/
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

/*
Function that simulates a play, returns the move. It has two difficulties:
difficulty 0 means that it'll play a random valid move; in difficulty 1 it'll
calculate the move that'll increase the number of connections between it's
pieces.
*/
choose_move(Board, 0, Player, X, Y, D) :-
    valid_moves(Board, Player, Moves),
    random_member(X-Y-D, Moves).
choose_move(Board, 1, Player, X, Y, D) :-
    valid_moves(Board, Player, Moves),
    best_moves(Board, Player, Moves, BestMoves),
    random_member(X-Y-D, BestMoves).

/*
Function that returns the array of moves that have the highest value returned
by the value function above.
*/
best_moves(Board, Player, Moves, BestMoves) :- best_moves(Board, Player, Moves, -1000000, [], BestMoves).
best_moves(_, _, [], _, R, R).
best_moves(Board, Player, [X-Y-D | T], BestValue, Acc1, BestMoves) :-
    move(Board, Player, X, Y, D, NewBoard),
    value(NewBoard, Player, Value),
    best_moves_aux(X-Y-D, Value, BestValue, Acc1, NewBestValue, Acc2),
    best_moves(Board, Player, T, NewBestValue, Acc2, BestMoves).

best_moves_aux(Move, Value, BestValue, _, Value, NewBestMoves) :-
    Value > BestValue,
    append([], [Move], NewBestMoves).
best_moves_aux(Move, Value, BestValue, CurrentBestMoves, BestValue, NewBestMoves) :-
    Value == BestValue,
    append(CurrentBestMoves, [Move], NewBestMoves).
best_moves_aux(_, Value, BestValue, CurrentBestMoves, BestValue, CurrentBestMoves) :-
    Value < BestValue.

/*
IMPORTANT NOTE: This function should only be used after a GAME OVER!
Function that returns the number of pieces connected to the white and black king. It's
utilized in the game over state to obtain the winner, the player with the most amount
of pieces wins. It's not advised to not be used whenever it's not a game over state
because it'll return an incorrect reading (because the two kings are in the same group).
*/
count_group_pieces(Board, WhiteCount, BlackCount) :-
    matrix_size(Board, W, H),
    X is W - 1, Y is H - 1,
    count_group_pieces(Board, X, Y, 0, 0, WhiteCount, BlackCount).
count_group_pieces(_, -1, 0, WhiteCount, BlackCount, WhiteCount, BlackCount).
count_group_pieces(Board, -1, Y, Acc1, Acc2, WhiteCount, BlackCount) :-
    matrix_size(Board, W, _),
    NewX is W - 1, NewY is Y - 1,
    count_group_pieces(Board, NewX, NewY, Acc1, Acc2, WhiteCount, BlackCount).
count_group_pieces(Board, X, Y, Acc1, Acc2, WhiteCount, BlackCount) :-
    matrix_get_elem(Board, X, Y, E),
    \+ empty(E),
    \+ is_king(E),
    find_a_king(Board, X, Y, King),
    increment_group_count(King, Acc1, Acc2, Acc3, Acc4),
    NewX is X - 1,
    count_group_pieces(Board, NewX, Y, Acc3, Acc4, WhiteCount, BlackCount).
count_group_pieces(Board, X, Y, Acc1, Acc2, WhiteCount, BlackCount) :-
    NewX is X - 1,
    count_group_pieces(Board, NewX, Y, Acc1, Acc2, WhiteCount, BlackCount).

increment_group_count(wk, WhiteCount, BlackCount, NewWhiteCount, BlackCount) :-
    NewWhiteCount is WhiteCount + 1.
increment_group_count(bk, WhiteCount, BlackCount, WhiteCount, NewBlackCount) :-
    NewBlackCount is BlackCount + 1.