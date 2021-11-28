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

A função fibListaBN ...

### Testes

```

```

Como podemos observar, ...

---

## fibListaInfinitaBN

```

```

A função fibListaInfinitaBN ...

### Testes

```

```

Como podemos observar, ...

# Módulo BigNumber.h

A definição de Big-Number é:

```
type BigNumber = [Int]
```

Números negativos são representados em Big-Number apenas com o primeiro dígito a negativo. Exemplo: -123 corresponde ao Big-Number [-1,2,3].

O número 0 é representado em Big-Number como [] (lista vazia).

## scanner

```
scanner :: String -> BigNumber
scanner [] = []
scanner ['0'] = []
scanner [a] = [read [a] :: Int]
scanner (a:b:cs) | a == '-'  = toggleSignalBN (removeHeaderZerosBN [read [x] :: Int | x <- b:cs])
                 | otherwise = removeHeaderZerosBN [read [x] :: Int | x <- a:b:cs]
```

A função scanner pega num número em forma de string e devolve esse mesmo número na forma de BigNumber. Como uma string é uma lista de Char, basta percorrer a lista e converter os Char para Int. Se o primeiro elemento da lista for o sinal negativo ('-'), é efetuada a conversão da restante lista e é negado o seu primeiro elemento.

### Testes

```
ghci> scanner "123"
[1,2,3]
ghci> scanner "-123"
[-1,2,3]
ghci> scanner "0"
[]
ghci> scanner "000011"
[1,1]
```

Como podemos observar, a função comporta-se como seria esperado.

## output

```
output :: BigNumber -> String
output [] = []
output (x:xs) | x < 0 = '-' : bignumber
              | otherwise = bignumber
              where bignumber = foldr (\a b -> show (abs a) ++ b) [] (x:xs)
```

A função output faz o inverso da scanner, ou seja, pega num Big-Number e retorna-lo em forma de String. Como uma String é uma lista de Char, basta fazer conversão do tipo Int para Char. Se o primeiro elemento do Big-Number for negativo, é só adicionar um '-' à String.

### Testes

```

```

# Grupo

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>