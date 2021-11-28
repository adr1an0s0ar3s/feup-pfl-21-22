module BigNumber where

-------------------- Auxilixary --------------------

-- | A função retorna um Big-Number com n 0's adicionados na cabeça
addHeaderZerosBN :: Int -> BigNumber -> BigNumber
addHeaderZerosBN x bn = [0 | _ <- [1..x]] ++ bn


-- | A função retorna um Big-Number com os 0's da cabeça removidos
removeHeaderZerosBN :: BigNumber -> BigNumber
removeHeaderZerosBN [] = []
removeHeaderZerosBN (x:xs) | x /= 0 = x:xs
                           | otherwise = removeHeaderZerosBN xs


-- | A função retorna um Big-Number com o sinal alterado
toggleSignalBN :: BigNumber -> BigNumber
toggleSignalBN [] = []
toggleSignalBN (x:xs) | x == 0 = x : toggleSignalBN xs
                      | otherwise = (-x):xs


-- | A função retorna um boleano indicando se o primeiro argumento é maior do que o segundo
greaterThanBN :: BigNumber -> BigNumber -> Bool
greaterThanBN [] [] = False
greaterThanBN (x:xs) [] | x < 0 = False
                        | otherwise = True
greaterThanBN [] (y:ys) | y < 0 = True
                        | otherwise = False
greaterThanBN (x:xs) (y:ys) | x < 0 && y < 0 = toggleSignalBN bn1 < toggleSignalBN bn2
                            | otherwise = bn1 > bn2
                            where bn1 = addHeaderZerosBN (length (y:ys) - length (x:xs)) (x:xs)
                                  bn2 = addHeaderZerosBN (length (x:xs) - length (y:ys)) (y:ys)


-- | A função retorna uma lista infinita com os múltiplos de um Big-Number
timeTableBN :: BigNumber -> [(BigNumber, BigNumber)]
timeTableBN x = scanl (\a b -> (somaBN (fst a) [1], somaBN (snd a) b)) ([], []) [x | _ <- [1..]]


----------------------- 2.1 -----------------------


type BigNumber = [Int]


----------------------- 2.2 -----------------------


-- | A função transforma uma String num Big-Number
scanner :: String -> BigNumber
scanner [] = []
scanner ['0'] = []
scanner [a] = [read [a] :: Int]
scanner (a:b:cs) | a == '-'  = toggleSignalBN (removeHeaderZerosBN [read [x] :: Int | x <- b:cs])
                 | otherwise = removeHeaderZerosBN [read [x] :: Int | x <- a:b:cs]


----------------------- 2.3 -----------------------


-- | A função transforma um Big-Number numa String
output :: BigNumber -> String
output [] = ['0']
output (x:xs) | x < 0 = '-' : bignumber
              | otherwise = bignumber
              where bignumber = foldr (\a b -> show (abs a) ++ b) [] (x:xs)


----------------------- 2.4 -----------------------


-- | A função retorna o Big-Number resultante da soma de dois Big-Numbers
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN [] [] = []
somaBN xs [] = xs
somaBN [] ys = ys
somaBN (x:xs) (y:ys) | x < 0 && y > 0 = subBN (y:ys) (toggleSignalBN (x:xs))
                     | x > 0 && y < 0 = subBN (x:xs) (toggleSignalBN (y:ys))
                     | x > 0 && y > 0 = somaBNAux (reverse (x:xs)) (reverse (y:ys)) 0
                     | otherwise = toggleSignalBN (somaBNAux (reverse (toggleSignalBN (x:xs))) (reverse (toggleSignalBN (y:ys))) 0)


-- | A função auxilia a função somaBN, retorna o Big-Number resultante da soma de dois Big-Numbers
-- Recebe como argumento o inverso dos números que queremos adicionar e um inteiro que irá representar o carry (deve ser inicializada com: (reverse bn1) (reverse bn2) 0)
somaBNAux :: BigNumber -> BigNumber -> Int -> BigNumber
somaBNAux [] [] 0             = []
somaBNAux [] [] carry         = [carry]
somaBNAux [] bs 0             = reverse bs
somaBNAux [] (b:bs) carry     = somaBNAux [] bs ((b + carry) `div` 10) ++ [(b + carry) `mod` 10]
somaBNAux as [] 0             = reverse as
somaBNAux (a:as) [] carry     = somaBNAux as [] ((a + carry) `div` 10) ++ [(a + carry) `mod` 10]
somaBNAux (a:as) (b:bs) carry = somaBNAux as bs ((a + b + carry) `div` 10) ++ [(a + b + carry) `mod` 10]


----------------------- 2.5 -----------------------


