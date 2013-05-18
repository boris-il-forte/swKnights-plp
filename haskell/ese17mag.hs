-- Haskell exercises, May 17, 2013

-- Write a function which sums the elements of an array
-- sum' :: (Num a) => [a] -> a
-- sum' [] = 0
-- sum' (x:xs) = x + sum' xs

-- Array length
length' :: (Num b) => [a] -> b
length' [] = 0
length' (_:xs) = length' xs + 1

-- BMI (body mass index) given weight and height
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
	| bmi <= skinny = "Underweight!"
	| bmi <= normal = "Normal!"
	| bmi <= fat = "Fat!"
	| otherwise = "A whale!"
	where bmi = weight / height^2
	      skinny = 18.5
	      normal = 25.0
	      fat = 30.0

-- Array sum, reloaded
sum' :: (Num a) => [a] -> a
-- sum' xs = foldl (\acc x -> acc + x) 0 xs -- a variant
sum' xs = foldl1 (+) xs -- yet another

-- Length strict
lengths' :: (Num b) => [a] -> b
lengths' xs = len xs 0
	where
	len [] k = k
	len (_:xs) k = let inc = k + 1
				   in inc `seq` len xs inc -- force computation of inc

-- Fibonacci with mapping to a infinite array
fibM = ((map fib' [0..]) !!)
	where
		fib' 0 = 0
		fib' 1 = 1
		fib' n = fibM(n - 1) + fibM(n - 2)

-- List comprehensions, basic example
lco1::IO()
lco1 = print $ [ (a, b) | a <- [1..10], b <- ["a", "b"], odd a] -- cartesian product of a and b, filtered by 'odd a'

-- Print all the triangles with sides between 1 and 10
-- so that the sum of their sides is equal to 24
tri::IO()
tri = print $ [ (a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a + b + c == 24]

-- Defining new data types
-- A data structure for logic formulae
data Fma = Boolean Bool 
     | Atom String
     | And [Fma]
     | Or [Fma]
     | Iff Fma Fma
     deriving (Show, Eq)

main::IO()
main = print $ (And [(Boolean True), (Atom "ciao")])

-- Functional quicksort (nb - choosing as a pivot array head)
qsort [] = []
qsort (x:xs) = qsort [y | y <- xs, y < x] ++ [x] ++ qsort [z | z <- xs, z >= x]
