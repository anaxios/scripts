module Main where

import Lib

iseven :: Int -> Bool
iseven x = if x > 0 then isodd (x-1) else True

isodd :: Int -> Bool
isodd x = if x > 0 then iseven (x-1) else False

quickSort [] = []
quickSort (x:xs) = quickSort ys ++ [x] ++ quickSort zs
  where
    ys = [a | a <- xs, a <= x]
    zs = [b | b <- xs, b > x]

a = [2,5,4,7,8,9,6,5,4,23,5,8,8654,5,7,88,4,4,3,7,8,9,9,9,8,7,6,5,4,3,4,5,6,7,7,8,8,123457765,3576584956796,87564983475,958606806986,4567,87654,234780,79486,36997486,5657485,2,5,4,7,8,9,6,5,4,23,5,8,8654,5,7,88,4,4,3,7,8,9,9,9,8,7,6,5,4,3,4,5,6,7,7,8,8,123457765,3576584956796,87564983475,958606806986,4567,87654,234780,79486,36997486,565748]
main :: IO ()
main = do

 putStrLn (show $ iseven 5)
 putStrLn (show $ iseven 10)
 putStrLn (show $ isodd 5)
 putStrLn (show $ isodd 15)

data Church x = Church ((x -> x) -> x -> x)

zero :: Church x
zero = Church (\f x -> x)

-- Hack to not clash with the standard succ
succ_ :: Church x -> Church x
succ_ (Church n) = Church (\f x -> (f (n f x)))

instance (Num x) => Show (Church x) where
  show (Church f) = show $ f (1 +) 0
