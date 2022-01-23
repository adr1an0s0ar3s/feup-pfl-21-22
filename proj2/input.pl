:- [utils].

/*
Validates the option chosen by the user and returns the players accordingly.
*/
validate_option(1, player, player) :-
   display_starting_game_animation.
validate_option(2, player, AIDifficulty) :-
    read_ai_difficulty(AIDifficulty),
    display_starting_game_animation.
validate_option(3, AIDifficulty, player) :-
    read_ai_difficulty(AIDifficulty),
    display_starting_game_animation.
validate_option(4, AIDifficulty1, AIDifficulty2) :-
    read_ai_difficulty(AIDifficulty1),
    read_ai_difficulty(AIDifficulty2),
    display_starting_game_animation.

/*
Validates the AIDifficulty chosen by the user.
*/
read_ai_difficulty(AIDifficulty) :-
    repeat,
    write('Please select a valid AI difficulty (0 or 1):\n'),
    read(AIDifficulty),
    integer(AIDifficulty),
    AIDifficulty >= 0, AIDifficulty =< 1.

/*
Reads user input and returns the respective players if it is a valid option.
*/
read_option(Player1, Player2) :-
    repeat,
    write('Please select a valid option:\n'),
    read(Option),
    validate_option(Option, Player1, Player2).

/*
Lets the player choose a position and a direction to play and saves those if they are valid.
*/
read_move(Board, Column, Row, Direction) :- 
    repeat,
    write('Please select a valid position and direction (Column-Row-Direction):\n'),
    read(ColumnLetter-Row-Direction),
    valid_direction(Direction),
    char_to_number(ColumnLetter, Column),
    inside_matrix(Board, Column, Row).

/*
Generic function that requires an arbitrary input to proceed.
*/
input_to_continue :-
    repeat,
    write('Input anything valid to proceed:\n'),
    read(_).