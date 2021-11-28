import BigNumber

----------------------- 1.1 -----------------------


-- | A função retorna o elemento de índice fornecido da lista de Fibonacci (calculada recursivamente)
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec x = fibRec (x-2) + fibRec (x-1)


----------------------- 1.2 -----------------------


-- | A função retorna o elemento de índice fornecido da lista de Fibonacci (calculada através de programação dinâmica)
fibLista :: (Integral a) => a -> a
fibLista 0 = 0
fibLista 1 = 1
fibLista x = fibListaAux x 2 [0,1] !! fromIntegral x


-- | A função auxilia a função fibLista, retorna uma lista de números de Fibonacci até ao índice que recebe por argumento.
-- Recebe como argumentos o índice, o número de elementos já calculados e uma lista com elementos já calculados (deve ser inicializada com: índice 2 [0,1])
fibListaAux :: (Integral a) => a -> a -> [a] -> [a]
fibListaAux x n acc | x == (n-1) = acc
                    | otherwise = fibListaAux x (n+1) (acc ++ [acc !! fromIntegral (n-2) + acc !! fromIntegral (n-1)])


----------------------- 1.3 -----------------------


-- | A função retorna o elemento de índice fornecido da lista de Fibonacci (utilizando uma lista infinita)
fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita x = fib !! fromIntegral x


-- | Lista infinita de números de Fibonacci [0,1,1,2,3,5...]
fib :: (Integral a) => [a]
fib = scanl (+) 0 (1 : fib)


----------------------- 3.1 -----------------------


-- | A função retorna o elemento de índice fornecido da lista de Fibonacci (calculada recursivamente) no formato de Big-Number
fibRecBN :: BigNumber -> BigNumber
fibRecBN [] = []
fibRecBN [1] = [1]
fibRecBN x = somaBN (fibRecBN (subBN x [2])) (fibRecBN (subBN x [1]))


----------------------- 3.2 -----------------------


-- | A função retorna o elemento de índice fornecido da lista de Fibonacci (calculada através de programação dinâmica) no formato de Big-Number
fibListaBN :: BigNumber -> BigNumber 
fibListaBN x = fibListaBNAux x ([],[1])


-- | A função auxilia a função fibListaBN, retorna o elemento de índice fornecido da lista de Fibonacci.
-- Recebe como argumento o índice e um tuplo capaz de armazenar os dois valores anteriores (deve ser inicializada com: índice ([],[1]))
fibListaBNAux :: BigNumber -> (BigNumber, BigNumber) -> BigNumber
fibListaBNAux [] (x,y) = x
fibListaBNAux [1] (x,y) = y
fibListaBNAux a (x,y) = fibListaBNAux (subBN a [1]) (y, somaBN x y)


----------------------- 3.3 -----------------------


-- | A função fibListaInfinitaBN retorna o elemento de índice fornecido da lista de Fibonacci (utilizando uma lista infinita) no formato de Big-Number
fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN x = head (fibListaInfinitaBNAux x)


-- | A função auxilia a função filListaInfinitaBN, retorna uma lista com os valores para além do índice fornecido e o próprio índice à cabeça da lista
fibListaInfinitaBNAux :: BigNumber -> [BigNumber]
fibListaInfinitaBNAux [] = fibBN
fibListaInfinitaBNAux x = tail (fibListaInfinitaBNAux (subBN x [1]))


-- | Lista infinita de números de Fibonacci no formato de Big-Number [[],[1],[1],[2],[3],[5],[8],[1,3]...]
fibBN :: [BigNumber]
fibBN = scanl somaBN [] ([1] : fibBN)