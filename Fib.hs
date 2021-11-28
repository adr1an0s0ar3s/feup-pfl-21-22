import BigNumber

----------------------- 1.1 -----------------------


-- | A função fibRec retorna o elemento de índice fornecido da lista de Fibonacci (calculada recursivamente)
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec x = fibRec (x-1) + fibRec (x-2)


----------------------- 1.2 -----------------------


-- | A função fibLista retorna o elemento de índice fornecido da lista de Fibonacci (calculada através de programação dinâmica)
fibLista :: (Integral a) => a -> a
fibLista x = fibListaAux x (0,1)

-- | A função fibListaAux 
fibListaAux :: (Integral a) => a -> (a,a) -> a
fibListaAux 0 (x,y) = x
fibListaAux 1 (x,y) = y
fibListaAux a (x,y) = fibListaAux (a-1) (y,x+y)


----------------------- 1.3 -----------------------


fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita x = fib !! fromIntegral x


fib :: (Integral a) => [a]
fib = scanl (+) 0 (1 : fib)


----------------------- 3.0 -----------------------


fibRecBN :: BigNumber -> BigNumber
fibRecBN [] = []
fibRecBN [1] = [1]
fibRecBN x = somaBN (fibRecBN (subBN x [1])) (fibRecBN (subBN x [2]))


fibListaBN :: BigNumber -> BigNumber 
fibListaBN x = fibListaBNAux x ([],[1])


fibListaBNAux :: BigNumber -> (BigNumber, BigNumber) -> BigNumber
fibListaBNAux [] (x,y) = x
fibListaBNAux [1] (x,y) = y
fibListaBNAux a (x,y) = fibListaBNAux (subBN a [1]) (y, somaBN x y)


fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN x = snd (head (filter (\a -> fst a == x) fibBN))


fibBN :: [(BigNumber, BigNumber)]
fibBN = scanl (\a b -> (somaBN (fst a) [1], somaBN (snd a) (snd b))) ([], []) (([1], [1]) : fibBN)