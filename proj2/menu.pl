display_start_menu :-
    nl,
    write('   ************************************************************   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                      _         _                         |   '),nl,
    write('   |                     | (_)     | |                        |   '),nl,
    write('   |            ___ _ __ | |_ _ __ | |_ ___ _ __              |   '),nl,
    write('   |           | __/  _  | | |  _  | __/ _ |  __|             |   '),nl,
    write('   |           |__ | |_) | | | | | | ||  __/ |                |   '),nl,
    write('   |           |___/ .__/|_|_|_| |_|__|____|_|                |   '),nl,
    write('   |               | |                                        |   '),nl,                           
    write('   |               |_|                                        |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                 1 - PLAYER VS PLAYER                     |   '),nl,
    write('   |                 2 - PLAYER VS COMPUTER                   |   '),nl,
    write('   |                 3 - COMPUTER VS PLAYER                   |   '),nl,
    write('   |                 4 - COMPUTER VS COMPUTER                 |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   ************************************************************   '),nl.

validate_option(1, player, player) :-
    write('Starting game...').
validate_option(2, player, computer) :-
    write('Starting game...').
validate_option(3, computer, player) :-
    write('Starting game...').
validate_option(4, computer, computer) :-
    write('Starting game...').

read_option(Player1, Player2) :-
    repeat,
    write('Please select a valid option:\n'),
    read(Option),
    validate_option(Option, Player1, Player2).
