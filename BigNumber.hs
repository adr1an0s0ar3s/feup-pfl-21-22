module BigNumber where

import Data.Char


-------------------- Auxilixary --------------------


addHeaderZerosBN :: Int -> BigNumber -> BigNumber
addHeaderZerosBN x bn = [0 | _ <- [1..x]] ++ bn

removeHeaderZerosBN :: BigNumber -> BigNumber
removeHeaderZerosBN [] = []
removeHeaderZerosBN (x:xs) | x /= 0 = x:xs
                           | otherwise = removeHeaderZerosBN xs

toggleSignalBN :: BigNumber -> BigNumber
toggleSignalBN [] = []
toggleSignalBN (x:xs)   | x == 0 = x : toggleSignalBN xs
                        | otherwise = (-x):xs

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


----------------------- 2.1 -----------------------


type BigNumber = [Int]


----------------------- 2.2 -----------------------


scanner :: String -> BigNumber
scanner []         = []
scanner [a]        = [read [a] :: Int]
scanner (a:b:cs)    | a == '-'  = (- read [b] :: Int) : [read [x] :: Int | x <- cs]
                    | otherwise = [read [x] :: Int | x <- a:b:cs]


----------------------- 2.3 -----------------------


output :: BigNumber -> String
output [] = []
output (x:xs)   | x < 0 = '-' : bignumber
                | otherwise = bignumber
                where bignumber = foldr (\a b -> show (abs a) ++ b) [] (x:xs)


----------------------- 2.4 -----------------------


somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN [] [] = []
somaBN xs [] = xs
somaBN [] ys = ys
somaBN (x:xs) (y:ys) | x < 0 && y > 0 = subBN (y:ys) (toggleSignalBN (x:xs))
                     | x > 0 && y < 0 = subBN (x:xs) (toggleSignalBN (y:ys))
                     | x > 0 && y > 0 = somaBNAux (reverse (x:xs)) (reverse (y:ys)) 0
                     | otherwise = toggleSignalBN (somaBNAux (reverse (toggleSignalBN (x:xs))) (reverse (toggleSignalBN (y:ys))) 0)

somaBNAux :: BigNumber -> BigNumber -> Int -> BigNumber
somaBNAux [] [] 0             = []
somaBNAux [] [] carry         = [carry]
somaBNAux [] bs 0             = reverse bs
somaBNAux [] (b:bs) carry     = somaBNAux [] bs ((b + carry) `div` 10) ++ [(b + carry) `mod` 10]
somaBNAux as [] 0             = reverse as
somaBNAux (a:as) [] carry     = somaBNAux as [] ((a + carry) `div` 10) ++ [(a + carry) `mod` 10]
somaBNAux (a:as) (b:bs) carry = somaBNAux as bs ((a + b + carry) `div` 10) ++ [(a + b + carry) `mod` 10]


----------------------- 2.5 -----------------------


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

subBNAux :: BigNumber -> BigNumber -> BigNumber
subBNAux [] [] = []
subBNAux (x:xs) (y:ys)  | x < y = subBNAux xs ((head ys + 1) : tail ys) ++ [x + 10 - y]
                        | otherwise = subBNAux xs ys ++ [x - y]


----------------------- 2.6 -----------------------

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN [] [] = []
mulBN xs [] = []
mulBN [] ys = []
mulBN (x:xs) (y:ys) | x < 0 && y > 0 = toggleSignalBN (reverse (mulBNAux (reverse (toggleSignalBN (x:xs))) (reverse (y:ys))))
                    | x > 0 && y < 0 = toggleSignalBN (reverse (mulBNAux (reverse (x:xs)) (reverse (toggleSignalBN (y:ys)))))
                    | x < 0 && y < 0 = reverse (mulBNAux (reverse (toggleSignalBN (x:xs))) (reverse (toggleSignalBN (y:ys))))
                    | otherwise = reverse (mulBNAux (reverse (x:xs)) (reverse (y:ys)))

mulBNAux :: BigNumber -> BigNumber -> BigNumber
mulBNAux [] [] = []
mulBNAux xs [] = []
mulBNAux [] ys = []
mulBNAux (x:xs) (y:ys) = reverse (somaBNAux (mulLineBN y (x:xs) 0) (addHeaderZerosBN 1 (mulBNAux (x:xs) ys)) 0)

mulLineBN :: Int -> BigNumber -> Int -> BigNumber
mulLineBN _ [] 0 = []
mulLineBN _ [] carry = [carry]
mulLineBN x (y:ys) carry = ((x * y + carry) `mod` 10) : mulLineBN x ys ((x * y + carry) `div` 10)


----------------------- 2.7 -----------------------


divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN (x:xs) (y:ys) | (x:xs) == (y:ys) = ([1], [])
                    | not (greaterThanBN (x:xs) (y:ys)) = ([], x:xs)
                    | otherwise = divBNAux (x:xs) (y:ys)

divBNAux :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBNAux (x:xs) (y:ys)  = (fst resultBothPos, subBN (x:xs) (snd resultBothPos))
                          where resultBothPos = head [(i, a) | (i, a) <- zip [scanner (show b) | b <- [1..]] [mulBN (y:ys) (scanner (show b)) | b <- [1..]], a == (x:xs) || greaterThanBN (somaBN a (y:ys)) (x:xs)]
