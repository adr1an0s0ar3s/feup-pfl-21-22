module BigNumber where

import Data.Char

----------------------- 2.1 -----------------------

type BigNumber = [Int]

----------------------- 2.2 -----------------------

scanner :: String -> BigNumber
scanner []         = []
scanner [a]        = [read [a] :: Int]
scanner (a:b:cs)   | a == '-'  = (- read [b] :: Int) : [read [x] :: Int | x <- cs]
                    | otherwise = [read [x] :: Int | x <- a:b:cs]

----------------------- 2.3 -----------------------

output :: BigNumber -> String
output [] = []
output (x:xs)  | x < 0 = '-' : bignumber
                | otherwise = bignumber
                where bignumber = foldr (\a b -> show (abs a) ++ b) [] (x:xs)

----------------------- 2.4 -----------------------

somaBn :: BigNumber -> BigNumber -> BigNumber
somaBn bn1 bn2 = reverse (dealWithCarry bn3)
    where bn1' = if diff >= 0 then reverse bn1 else reverse (fillWithZeros (abs diff) bn1)
          bn2' = if diff >= 0 then reverse (fillWithZeros diff bn2) else reverse bn2
          bn3 = zipWith (+) bn1' bn2'
          diff = length bn1 - length bn2

fillWithZeros :: Int -> BigNumber -> BigNumber
fillWithZeros n bn = [0 | x <- [1..n]] ++ bn

dealWithCarry :: BigNumber -> BigNumber
dealWithCarry [] = []
dealWithCarry [a]   | a >= 10   = (a `mod` 10) : [a `div` 10]
                    | otherwise = [a]
dealWithCarry (a:b:cs) | a >= 10 = a `mod` 10 : dealWithCarry ((b + a `div` 10) : cs)
                       | otherwise = a : dealWithCarry (b:cs)



-- Alternative way: funciona com números positivos apenas!
somaBn' :: BigNumber -> BigNumber -> BigNumber
somaBn' a b = somaBnAux (reverse a) (reverse b) 0

somaBnAux :: BigNumber -> BigNumber -> Int -> BigNumber
somaBnAux [] [] 0             = []
somaBnAux [] [] carry         = [carry]
somaBnAux [] (b:bs) carry     = somaBnAux [] bs ((b + carry) `div` 10) ++ [(b + carry) `mod` 10]
somaBnAux (a:as) [] carry     = somaBnAux as [] ((a + carry) `div` 10) ++ [(a + carry) `mod` 10]
somaBnAux (a:as) (b:bs) carry = somaBnAux as bs ((a + b + carry) `div` 10) ++ [(a + b + carry) `mod` 10]

----------------------- 2.5 -----------------------

toggleSignalBn :: BigNumber -> BigNumber
toggleSignalBn [] = []
toggleSignalBn (x:xs) = (-x):xs

ascendingBn :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
ascendingBn [] [] = ([], [])
ascendingBn (x:xs) [] = (x:xs, [])
ascendingBn [] (y:ys) = (y:ys, [])
ascendingBn (x:xs) (y:ys)   | x < 0 && y > 0 = (x:xs, y:ys)
                            | x > 0 && y < 0 = (y:ys, x:xs)
                            | length (x:xs) < length (y:ys) = (x:xs, y:ys)
                            | length (x:xs) > length (y:ys) = (y:ys, x:xs)
                            | otherwise = ascendingBnAux (x:xs) (y:ys)

ascendingBnAux :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
ascendingBnAux [] [] = ([], [])
ascendingBnAux (x:xs) [] = (x:xs, [])
ascendingBnAux [] (y:ys) = (y:ys, [])
ascendingBnAux (x:xs) (y:ys)    | x < y = (x:xs, y:ys)
                                | x > y = (y:ys, x:xs)
                                | otherwise = (x : fst t, y : snd t)
                                where t = ascendingBnAux xs ys

--subBn :: BigNumber -> BigNumber -> BigNumber
