:- [utils].

read_position(Column, Row) :-
    repeat,
    write('Please select a valid position (Column-Row):\n'),
    read(ColumnLetter-Row),
    char_to_number(ColumnLetter, Column),
    validate_position(Column, Row).

validate_position(Column, Row) :- 
    Column =< 14, Column >= 0,
    Row =< 17, Row >= 0.

read_direction(Direction) :-
    repeat,
    write('Please select a valid direction:\n'),
    read(Direction),
    validate_direction(Direction).

validate_direction(n).
validate_direction(s).
validate_direction(e).
validate_direction(o).
validate_direction(ne).
validate_direction(no).
validate_direction(se).
validate_direction(so).

read_move(Column, Row, Direction) :- 
    read_position(Column, Row),
    read_direction(Direction).

