inc n = n + 1


length' :: [Integer] -> Integer  
length' [] = 0 
length' (_:xs) = 1 + length' xs

main :: IO()
main = print $ length' [1, 2, 3]
