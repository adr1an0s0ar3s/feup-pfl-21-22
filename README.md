# FEUP PFL Project 2020/2021

# Módulo Fib.hs

## fibRec

```
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec x = fibRec (x-1) + fibRec (x-2)
```

A função fibRec retorna o elemento de indice fornecido da lista de Fibonacci, através de uma implementação recursiva, chamando a própria para somar os dois elementos anteriores, parando quando chegar a um dos casos base.

---

# Grupo

- Adriano Soares <up201904873@up.pt>
- Vasco Alves <up201808031@up.pt>