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

  - Se um "splinter" resultar nos reis a ocupar grupos diferentes, o jogo acaba e o jogador cujo rei estiver no maior grupo vence o jogo (peças de ambas as cores valem o mesmo). Se os dois grupos forem de tamanho igual, o jogador que tiver perdido menos peões ganha o jogo. Se ambos os jogadores tiverem perdido o mesmo número de peões, o jogo acaba empatado. Adicionalmente, se um "splinter" levar a que um jogador fique sem peões, o jogo acaba e o outro jogador vence.

- <u>Referências</u>:
  - [Splinter](https://splinterboardgame.blogspot.com/2021/06/splinter-is-two-player-abstractstrategy.html)

## Lógica do Jogo

O jogo é inicializado com o predicado play/0, que é responsável por apresentar o menú inicial e começar o game_loop de acordo com a opção de jogo escolhida. Há quatro opções válidas, PvP, PvC, CvP e CvC. No caso de ser escolhido um modo de jogo que envolva o computador, é pedido ao utilizador para escolher o seu nível de inteligência. Quer para a escolha do modo de jogo quer para a escolha do nível da IA é efetuada e verificação de input, pedindo ao utilizador para voltar a introduzir a sua opção caso este seja inválido.

TODO: IMAGEM

- <u>Representação Interna do Estado do Jogo</u>:
  - Para representar o tabuleiro, é usada uma lista de listas, sendo os peões brancos e pretos representados por "wp" e "bp" respectivamente. O rei branco é representado por "wk" e o rei preto por "bk". Os espaços vazios são representados por "<>".

  - Situação Inicial: O jogo começa com as peças organizadas num bloco central, ocupando posições alternadas e com os dois reis no centro:

    | ![](./doc/images/image2.png) | ![](./doc/images/image3.png) |
    | :--------------------------: | :--------------------------: |
    |   Representação Prolog       |    Representação Consola     |

  - Situação Intermédia: Os jogadores podem mover as suas peças em qualquer direção e até empurrar outras peças:

    | ![](./doc/images/image2.png) | ![](./doc/images/image3.png) |
    | :--------------------------: | :--------------------------: |
    |   Representação Prolog       |    Representação Consola     |

  - Situação Final: O jogo acaba quandos uma jogada resulta nos dois reis ficarem em grupos separados, ganhando o jogador cujo rei tem o maior grupo:

    | ![](./doc/images/image2.png) | ![](./doc/images/image3.png) |
    | :--------------------------: | :--------------------------: |
    |   Representação Prolog       |    Representação Consola     |
  
TODO: IMAGENS

- <u>Visualização do Estado do Jogo</u>:
  - Para visualização do tabuleiro, foram utilizados os predicados do módulo show. Através do predicado display_game/1 é mostrado o tabuleiro, com identificação numérica para as linhas e alfabética para as colunas. Este predicado utiliza diversos predicados auxiliares, nomeadamente predicados que funcionam de forma recursiva para imprimir quer uma única linha quer a matriz completa.

TODO: IMAGEM E CÓDIGO.

- <u>Execução de Jogadas</u>:
  - Inicialmente é verificado se a jogada introduzida pelo utilizador é válida. É necessário verificar se a posição escolhida existe no tabuleiro, se tem uma peça sua e se a direção do movimento é válida.
  - Após o utilizador introduzir um jogada válida, a mesma é realizada através do predicado move, que por sua vez chama o predicado push_right. Para facilitar, só foi implementado o movimento para Este. Assim, para mover em qualquer outra direção é necessário efetuar algumas transformações no tabuleiro ou na linha, chamar o push_right e depois reverter essas transformações.

- <u>Final de Jogo</u>:
  - Após cada jogada é necessário verificar se foi causado o fim de jogo, quer através do "splinter" de um dos reis quer através do fim de possíveis jogadas para um dos jogadores. TODO

- <u>Lista de Jogadas Válidas</u>:
  - Uma jogada é válida se for escrita no formato Coluna-Linha-Direção e os seus parêmetros forem válidos, ou seja, a posição tem que estar dentro do tabuleiro e ter uma peça do jogador e a direção tem que ser uma das 8 direções: n, s, e, o, ne, no, se, so. É importante lembrar que é possível empurrar peças, logo não interessa se o quadrado para o qual o utilizador pretende mover a sua peça está ocupado. É verificado se o input do utilizador obedece a estas regras, e caso não seja é-lhe pedido para introduzir novamente um jogada.

- <u>Avaliação do Estado do Jogo</u>:

- <u>Jogada do Computador</u>:
  - O nível 1 do Computador obtém uma lista de jogadas possíveis para determinado estado do tabuleiro, através do predicado valid_moves/6 e simplesmente escolhe uma jogada aleatória, através do predicado random_member/2.
  - O nível 2 do Computador comporta-se de modo semelhante ao anterior, mas ao invés de escolher logo uma jogada aleatória, é antes filtrado para uma nova lista o conjunto de melhores jogadas possíveis, e a partir dessa lista é então selecionada uma jogada aleatoriamente. TODO:DIZER O QUE SAO AS MELHORES JOGADAS

## Conclusões

O trabalho teve como objetivo aplicar os conceitos aprendidos na segunda metade da Unidade Curricular de Programação Funcional e em Lógica, através da utilização da linguagem Prolog.

Concluimos que o trabalho foi realizado com sucesso e a sua realização foi uma mais valia quer para a consolidação dos temas apresentados na UC, quer para o nosso futuro como engenheiros informáticos.

## Bibliografia

- [Splinter](https://splinterboardgame.blogspot.com/2021/06/splinter-is-two-player-abstractstrategy.html)


# Grupo Splinter_1

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>