module Main where

_length :: [Integer] -> Integer

_length [] = 0

_length (car:cdr) = _length cdr + 1

-- 1
-- Sum elements of an array

sum_array :: [Integer] -> Integer

sum_array [] = 0
sum_array (x:xs) = x + sum_array xs

-- 3
-- BMI - Indice massa corporea 19 < x < 25 ok x>25 grasso x<19 magro

bmi :: (RealFloat a) => a -> a -> String 

bmi p h
	| _bmi < 19 = "sei magro pirla"  
	| _bmi > 25 = "curati ciccione"
	| _bmi < 25 && _bmi > 19 = "bomber!" 
	| otherwise = "alieno"
	where _bmi = p/(h*h) 
	
-- 4
-- Sum using fold
sum' :: [Integer] -> Integer

--sum' xs = foldl (+) 0 xs
sum' xs = foldl (\acc x -> acc + x) 0 xs
 


--fibonacci using an infinite array

fib = ((map fib' [0 ..])!!)
	where
		fib' 0 = 1
		fib' 1 = 1
		fib' n = fib (n-1) + fib (n-2)
	
--terne pitagoriche

ternaPitagorica = [(a, b, c) | c <- [0 ..], a <- [0 .. c], b <- [0 .. a], a^2 + b^2 == c^2]

--prime numbers

isPrime :: Integer -> Bool

isPrime n 
	| n == 1 = True
	| n == 2 = True
	| n == 0 = False
	| any (== 0) rests = False
	| otherwise = True 
	where
		rests = map (\ x -> mod n x) [2 .. n-1] 
	 
primes n = [x | x <- [0..n], isPrime x]
			 





	  

main::IO()
main = undefined
