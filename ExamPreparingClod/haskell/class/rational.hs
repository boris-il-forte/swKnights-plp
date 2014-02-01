module Main where

data Rat = Rat Integer Integer deriving (Eq)

--Rat x y --> Rat dove x e y devono essere interi!

simplify x y = let g = gcd x y
			   in Rat(div x g) (div y g)	

instance Num Rat where
	(Rat x y) + (Rat x' y') = simplify (x*y + x'*y') (y*y')
	(Rat x y) * (Rat x' y') = simplify (x*x') (y*y')
	(Rat x y) - (Rat x' y') = simplify (x*y - x'*y') (y*y')
	




main::IO()
main = undefined
