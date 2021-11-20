module BigNumber where

import Data.Char

----------------------- 2.1 -----------------------

type BigNumber = [Int]

----------------------- 2.2 -----------------------

scanner :: String -> BigNumber 
scanner s = if head s == '-' then [- digitToInt x | x <- take 1 s'] ++ [digitToInt x | x <- tail s']
            else [digitToInt x | x <- s]
            where s' = tail s

----------------------- 2.3 -----------------------

output :: BigNumber  -> String
output bignumber = if head bignumber < 0 then "-" ++ bignumber'
                   else [intToDigit x | x <- bignumber]
                   where bignumber' = [intToDigit (abs x) | x <- bignumber]