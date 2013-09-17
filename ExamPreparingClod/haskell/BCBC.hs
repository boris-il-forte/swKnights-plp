module Main where


data Item = Num Int | St String deriving Show

data Clod = Clod [[String]] deriving Show

type Struct = [[Item]]

k m m' = [(x:xs) | x <- m, xs <- m']


main::IO()
main = print(bikes) where bikes = [Num 1, St "pippo"]

