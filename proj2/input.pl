:- [utils].
:- [splinter].

read_move(Board, Column, Row, Direction) :- 
    repeat,
    write('Please select a valid position and direction (Column-Row-Direction):\n'),
    read(ColumnLetter-Row-Direction),
    valid_direction(Direction),
    char_to_number(ColumnLetter, Column),
    inside_matrix(Board, Column, Row).