/*
Displays the starting menu.
*/
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

/*
Validates the option chosen by the user and returns the players accordingly.
*/
validate_option(1, player, player) :-
    write('Starting game...'),
    sleep(2).
validate_option(2, player, AIDifficulty) :-
    read_ai_difficulty(AIDifficulty),
    write('Starting game...'),
    sleep(2).
validate_option(3, AIDifficulty, player) :-
    read_ai_difficulty(AIDifficulty),
    write('Starting game...'),
    sleep(2).
validate_option(4, AIDifficulty1, AIDifficulty2) :-
    read_ai_difficulty(AIDifficulty1),
    read_ai_difficulty(AIDifficulty2),
    write('Starting game...'),
    sleep(2).

read_ai_difficulty(AIDifficulty) :-
    repeat,
    write('Please select a valid AI difficulty (0 or 1):\n'),
    read(AIDifficulty),
    AIDifficulty >= 0, AIDifficulty =< 1.

/*
Reads user input and returns the respective players if it is a valid option.
*/
read_option(Player1, Player2) :-
    repeat,
    write('Please select a valid option:\n'),
    read(Option),
    validate_option(Option, Player1, Player2).
