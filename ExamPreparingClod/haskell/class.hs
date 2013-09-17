module Main where
--import Tree

--take' 0 _ = []
--take' _ [] = []
--take' n (x:xs) = x : take' (n-1) xs

--powset set = powset' set [[]] where
--	powset' [] out = out
--	powset' (e:set) out = powset' set (out ++ [e:x | x <- out])


--data Point = Point Float Float

--pointx ( Point x _ ) = x
--pointy ( Point _ y ) = y 

data Tree a = Leaf a | Branch (Tree a) (Tree a)

instance (Eq a) => Eq (Tree a) where
Leaf a == Leaf b
(Branch l1 r1) == (Branc l2 r2) = (l1==l2) && (r1==r2)
_ == _ = False

main::IO()
main = undefined
