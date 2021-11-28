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

A função fibLista retorna o elemento de índice fornecido da lista de Fibonacci, utilizando programação dinâmica para pre-calcular uma lista de resultados parciais para os dois elementos anteriores.

### Testes

```
```

# Grupo

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>