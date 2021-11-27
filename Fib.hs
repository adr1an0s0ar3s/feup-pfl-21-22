import BigNumber

----------------------- 1.1 -----------------------

fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec x = fibRec (x-1) + fibRec (x-2)

----------------------- 1.2 -----------------------

fibLista :: (Integral a) => a -> a
fibLista x = fibListaAux x [0,1]

fibListaAux :: (Integral a) => a -> [a] -> a
fibListaAux 0 [x,y] = x
fibListaAux 1 [x,y] = y
fibListaAux a [x,y] = fibListaAux (a-1) [y,x+y]

----------------------- 1.3 -----------------------

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita x = fib !! fromIntegral x

fib :: (Integral a) => [a]
fib = 0 : 1 : [n | x <- [2..], let n = fib !! (x-1) + fib !! (x-2)]

----------------------- 3.0 -----------------------

fibRecBN :: BigNumber -> BigNumber
fibRecBN [] = []
fibRecBN [1] = [1]
fibRecBN bn = somaBN (fibRecBN (subBN bn [1])) (fibRecBN (subBN bn [2]))