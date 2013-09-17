module Main where

half x = (x `div` 2, "ho diviso: " ++ (show x))
			

data MyWriter w a = MyWriter { write :: (a, w) } 

newtype State st a = State (st -> (st, a))

main::IO()
main = undefined
