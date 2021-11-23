module BigNumber where

import Data.Char

----------------------- 2.1 -----------------------

type BigNumber = [Int]

----------------------- 2.2 -----------------------

scanner :: String -> BigNumber
scanner s = if head s == '-' then [- digitToInt x | x <- take 1 s'] ++ [digitToInt x | x <- tail s']
            else [digitToInt x | x <- s]
            where s' = tail s

scanner' :: String -> BigNumber
scanner' []         = []
scanner' [a]        = [read [a] :: Int]
scanner' (a:b:cs)   | a == '-'  = (- read [b] :: Int) : [read [x] :: Int | x <- cs]
                    | otherwise = [read [x] :: Int | x <- a:b:cs]

----------------------- 2.3 -----------------------

output :: BigNumber -> String
output bignumber = if head bignumber < 0 then "-" ++ bignumber'
                   else [intToDigit x | x <- bignumber]
                   where bignumber' = [intToDigit (abs x) | x <- bignumber]

output' :: BigNumber -> String
output' [] = []
output' (x:xs)  | x < 0 = '-' : bignumber
                | otherwise = bignumber
                where bignumber = foldr (\a b -> show (abs a) ++ b) [] (x:xs)

----------------------- 2.4 -----------------------

somaBn :: BigNumber -> BigNumber -> BigNumber
somaBn bn1 bn2 = reverse (dealWithCarry bn3)
                 where
                     bn1' = if diff >= 0 then reverse (fillWithZeros 0 bn1) else reverse (fillWithZeros (abs diff) bn1)
                     bn2' = if diff >= 0 then reverse (fillWithZeros diff bn2) else reverse (fillWithZeros 0 bn2)
                     bn3 = zipWith(+) bn1' bn2'
                     diff = length bn1 - length bn2


fillWithZeros :: Int -> BigNumber -> BigNumber
fillWithZeros n bn = [ x * 0 | x <- [1..n]] ++ bn


dealWithCarry :: BigNumber -> BigNumber
dealWithCarry [] = []
dealWithCarry (x:xs) | x > 10 = x `mod` 10 : dealWithCarry (replaceFirst (head xs + 1) xs)
                     | x == 10 = 0 : dealWithCarry (replaceFirst (head xs + 1) xs)
                     | otherwise = x : dealWithCarry xs


replaceFirst :: a -> [a] -> [a]
replaceFirst newVal (x:xs) = newVal:xs         