-- | A função retorna o Big-Number resultante da subtração de dois Big-Numbers
subBN :: BigNumber -> BigNumber -> BigNumber
subBN [] [] = []
subBN xs [] = xs
subBN [] ys = toggleSignalBN ys
subBN (x:xs) (y:ys) | (x:xs) == (y:ys) = []
                    | x < 0 && y > 0 = toggleSignalBN (somaBN (toggleSignalBN (x:xs)) (y:ys))
                    | x > 0 && y < 0 = somaBN (x:xs) (toggleSignalBN (y:ys))
                    | x < 0 && y < 0 = subBN (toggleSignalBN (y:ys)) (toggleSignalBN (x:xs))
                    | greaterThanBN (x:xs) (y:ys) = removeHeaderZerosBN(subBNAux (reverse bn1) (reverse bn2))
                    | otherwise = toggleSignalBN (removeHeaderZerosBN (subBNAux (reverse bn2) (reverse bn1)))
                    where bn1 = addHeaderZerosBN (length (y:ys) - length (x:xs)) (x:xs)
                          bn2 = addHeaderZerosBN (length (x:xs) - length (y:ys)) (y:ys)


-- | A função auxilia a função subBN, retorna o Big-Number resultante da subtração de dois Big-Numbers
-- Recebe como argumento o inverso dos números que queremos subtrair (deve ser inicializada com: (reverse bn1) (reverse bn2))
subBNAux :: BigNumber -> BigNumber -> BigNumber
subBNAux [] [] = []
subBNAux xs [] = reverse xs
subBNAux [] ys = toggleSignalBN (reverse ys)
subBNAux (x:xs) (y:ys) | x < y = subBNAux xs ((head ys + 1) : tail ys) ++ [x + 10 - y]
                       | otherwise = subBNAux xs ys ++ [x - y]


----------------------- 2.6 -----------------------


-- | A função retorna o Big-Number resultante da multiplicação de dois Big-Numbers
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN [] [] = []
mulBN xs [] = []
mulBN [] ys = []
mulBN (x:xs) (y:ys) | x < 0 && y > 0 = toggleSignalBN (reverse (mulBNAux (reverse (toggleSignalBN (x:xs))) (reverse (y:ys))))
                    | x > 0 && y < 0 = toggleSignalBN (reverse (mulBNAux (reverse (x:xs)) (reverse (toggleSignalBN (y:ys)))))
                    | x < 0 && y < 0 = reverse (mulBNAux (reverse (toggleSignalBN (x:xs))) (reverse (toggleSignalBN (y:ys))))
                    | otherwise = reverse (mulBNAux (reverse (x:xs)) (reverse (y:ys)))


-- | A função auxilia a função mulBN, retorna o inverso do Big-Number resultante da multiplicação de dois Big-Numbers
-- Recebe como argumento o inverso dos números que queremos multiplicar (deve ser inicializada com: (reverse bn1) (reverse bn2))
mulBNAux :: BigNumber -> BigNumber -> BigNumber
mulBNAux [] [] = []
mulBNAux xs [] = []
mulBNAux [] ys = []
mulBNAux (x:xs) (y:ys) = reverse (somaBNAux (mulLineBN y (x:xs) 0) (addHeaderZerosBN 1 (mulBNAux (x:xs) ys)) 0)


-- | A função auxilia a função mulBNAux, retorna o Big-Number resultante da multiplicação de um Big-Number por um dígito que recebe como argumento
-- Recebe como argumento o inverso do Big-Number que queremos multiplicar e um inteiro que irá representar o carry (deve ser inicializada com: dígito (reverse bn1) 0)
mulLineBN :: Int -> BigNumber -> Int -> BigNumber
mulLineBN _ [] 0 = []
mulLineBN _ [] carry = [carry]
mulLineBN x (y:ys) carry = ((x * y + carry) `mod` 10) : mulLineBN x ys ((x * y + carry) `div` 10)


----------------------- 2.7 -----------------------


-- | A função retorna o resultado da divisão de dois Big-Numbers no formato (quociente, resto), também estes no formato de Big-Number
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN [] ys = ([], [])
divBN (x:xs) ys = let r = divBNAux xs ys [] [x] in (removeHeaderZerosBN (fst r), snd r)


-- | A função auxilia a função divBN, retorna o resultado da divisão de dois Big-Numbers no formato (quociente, resto), também estes no formato de Big-Numbers
-- Recebe como argumento os números que queremos dividir, o quociente e o resto utilizados em cálculos intermediários (deve ser inicializada com: (tail bn1) bn2 [] [head bn1])
divBNAux :: BigNumber -> BigNumber -> BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBNAux [] ys q r = let a = slowDivBN r ys in (q ++ fst a, snd a)
divBNAux (x:xs) ys q r = let a = slowDivBN r ys in divBNAux xs ys (q ++ fst a) (snd a ++ [x])


-- | A função auxilia a função divBNAux, retorna o resultado da divisão de dois Big-Numbers no formato (quociente, resto), também estes no formato de Big-Numbers
slowDivBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
slowDivBN xs ys = (if null (fst r) then [0] else fst r, subBN xs (snd r))
            where r = head (filter (\x -> greaterThanBN (somaBN (snd x) ys) xs) (timeTableBN ys))


----------------------- 5.0 -----------------------


-- | A função retorna o resultado da divisão de dois Big-Numbers no formato (quociente, resto), detetando divisões por zero em compile-time
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN xs [] = Nothing 
safeDivBN xs ys = Just (divBN xs ys)