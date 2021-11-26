module BigNumber where

import Data.Char

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

somaBn :: BigNumber -> BigNumber -> BigNumber
somaBn a b = somaBnAux (reverse a) (reverse b) 0

somaBnAux :: BigNumber -> BigNumber -> Int -> BigNumber
somaBnAux [] [] 0             = []
somaBnAux [] [] carry         = [carry]
somaBnAux [] bs 0             = reverse bs
somaBnAux [] (b:bs) carry     = somaBnAux [] bs ((b + carry) `div` 10) ++ [(b + carry) `mod` 10]
somaBnAux as [] 0             = reverse as
somaBnAux (a:as) [] carry     = somaBnAux as [] ((a + carry) `div` 10) ++ [(a + carry) `mod` 10]
somaBnAux (a:as) (b:bs) carry = somaBnAux as bs ((a + b + carry) `div` 10) ++ [(a + b + carry) `mod` 10]

----------------------- 2.5 -----------------------

toggleSignalBn :: BigNumber -> BigNumber
toggleSignalBn [] = []
toggleSignalBn (x:xs)   | x == 0 = x : toggleSignalBn xs
                        | otherwise = (-x):xs

greaterThanBn :: BigNumber -> BigNumber -> Bool
greaterThanBn [] [] = False
greaterThanBn xs [] = True
greaterThanBn [] ys = False
greaterThanBn (x:xs) (y:ys) | x < 0 && y < 0 = toggleSignalBn bn1 < toggleSignalBn bn2
                            | otherwise = bn1 > bn2
                            where   bn1 = [0 | _ <- [1 .. length (y:ys) - length (x:xs)]] ++ x:xs
                                    bn2 = [0 | _ <- [1 .. length (x:xs) - length (y:ys)]] ++ y:ys

subBn :: BigNumber -> BigNumber -> BigNumber
subBn a b	| a == b = [0]
            | greaterThanBn a b = subBnAux (reverse bn1) (reverse bn2)
    		| otherwise = toggleSignalBn (subBnAux (reverse bn2) (reverse bn1))
			where   bn1 = [0 | _ <- [1 .. length b - length a]] ++ a
                                bn2 = [0 | _ <- [1 .. length a - length b]] ++ b

subBnAux :: BigNumber -> BigNumber -> BigNumber
subBnAux [] [] = []
subBnAux xs [] = xs
subBnAux (x:xs) (y:ys)  | x <= y = subBnAux xs ((head ys + 1):(tail ys)) ++ [x + 10 - y]
                        | otherwise = subBnAux xs ys ++ [x - y]


--   1 10 10 10
--   1  1 10 9
--   0  9  0  1