% Pretty much none of this is working

:- [utils].

read_position(Column, Row) :-
    read(ColumnLetter),
    char_to_number(ColumnLetter, Column),
    read(Row),
    validate_position(Column, Row).

validate_position(Column, Row) :- 
    14 >= Column,
    17 >= Row.
validate_position(Column, Row) :-
    write(' Please select a valid position (Column Row): \n'),
    read_position(NewColumn, NewRow),
    validate_position(NewColumn, NewRow).

read_direction(Direction) :-
    read(Direction),
    validate_direction(Direction).

validate_direction('N').
validate_direction('S').
validate_direction('E').
validate_direction('O').
validate_direction('NE').
validate_direction('NO').
validate_direction('SE').
validate_direction('SO').
validate_direction(_Direction) :- 
    write(' Please select a valid direction: \n'),
    read_direction(NewDirection),
    validate_direction(NewDirection).

read_move(Column, Row, Direction) :-
    write(' Please select the position (Column Row): \n'),
    nl,
    read_position(ColumnNumber, Row),
    write(' Please select the direction: \n'),
    nl,
    read(Direction),
    read_direction(Direction).

