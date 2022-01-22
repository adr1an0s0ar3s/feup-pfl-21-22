# TP2 - Splinter Board Game

## Descrição do Jogo

- <u>Componentes</u>:

  - 2 Jogadores
  - Tabuleiro (18 x 15 quadrados)
  - 14 Peões Brancos e 14 Peões Pretos
  - 1 Rei Branco e 1 Rei Preto

- <u>Objetivo</u>:

  - O objetivo do jogo é fazer "splinter" ao rei do oponente de modo que este fique num grupo mais pequeno do que o nosso.

- <u>Como jogar</u>:

  - Organizar o tabuleiro de modo a que as peças estejam num único grupo, conectado, com os reis a ocupar os quadrados centrais do tabuleiro.

  ![](./doc/images/image1.png)

  - Escolher um jogador para iniciar o jogo (peças brancas ou pretas) e depois continuar com turnos alternados.
  - No nosso turno, mover uma das nossas peças um quadrado em qualquer direção, incluindo diagonalmente, de modo a cair num quadrado adjacente. Qualquer peça que esteja no caminho é simplesmente puxada na mesma direção. Não há limite para o número de peças que se pode puxar.
  - Um "splinter" ocorre quando uma ou mais peças ficam desconectadas do grupo original, havendo quadrados vazios entre essas peças a o grupo. Após um "splinter", todos os grupos que não tiverem um rei estão fora do jogo e os seus peões são removidos do tabuleiro.

  | ![](./doc/images/image2.png) | ![](./doc/images/image3.png) |
  | :--------------------------: | :--------------------------: |
  |   Não ocorreu Splinter       |    Ocorreu Splinter          |

  - Se um "splinter" resultar nos reis a ocupar grupos diferentes, o jogo acaba e o jogador cujo rei estiver no maior grupo vence o jogo (peças de ambas as cores valem o mesmo). Se os dois grupos forem de tamanho igual, o jogador que tiver perdido menos peões ganha o jogo. Se ambos os jogadores tiverem perdido o mesmo número de peões, o jogo acaba empatado. Adicionalmente, se um "splinter" levar a que um jogador fique sem peões, o jogo acabe e o outro jogador vence.

- <u>Referências</u>:
  - [Splinter](https://splinterboardgame.blogspot.com/2021/06/splinter-is-two-player-abstractstrategy.html)

## Lógica do Jogo

- <u>Representação Interna do Estado do Jogo</u>:
  - Para representar o tabuleiro, é usada uma lista de listas, sendo os peões brancos e pretos representados por "wp" e "bp" respectivamente. O rei branco é representado por "wk" e o rei preto por "bk". Os espaços vazios são representados por "<>".
  - TODO: Adicionar exemplos da representação em Prolog de estados de jogo inicial, intermédio e final (talvez prints da consola).

- <u>Visualização do Estado do Jogo</u>:
  - Através do predicado play/0, é apresentado um menú inicial onde o utilizador pode escolher a sua opção de jogo. Caso escolha uma das opções que envolva jogar contra o computador, deve também escolher o nível de dificuldade. É lido o input do utilizador e após a sua verificação é iniciado o jogo. Caso seja inválido, é pedido para o utilizador introduzir novamente a sua opção.
  - Para visualização do tabuleiro, foram utilizados os predicados do módulo show. Através do predicado display_game é mostrado o tabuleiro, com identificação numérica para as linhas e alfabética para as colunas.

- <u>Execução de Jogadas</u>:
  - Em cada turno, é pedido ao utilizador para introduzir a jogada que pretende fazer no formato Coluna-Linha-Direção. Caso a jogada não esteja neste formato ou sejam dadas opções inválidas, como por exemplo direção não existente, posição fora do tabuleiro ou posição com peça do oponente, é-lhe pedido para introduzir novamente a sua opção.
  - Após o utilizador introduzir um jogada válida, a mesma é realizada através do predicado move, que por sua vez chama o predicado move_right. Para facilitar, só foi implementado o movimento para Este. Assim, para mover em qualquer outra direção é necessário efetuar algumas transformações no tabuleiro ou na linha, chamar a move_right e depois reverter essas transformações.

- <u>Final de Jogo</u>:
  - Após cada jogada é necessário verificar se foi causado o fim de jogo. TODO

- <u>Lista de Jogadas Válidas</u>:
  - Através do predicado valid_moves/2 é possível obter a lista de jogadas possíveis num determinado momento do jogo. 



# Grupo Splinter_1

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>