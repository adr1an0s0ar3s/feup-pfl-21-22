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

display_game(Board) :-
    nl,
    write('    a   b   c   d   e   f   g   h   i   j   k   l   m   n   o    '),
    nl, nl,
    write_matrix(0,17, Board).

write_matrix(N1, N2, [H | T]) :-
    N2 >= N1,
    write(N1), write('   '), write_line(H),
    nl, nl,
    N3 is N1 + 1,
    write_matrix(N3, N2, T).

write_line([]).
write_line([H | T]) :-
    write(H),
    write('   '),
    write_line(T).