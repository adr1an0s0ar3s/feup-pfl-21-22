:- [utils].
:- [splinter].

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