module EserciziDaveVari where

import Control.Monad.State
       
-- Esercitazione di haskell fatta da dave

--  sum Elements of array
sumElements [] = 0
sumElements (x:xs) = x + sumElements xs

--  lenght array
lenghtArray [] = 0
lenghtArray (_:xs) = 1 + lenghtArray xs

-- sum with fold
sumArrayF x = foldl (+) 0 x

-- Lenght strict
lenghtArray' [] = 0
lenghtArray' (_:xs) = let rest = (lenghtArray' xs) in seq rest (1+rest)


--  well formed formulas

infixl 5 :<==>:
infixl 6 :==>:  
infixl 7 :%: 
infixl 8 :|: 
infixl 9 :&:


data Exp = Boolean Bool | (:-:) Exp | (:&:) Exp Exp | (:|:) Exp Exp | (:%:) Exp Exp | (:==>:) Exp Exp | (:<==>:) Exp Exp | Atom String deriving (Eq)

instance Show Exp where
	show (Boolean b) = show b
	show ((:-:) a) = "~" ++ show a
	show ((:&:) a b) = "(" ++ show(a) ++ " && "  ++ show(b) ++ ")"
	show ((:|:) a b) = "(" ++ show(a)  ++ " || " ++ show(b) ++ ")"
	show ((:%:) a b) = "(" ++ show(a) ++ " xor " ++ show(b) ++ ")"
	show ((:==>:) a b) = "(" ++ show(a) ++ " ==> " ++ show(b) ++ ")"
	show ((:<==>:) a b) = "(" ++ show(a)  ++ " <==> " ++ show(b) ++ ")"
	show (Atom s) = show s
	

x = Atom "x"
y = Atom "y"
z = Atom "z"
true = Boolean True
false = Boolean False
formula = true :|: x:&:y :==>: z
formula1 = (z :|: x) :&:y :==>: z

-- terne pitagoriche

terne = [(x, y, z) |  z <- [1 .. ], y <- [1 .. z], x <- [1 .. y], x^2 + y^2 == z^2] 

-- trova tutti i numeri fino a che cond è valida

findFirstThat cond = takeWhile cond [0..]


-- operatore prodotto scalare
infixl 8 ***
(***) a b = foldl1 (+) [h*k | (h,k) <- zip a b]
vmod a = sqrt $ a *** a 


-- revmap
revmap f = foldl (\x y -> (f y):x) []

-- listoid
class Listoid l where
	lcons :: a -> l a -> l a
	lunit :: a -> l a
	lappend :: l a -> l a -> l a
	lfirst :: l a -> a
	llast :: l a -> a
	lrest :: l a -> l a
	
newtype LL a = LL ([a], a) deriving Eq

instance (Listoid LL) where
	lunit x = LL ([], x)
	lcons x (LL (r, l)) = LL (x:r, l) 
	lappend (LL (a,b)) (LL (c, d)) = LL(a++(b:c),d)
	lfirst (LL (x:xs, y)) = x
	lfirst (LL ([], y)) = y
	llast (LL (x, y)) = y
	lrest (LL ([], y)) =  error "rest on listoid unit"
	lrest (LL (x:xs, y)) = LL (xs, y)
	
instance Show a => Show (LL a) where
	show x = "LL " ++ show' x where
		show' (LL (x:xs, y)) = show x ++ " " ++ show' (LL (xs, y))
		show' (LL ([], y)) = show y
		
		
getCVS = do 
	{
		c <- getChar;
		if ((c == ',') || (c == ';')) then return "" 
		else do 
		{
			l <- getCVS;
			return (c:l);
		}
	}
	
myUnless c b = do
	{
		val <- c;
		if val then return ()
		else do
		{
			b;
			myUnless c b;
		}
		
	}
	
newtype SimpleObject a = SimpleObject (a, [(String, (a -> a -> a))])

call (SimpleObject (this, [])) _ _ = error "no such method"
call (SimpleObject (this, ((first, method):others))) mname input | (first == mname) = method this input
								 | otherwise = call (SimpleObject (this,others)) mname input 

								 
-- esame monadi

mapListM mfunction (x:xs) = do 
			{
				nx <- mfunction x;
				nxs <- mapListM mfunction xs;
				return (nx:nxs);
			}

mapListM mfunction [] = do return [] 

numberList l = mapListM (\x -> 	do 
				{
					state <- get;
					put (state + x);
					return (x,  (state + x));
				}) l


	


