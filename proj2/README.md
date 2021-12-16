# TP2 - Splinter Board Game

- <u>Components</u>:

  - Board (18 x 15 squares)
  - 14 White Pawns and 14 Black Pawns
  - 1 White King and 1 Black King

- <u>Objective</u>:

  - The objective of the game is to splinter the opponent's king into a group that is smaller than your king's group.

- <u>How to Play</u>:

  - Arrange the board so that the pieces are in a single, inter-connected group, with the kings occupying the board's two central squares.

  ![](./doc/images/image1.png)

  - Choose a player to go first (white of black pieces), then continue playing with alternating turns.
  - On our turn, we may move one of our own pieces (pawn or king) one square in any direction (including diagonally) so that it lands on an adjacent square. Any pieces that lie in the way simply get pushed along by our piece. There's no limit to the number of pieces we may push.
  - A splinter occurs when one or more pieces become disconnected from the original group so that there are empty squares between those pieces and the original group. Following a splinter, any groups that do not contain a king are out of play and  the pawns occupying those groups are removed from the board.

  | ![](./doc/images/image2.png) | ![](./doc/images/image3.png) |
  | :--------------------------: | :--------------------------: |
  |   Splinter hasn't occurred   |    Splinter has occurred     |

  - If a splinter causes the kings to occupy two different groups, the game ends and the player whose king occupies the larger group wins the game (with pieces of both colors counting equally). If the two groups are of equal size, the player who has lost fewer pawns wins the game. If both players have lost an equal number of pawns, the game ends in a tie. In addition, if a splinter causes one player to be left with no pawns on the board, the game ends and the other player wins.

# Grupo Splinter_1

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>