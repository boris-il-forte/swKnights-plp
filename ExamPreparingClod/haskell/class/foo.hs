module Main where

data Tree a = Leaf a | Branch (Tree a) (Tree a)

instance (Eq a)    => Eq (Tree a) where
	Leaf a		   == Leaf b			= a == b
	(Branch l1 r1) == (Branch l2 r2) 	= (l1==l2) && (r1==r2)
	_			   == _					= False

instance (Show a) => Show (Tree a) where
	show (Leaf a) = show a
	show (Branch x y) = "<" ++ show x ++ " | " ++ show y ++ ">"

mapTree :: (a -> b) -> Tree a -> Tree b
mapTree f (Leaf a) = Leaf (f a)
mapTree f (Branch lhs rhs) = Branch (mapTree f lhs) 
									(mapTree f rhs)

main::IO()
main = undefined
