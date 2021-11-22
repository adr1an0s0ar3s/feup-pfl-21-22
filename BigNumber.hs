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