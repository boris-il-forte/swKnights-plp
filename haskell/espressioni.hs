module Expressions where

data Atom = S String | N Int deriving Eq
data Exp = A Atom | E Atom [Exp] deriving Eq

instance Show(Atom) where
	show (N a) = show a
	show (S a) = filter (\x -> x /= '"') (show a)

instance Show(Exp) where
	show (A a) = show a
	show (E a b) = show a ++ "(" ++ showlist b where
		showlist [x] = show x ++ ")"
		showlist (x:xs) = show x ++ "," ++ showlist xs
		
		
subst x y (A e) | (e == x) = A y
		| otherwise = A e
subst x y (E a b) | (a == x) = E y (map (subst x y) b)
		  | otherwise =  E a (map (subst x y) b)