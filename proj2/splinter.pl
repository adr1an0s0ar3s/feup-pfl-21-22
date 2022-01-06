
/*
Tabuleiro de jogo, 18x15, é iniciado com as seguintes peças ao centro:
- bp - Black Pawn
- wp - White Pawn
- bk - Black King
- wk - White King
*/
initial_state([[empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bp,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wp,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bk,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wk,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       bp,wp,bp,wp,bp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,       wp,bp,wp,bp,wp,        empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty],
               [empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty,empty]]).

play :-
    start_game('H', 'H').

start_game(Player1, Player2) :-
    initial_state(InitialBoard).
    /* gameLoop(InitialBoard, Player1, Player2). */


move([H | T], X, 0, 'E', [HNew | T]) :- 
    find_x(H, X, HNew). 

move([H | T], X, Y, 'E', [H | TNew]) :-
    Y is Y - 1,
    move(T, X, Y, 'E', TNew).


find_x(Line, 0, LineNew) :-
    /*append([empty], Temp, LineNew),*/
    move_right(Line, Temp).

find_x([H | T], X, [H | TNew]) :-
    X is X - 1,
    find_x(T, X, TNew).


move_right([H, empty | T], [H | T]).

move_right([H | T], [H | TNew]) :-
    move_right(T, TNew).