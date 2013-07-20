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

