:- [utils].

read_position(Column, Row) :-
    read(ColumnLetter-Row),
    char_to_number(ColumnLetter, Column),
    validate_position(Column, Row).

validate_position(Column, Row) :- 
    Column =< 14, Column >= 0,
    Row =< 17, Row >= 0.
validate_position(Column, Row) :-
    write('Please select a valid position (Column-Row):\n'),
    read_position(NewColumn, NewRow),
    validate_position(NewColumn, NewRow).

read_direction(Direction) :-
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
validate_direction(_Direction) :- 
    write('Please select a valid direction:\n'),
    read(NewDirection),
    validate_direction(NewDirection).

read_move(Column, Row, Direction) :- % TODO: the first input is the one being saved, despite being correct or not.
    write('Please select the position (Column-Row):\n'),
    read_position(Column, Row),
    write('Please select the direction:\n'),
    read_direction(Direction).

