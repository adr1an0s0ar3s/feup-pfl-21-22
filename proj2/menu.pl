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
    write('   |                 3 - COMPUTER VS COMPUTER                 |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   |                                                          |   '),nl,
    write('   ************************************************************   '),nl.

validate_option(1) :-
    write('Starting game...').
validate_option(2) :-
    write('Starting game...').
validate_option(3) :-
    write('Starting game...').
validate_option(_Option) :-
    write('Please select a valid option:\n'),
    read(NewOption),
    validate_option(NewOption).

read_option :-
    write('Please select a game mode:\n'),
    read(Option),
    validate_option(Option).
