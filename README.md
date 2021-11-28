# FEUP PFL Project 2020/2021

# Módulo Fib.hs

## fibRec

```
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec x = fibRec (x-1) + fibRec (x-2)
```

A função fibRec retorna o elemento de índice fornecido da lista de Fibonacci, através de uma implementação recursiva, chamando a própria para somar os dois elementos anteriores, parando quando chegar a um dos casos base.

### Testes

```
ghci> fibRec 20
6765
ghci> fibRec 10
55
ghci> fibRec 1
1
```
Como podemos observar, todos estes resultados estão de acordo com a série de Fibonacci.

---

## fibLista

```
fibLista :: (Integral a) => a -> a
fibLista x = fibListaAux x !! fromIntegral x

fibListaAux :: (Integral a) => a -> [a]
fibListaAux x = 0 : 1 : [a | b <- [2..x], let a = fibListaAux x !! fromIntegral (b-2) + fibListaAux x !! fromIntegral (b-1)]
```

A função fibLista retorna o elemento de índice fornecido da sequência de Fibonacci, utilizando programação dinâmica para pre-calcular uma lista de resultados parciais para os dois elementos anteriores.

### Testes

```
ghci> fibLista 15
610
ghci> fibLista 9
34
ghci> fibLista 0
0
```

Como podemos observar, todos estes resultados estão de acordo com a sequência de Fibonacci.

---

## fibListaInfinita

```
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita x = fib !! fromIntegral x


fib :: (Integral a) => [a]
fib = scanl (+) 0 (1 : fib)
```

A função fibListaInfinita retorna o elemento de índice fornecido da sequência de Fibonacci, através da criação de uma lista infinita com o scanl.

### Testes

```
ghci> fibListaInfinita 30
832040
ghci> fibListaInfinita 60
1548008755920
ghci> fibListaInfinita 7
13
```

Como podemos observar, todos estes resultados estão de acordo com a sequência de Fibonacci.

---

# Módulo Fib.hs com Big-Numbers

## fibRecBN

```
fibRecBN :: BigNumber -> BigNumber
fibRecBN [] = []
fibRecBN [1] = [1]
fibRecBN x = somaBN (fibRecBN (subBN x [1])) (fibRecBN (subBN x [2]))
```

A função fibRecBN segue a mesma lógica da função fibRec, mas desta vez é trabalhada com Big-Numbers, sendo assim necessário utilizar as operações de soma e subtração entre Big-Number, a somaBN e a subBn, respetivamente. É utilizada uma implementação recursiva para somar os dois elementos anteriores e parar quando chegar a um dos casos base.

### Testes

```
ghci> fibRecBN [2,0]
[6,7,6,5]
ghci> fibRecBN [1,0]
[5,5]
ghci> fibRecBN [1]
[1]
```

Como podemos observar, os resultados estão de acordo tanto com a sequência de Fibonacci como com a implementação sem os Big-Numbers.

---

## fibListaBN

```
fibListaBN :: BigNumber -> BigNumber 
fibListaBN x = fibListaBNAux x ([],[1])


fibListaBNAux :: BigNumber -> (BigNumber, BigNumber) -> BigNumber
fibListaBNAux [] (x,y) = x
fibListaBNAux [1] (x,y) = y
fibListaBNAux a (x,y) = fibListaBNAux (subBN a [1]) (y, somaBN x y)
```

A função fibListaBN 

# Grupo

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>